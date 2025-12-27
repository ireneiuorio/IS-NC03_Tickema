package service.sga;

import entity.sga.Acquisto;
import entity.sga.Biglietto;
import entity.sgp.Posto;
import entity.sgp.Programmazione;
import exception.sga.acquisto.biglietto.*;
import repository.sga.BigliettoDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public class BigliettoService {

    private Connection connection;
    private BigliettoDAO bigliettoDAO;

    public BigliettoService(Connection connection) {
        this.connection = connection;
        this.bigliettoDAO = new BigliettoDAO(connection);
    }

    public Biglietto generaBiglietto(
            int idAcquisto,
            int idProgrammazione,
            int idPosto,
            double prezzoFinale
    ) throws BigliettoNonValidoException, GenerazioneBigliettoException, SQLException {

        if (idAcquisto <= 0 || idProgrammazione <= 0 || idPosto <= 0) {
            throw new BigliettoNonValidoException("Parametri non validi per generare biglietto");
        }

        if (prezzoFinale <= 0) {
            throw new BigliettoNonValidoException("Il prezzo finale deve essere maggiore di zero");
        }

        Biglietto biglietto = new Biglietto();
        biglietto.setPrezzoFinale(prezzoFinale);
        biglietto.setStato("Emesso");
        biglietto.setDataUtilizzo(null);

        String qrCode = generaQRCodeUnivoco();
        biglietto.setQRCode(qrCode);

        Acquisto acquisto = new Acquisto();
        acquisto.setIdAcquisto(idAcquisto);
        biglietto.setAcquisto(acquisto);

        Programmazione programmazione = new Programmazione();
        programmazione.setIdProgrammazione(idProgrammazione);
        biglietto.setProgrammazione(programmazione);

        Posto posto = new Posto();
        posto.setIdPosto(idPosto);
        biglietto.setPosto(posto);

        boolean salvato = bigliettoDAO.doSave(biglietto);

        if (!salvato) {
            throw new GenerazioneBigliettoException("Impossibile salvare il biglietto nel database");
        }

        return biglietto;
    }

    private String generaQRCodeUnivoco() {
        String timestamp = LocalDateTime.now()
                .toString()
                .replaceAll("[^0-9]", "");

        String uuid = UUID.randomUUID()
                .toString()
                .substring(0, 8);

        return "TKT-" + timestamp + "-" + uuid;
    }

    public Biglietto getBigliettoById(int idBiglietto) throws BigliettoNonTrovatoException, SQLException {
        Biglietto biglietto = bigliettoDAO.doRetrieveById(idBiglietto);

        if (biglietto == null) {
            throw new BigliettoNonTrovatoException(idBiglietto);
        }

        return biglietto;
    }

    public Biglietto getBigliettoByQRCode(String qrCode)
            throws BigliettoNonValidoException, BigliettoNonTrovatoException, SQLException {

        if (qrCode == null || qrCode.isEmpty()) {
            throw new BigliettoNonValidoException("QR Code non valido");
        }

        Biglietto biglietto = bigliettoDAO.doRetrieveByQRCode(qrCode);

        if (biglietto == null) {
            throw new BigliettoNonTrovatoException(qrCode);
        }

        return biglietto;
    }

    public List<Biglietto> getBigliettiPerAcquisto(int idAcquisto) throws SQLException {
        return bigliettoDAO.doRetrieveByAcquisto(idAcquisto);
    }

    public List<Biglietto> getBigliettiPerUtente(int idAccount, boolean soloValidi)
            throws SQLException {

        List<Biglietto> tuttiBiglietti = bigliettoDAO.doRetrieveByUtente(idAccount);

        if (soloValidi) {
            return tuttiBiglietti.stream()
                    .filter(b -> "Emesso".equals(b.getStato()))
                    .toList();
        }

        return tuttiBiglietti;
    }

    public boolean rimborsaBiglietto(int idBiglietto)
            throws BigliettoNonTrovatoException, RimborsoBigliettoNonConsentitoException, SQLException {

        Biglietto biglietto = getBigliettoById(idBiglietto);

        if ("Validato".equals(biglietto.getStato())) {
            throw new RimborsoBigliettoNonConsentitoException(idBiglietto, biglietto.getStato());
        }

        return bigliettoDAO.doUpdateStato(idBiglietto, "Rimborsato");
    }

    public boolean scadiBiglietto(int idBiglietto)
            throws BigliettoNonTrovatoException, OperazioneStatoBigliettoException, SQLException {

        Biglietto biglietto = getBigliettoById(idBiglietto);

        if (!"Emesso".equals(biglietto.getStato())) {
            throw new OperazioneStatoBigliettoException(
                    idBiglietto,
                    biglietto.getStato(),
                    "scadenza"
            );
        }

        return bigliettoDAO.doUpdateStato(idBiglietto, "Scaduto");
    }

    public int scadiBigliettiProgrammazione(int idProgrammazione) throws SQLException {
        List<Biglietto> biglietti = bigliettoDAO.doRetrieveByProgrammazione(idProgrammazione);

        int scaduti = 0;
        for (Biglietto biglietto : biglietti) {
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

    public boolean isBigliettoUtilizzabile(int idBiglietto) throws SQLException {
        try {
            Biglietto biglietto = getBigliettoById(idBiglietto);

            if (!"Emesso".equals(biglietto.getStato())) {
                return false;
            }

            LocalDate oggi = LocalDate.now();
            LocalDate dataProiezione = biglietto.getProgrammazione().getDataProgrammazione();

            return !dataProiezione.isBefore(oggi);
        } catch (BigliettoNonTrovatoException e) {
            return false;
        }
    }

    public List<Biglietto> getBigliettiPerProgrammazione(int idProgrammazione)
            throws SQLException {
        return bigliettoDAO.doRetrieveByProgrammazione(idProgrammazione);
    }

    private void validaStato(String stato) throws BigliettoNonValidoException {
        List<String> statiValidi = List.of("Emesso", "Validato", "Scaduto", "Rimborsato");

        if (stato == null || !statiValidi.contains(stato)) {
            throw new BigliettoNonValidoException(
                    "Stato non valido. Stati ammessi: " + statiValidi
            );
        }
    }
}