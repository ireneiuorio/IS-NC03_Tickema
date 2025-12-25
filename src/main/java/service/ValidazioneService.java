package service;

import entity.sga.Biglietto;
import entity.sgu.Utente; //
import repository.sga.BigliettoDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

//SERVICE per la gestione della Validazione Biglietti

public class ValidazioneService {

    private Connection connection;
    private BigliettoDAO bigliettoDAO;
    private BigliettoService bigliettoService;

    public ValidazioneService(Connection connection) {
        this.connection = connection;
        this.bigliettoDAO = new BigliettoDAO(connection);
        this.bigliettoService = new BigliettoService(connection);
    }

    //VALIDA BIGLIETTO tramite QR Code
    public boolean validaBiglietto(String qrCode, int idPersonale)
            throws SQLException, IllegalArgumentException, IllegalStateException {

        // 1. RECUPERA BIGLIETTO
        Biglietto biglietto = bigliettoService.getBigliettoByQRCode(qrCode);

        if (biglietto == null) {
            throw new IllegalArgumentException(
                    "Biglietto non trovato. QR Code: " + qrCode
            );
        }

        // 2. VERIFICA STATO
        if (!"Emesso".equals(biglietto.getStato())) {
            String messaggio = generaMessaggioErroreStato(biglietto);
            throw new IllegalStateException(messaggio);
        }

        // 3. VERIFICA DATA PROIEZIONE
        LocalDate oggi = LocalDate.now();
        LocalDate dataProiezione = biglietto.getProgrammazione().getDataProgrammazione();

        if (dataProiezione.isBefore(oggi)) {
            throw new IllegalStateException(
                    "Biglietto scaduto. Era valido per il " + dataProiezione
            );
        }

        if (dataProiezione.isAfter(oggi)) {
            throw new IllegalStateException(
                    "Biglietto non ancora valido. Valido per il " + dataProiezione
            );
        }

        // 4. CAMBIA STATO: Emesso → Validato
        biglietto.setStato("Validato");
        biglietto.setDataUtilizzo(LocalDateTime.now());

        // 5. REGISTRA CHI HA VALIDATO (Utente con tipoAccount="Personale")
        Utente personale = new Utente();
        personale.setIdAccount(idPersonale);
        biglietto.setPersonaleValidazione(personale);

        // 6. SALVA MODIFICHE
        boolean aggiornato = bigliettoDAO.doUpdate(biglietto);

        if (!aggiornato) {
            throw new SQLException("Errore nell'aggiornamento del biglietto");
        }

        return true;
    }

    //GENERA MESSAGGIO DI ERRORE IN BASE ALLO STATO

    private String generaMessaggioErroreStato(Biglietto biglietto) {
        return switch (biglietto.getStato()) {
            case "Validato" -> {
                String nomePersonale = "";
                if (biglietto.getPersonaleValidazione() != null) {
                    nomePersonale = " da " +
                            biglietto.getPersonaleValidazione().getNome() + " " +
                            biglietto.getPersonaleValidazione().getCognome();
                }
                yield "Biglietto già utilizzato il " +
                        biglietto.getDataUtilizzo() + nomePersonale;
            }

            case "Scaduto" ->
                    "Biglietto scaduto. La proiezione del " +
                            biglietto.getProgrammazione().getDataProgrammazione() +
                            " è terminata senza che il biglietto fosse utilizzato.";

            case "Rimborsato" ->
                    "Biglietto rimborsato. La programmazione è stata annullata e " +
                            "l'importo è stato accreditato al saldo dell'utente.";

            default ->
                    "Biglietto non valido. Stato: " + biglietto.getStato();
        };
    }

    //VERIFICA STATO BIGLIETTO senza validarlo

