package service;

import entity.sga.Acquisto;
import entity.sga.Biglietto;
import entity.sgp.Posto;
import entity.sgp.Programmazione;
import repository.sga.BigliettoDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

//SERVICE per la gestione della logica business dei Biglietti

public class BigliettoService {

    private Connection connection;
    private BigliettoDAO bigliettoDAO;

    public BigliettoService(Connection connection) {
        this.connection = connection;
        this.bigliettoDAO = new BigliettoDAO(connection);
    }


    //GENERA BIGLIETTO DIGITALE
    //Chiamato da AcquistoFacade dopo il pagamento confermato.
    //Crea un biglietto con QR code univoco nello stato "Emesso".

    public Biglietto generaBiglietto(
            int idAcquisto,
            int idProgrammazione,
            int idPosto,
            double prezzoFinale
    ) throws SQLException {

        // Validazioni
        if (idAcquisto <= 0 || idProgrammazione <= 0 || idPosto <= 0) {
            throw new IllegalArgumentException("Parametri non validi per generare biglietto");
        }

        if (prezzoFinale <= 0) {
            throw new IllegalArgumentException("Il prezzo finale deve essere maggiore di zero");
        }

        // Crea oggetto Biglietto
        Biglietto biglietto = new Biglietto();
        biglietto.setPrezzoFinale(prezzoFinale);
        biglietto.setStato("Emesso"); // Stato iniziale: EMESSO
        biglietto.setDataUtilizzo(null); // Non ancora utilizzato

        // Genera QR Code UNIVOCO
        String qrCode = generaQRCodeUnivoco();
        biglietto.setQRCode(qrCode);

        // Associa Acquisto
        Acquisto acquisto = new Acquisto();
        acquisto.setIdAcquisto(idAcquisto);
        biglietto.setAcquisto(acquisto);

        // Associa Programmazione
        Programmazione programmazione = new Programmazione();
        programmazione.setIdProgrammazione(idProgrammazione);
        biglietto.setProgrammazione(programmazione);

        // Associa Posto
        Posto posto = new Posto();
        posto.setIdPosto(idPosto);
        biglietto.setPosto(posto);

        // Salva nel database
        boolean salvato = bigliettoDAO.doSave(biglietto);

        if (!salvato) {
            throw new SQLException("Impossibile salvare il biglietto nel database");
        }

        return biglietto;
    }

    //GENERA QR CODE UNIVOCO
    //Formato: TKT-{timestamp}-{uuid}
    //Esempio: TKT-20250514123045-a1b2c3d4
    private String generaQRCodeUnivoco() {
        String timestamp = LocalDateTime.now()
                .toString()
                .replaceAll("[^0-9]", "");

        String uuid = UUID.randomUUID()
                .toString()
                .substring(0, 8);

        return "TKT-" + timestamp + "-" + uuid;
    }


    //RECUPERA BIGLIETTO PER ID
    public Biglietto getBigliettoById(int idBiglietto) throws SQLException {
        Biglietto biglietto = bigliettoDAO.doRetrieveById(idBiglietto);

        if (biglietto == null) {
            throw new IllegalArgumentException(
                    "Biglietto con ID " + idBiglietto + " non trovato"
            );
        }

        return biglietto;
    }

    //RECUPERA BIGLIETTO PER QR CODE
    public Biglietto getBigliettoByQRCode(String qrCode) throws SQLException {
        if (qrCode == null || qrCode.isEmpty()) {
            throw new IllegalArgumentException("QR Code non valido");
        }

        Biglietto biglietto = bigliettoDAO.doRetrieveByQRCode(qrCode);

        if (biglietto == null) {
            throw new IllegalArgumentException(
                    "Biglietto con QR Code " + qrCode + " non trovato"
            );
        }

        return biglietto;
    }

    //RECUPERA TUTTI I BIGLIETTI DI UN ACQUISTO
    public List<Biglietto> getBigliettiPerAcquisto(int idAcquisto) throws SQLException {
        return bigliettoDAO.doRetrieveByAcquisto(idAcquisto);
    }

    //RECUPERA TUTTI I BIGLIETTI DI UN UTENTE
    public List<Biglietto> getBigliettiPerUtente(int idAccount, boolean soloValidi)
            throws SQLException {

        List<Biglietto> tuttiBiglietti = bigliettoDAO.doRetrieveByUtente(idAccount);

        if (soloValidi) {
            // Filtra solo biglietti "Emesso" (validi per ingresso)
            return tuttiBiglietti.stream()
                    .filter(b -> "Emesso".equals(b.getStato()))
                    .toList();
        }

        return tuttiBiglietti;
    }


    //RIMBORSA BIGLIETTO

    public boolean rimborsaBiglietto(int idBiglietto) throws SQLException {
        Biglietto biglietto = getBigliettoById(idBiglietto);

        // Non si possono rimborsare biglietti già validati
        if ("Validato".equals(biglietto.getStato())) {
            throw new IllegalStateException(
                    "Impossibile rimborsare un biglietto già validato"
            );
        }

        return bigliettoDAO.doUpdateStato(idBiglietto, "Rimborsato");
    }

    //SEGNA BIGLIETTO COME SCADUTO

    public boolean scadiBiglietto(int idBiglietto) throws SQLException {
        Biglietto biglietto = getBigliettoById(idBiglietto);

        // Solo biglietti "Emesso" possono scadere
        if (!"Emesso".equals(biglietto.getStato())) {
            throw new IllegalStateException(
                    "Solo biglietti emessi possono scadere. Stato attuale: "
                            + biglietto.getStato()
            );
        }

        return bigliettoDAO.doUpdateStato(idBiglietto, "Scaduto");
    }

    //SCADI TUTTI I BIGLIETTI DI UNA PROGRAMMAZIONE
    public int scadiBigliettiProgrammazione(int idProgrammazione) throws SQLException {
        List<Biglietto> biglietti = bigliettoDAO.doRetrieveByProgrammazione(idProgrammazione);

        int scaduti = 0;
        for (Biglietto biglietto : biglietti) {
            // Scadi solo quelli "Emessi" (non validati)
            if ("Emesso".equals(biglietto.getStato())) {
                boolean aggiornato = bigliettoDAO.doUpdateStato(
                        biglietto.getIdBiglietto(),
                        "Scaduto"
                );
                if (aggiornato) {
                    scaduti++;
                }
            }
        }

        return scaduti;
    }

    //VERIFICA SE UN BIGLIETTO È UTILIZZABILE
    public boolean isBigliettoUtilizzabile(int idBiglietto) throws SQLException {
        Biglietto biglietto = getBigliettoById(idBiglietto);

        // Verifica stato
        if (!"Emesso".equals(biglietto.getStato())) {
            return false;
        }

        // Verifica data (programmazione non passata)
        LocalDate oggi = LocalDate.now();
        LocalDate dataProiezione = biglietto.getProgrammazione().getDataProgrammazione();

        return !dataProiezione.isBefore(oggi);
    }



    //RECUPERA BIGLIETTI PER PROGRAMMAZIONE
    public List<Biglietto> getBigliettiPerProgrammazione(int idProgrammazione)
            throws SQLException {
        return bigliettoDAO.doRetrieveByProgrammazione(idProgrammazione);
    }


    private void validaStato(String stato) {
        List<String> statiValidi = List.of("Emesso", "Validato", "Scaduto", "Rimborsato");

        if (stato == null || !statiValidi.contains(stato)) {
            throw new IllegalArgumentException(
                    "Stato non valido. Stati ammessi: " + statiValidi
            );
        }
    }
}