    public StatoBiglietto verificaStatoBiglietto(String qrCode) throws SQLException {

        StatoBiglietto stato = new StatoBiglietto();

        try {
            Biglietto biglietto = bigliettoService.getBigliettoByQRCode(qrCode);

            stato.setEsiste(true);
            stato.setStato(biglietto.getStato());
            stato.setFilm(biglietto.getProgrammazione().getFilm().getTitolo());
            stato.setDataProiezione(biglietto.getProgrammazione().getDataProgrammazione());
            stato.setFila(biglietto.getPosto().getFila());
            stato.setNumeroPosto(biglietto.getPosto().getNumeroPosto());

            // Determina se è utilizzabile
            LocalDate oggi = LocalDate.now();
            boolean statoOk = "Emesso".equals(biglietto.getStato());
            boolean dataOk = biglietto.getProgrammazione()
                    .getDataProgrammazione().equals(oggi);

            stato.setUtilizzabile(statoOk && dataOk);

            // Genera motivo dettagliato
            if ("Validato".equals(biglietto.getStato())) {
                stato.setMotivo("Già validato il " + biglietto.getDataUtilizzo());
            } else if ("Scaduto".equals(biglietto.getStato())) {
                stato.setMotivo("Biglietto scaduto - Programmazione conclusa");
            } else if ("Rimborsato".equals(biglietto.getStato())) {
                stato.setMotivo("Biglietto rimborsato - Programmazione annullata");
            } else if (!dataOk) {
                stato.setMotivo("Data proiezione non corrisponde a oggi");
            } else {
                stato.setMotivo("Biglietto valido e utilizzabile");
            }

        } catch (IllegalArgumentException e) {
            stato.setEsiste(false);
            stato.setUtilizzabile(false);
            stato.setMotivo("Biglietto non trovato");
        }

        return stato;
    }

    //RECUPERA BIGLIETTI VALIDATI DA UN PERSONALE
    public List<Biglietto> getBigliettiValidati(int idPersonale, LocalDate data)
            throws SQLException {

        List<Biglietto> tuttiValidati = bigliettoDAO.doRetrieveByPersonale(idPersonale);

        if (data != null) {
            return tuttiValidati.stream()
                    .filter(b -> b.getDataUtilizzo() != null &&
                            b.getDataUtilizzo().toLocalDate().equals(data))
                    .toList();
        }

        return tuttiValidati;
    }

    //CONTA VALIDAZIONI DI OGGI
    public int contaValidazioniOggi(int idPersonale) throws SQLException {
        LocalDate oggi = LocalDate.now();
        List<Biglietto> validatiOggi = getBigliettiValidati(idPersonale, oggi);
        return validatiOggi.size();
    }


}


// CLASSE DI SUPPORTO (DTO)
class StatoBiglietto {
    private boolean esiste;
    private boolean utilizzabile;
    private String stato;
    private String motivo;
    private String film;
    private LocalDate dataProiezione;
    private int fila;
    private int numeroPosto;

    public StatoBiglietto() {
        this.esiste = false;
        this.utilizzabile = false;
    }

    // Getters e Setters
    public boolean isEsiste() { return esiste; }
    public void setEsiste(boolean esiste) { this.esiste = esiste; }

    public boolean isUtilizzabile() { return utilizzabile; }
    public void setUtilizzabile(boolean utilizzabile) { this.utilizzabile = utilizzabile; }

    public String getStato() { return stato; }
    public void setStato(String stato) { this.stato = stato; }

    public String getMotivo() { return motivo; }
    public void setMotivo(String motivo) { this.motivo = motivo; }

    public String getFilm() { return film; }
    public void setFilm(String film) { this.film = film; }

    public LocalDate getDataProiezione() { return dataProiezione; }
    public void setDataProiezione(LocalDate dataProiezione) {
        this.dataProiezione = dataProiezione;
    }

    public int getFila() { return fila; }
    public void setFila(int fila) { this.fila = fila; }

    public int getNumeroPosto() { return numeroPosto; }
    public void setNumeroPosto(int numeroPosto) { this.numeroPosto = numeroPosto; }

    @Override
    public String toString() {
        if (!esiste) {
            return "Biglietto non trovato";
        }
        return String.format(
                "Film: %s | Data: %s | Posto: Fila %d N°%d | Stato: %s | Utilizzabile: %s | %s",
                film, dataProiezione, fila, numeroPosto, stato, utilizzabile, motivo
        );
    }
}