package service.sga;

import entity.sga.Acquisto;
import entity.sgu.Utente;
import repository.sga.AcquistoDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

//SERVICE per la gestione della logica business degli Acquisti
public class AcquistoService {

    private Connection connection;
    private AcquistoDAO acquistoDAO;

    public AcquistoService(Connection connection) {
        this.connection = connection;
        this.acquistoDAO = new AcquistoDAO(connection);
    }

    //CREA UN NUOVO ACQUISTO
    public Acquisto creaAcquisto(Utente utente, int numeroBiglietti, double importoTotale)
            throws SQLException, IllegalArgumentException {

        // 1. Validazioni
        validaNumeroBiglietti(numeroBiglietti);
        validaImporto(importoTotale);

        if (utente == null || utente.getIdAccount() == 0) {
            throw new IllegalArgumentException("Utente non valido");
        }

        // 2. Crea l'oggetto Acquisto
        Acquisto acquisto = new Acquisto();
        acquisto.setUtente(utente);
        acquisto.setNumeroBiglietti(numeroBiglietti);
        acquisto.setImportoTotale(importoTotale);
        acquisto.setDataOraAcquisto(LocalDateTime.now());
        acquisto.setStato("Completato"); // Acquisto completato atomicamente

        // 3. Salva nel database
        boolean salvato = acquistoDAO.doSave(acquisto);

        if (!salvato) {
            throw new SQLException("Impossibile salvare l'acquisto nel database");
        }

        return acquisto;
    }

    //RIMBORSA UN ACQUISTO
    public boolean rimborsaAcquisto(int idAcquisto) throws SQLException {
        Acquisto acquisto = acquistoDAO.doRetrieveById(idAcquisto);

        if (acquisto == null) {
            throw new IllegalArgumentException("Acquisto non trovato con ID: " + idAcquisto);
        }

        if (!"Completato".equals(acquisto.getStato())) {
            throw new IllegalStateException(
                    "Solo gli acquisti completati possono essere rimborsati. " +
                            "Stato corrente: " + acquisto.getStato()
            );
        }

        return acquistoDAO.doUpdateStato(idAcquisto, "Rimborsato");
    }


    //RECUPERA ACQUISTO PER ID
    public Acquisto getAcquistoById(int idAcquisto) throws SQLException {
        Acquisto acquisto = acquistoDAO.doRetrieveById(idAcquisto);

        if (acquisto == null) {
            throw new IllegalArgumentException("Acquisto con ID " + idAcquisto + " non trovato");
        }

        return acquisto;
    }

    //RECUPERA TUTTI GLI ACQUISTI DI UN UTENTE
    public List<Acquisto> getAcquistiUtente(int idAccount) throws SQLException {
        return acquistoDAO.doRetrieveByUtente(idAccount);
    }

    //RECUPERA ACQUISTI PER STATO
    public List<Acquisto> getAcquistiPerStato(String stato) throws SQLException {
        validaStato(stato);
        return acquistoDAO.doRetrieveByStato(stato);
    }

    //RECUPERA ACQUISTI PER PERIODO
    public List<Acquisto> getAcquistiPerPeriodo(LocalDateTime dataInizio, LocalDateTime dataFine)
            throws SQLException {

        if (dataInizio == null || dataFine == null) {
            throw new IllegalArgumentException("Date non valide");
        }

        if (dataInizio.isAfter(dataFine)) {
            throw new IllegalArgumentException("La data di inizio deve essere precedente alla data di fine");
        }

        return acquistoDAO.doRetrieveByDataRange(dataInizio, dataFine);
    }


    //CONTA ACQUISTI DI UN UTENTE
    public int contaAcquistiUtente(int idAccount) throws SQLException {
        return acquistoDAO.doCountAcquistiByUtente(idAccount);
    }

    //RECUPERA ACQUISTI COMPLETATI DI UN UTENTE
    public List<Acquisto> getAcquistiCompletatiUtente(int idAccount) throws SQLException {
        return acquistoDAO.doRetrieveByUtente(idAccount)
                .stream()
                .filter(a -> "Completato".equals(a.getStato()))
                .toList();
    }

    //RECUPERA ACQUISTI RIMBORSATI DI UN UTENTE
    public List<Acquisto> getAcquistiRimborsatiUtente(int idAccount) throws SQLException {
        return acquistoDAO.doRetrieveByUtente(idAccount)
                .stream()
                .filter(a -> "Rimborsato".equals(a.getStato()))
                .toList();
    }


    // VALIDAZIONI PRIVATE
    private void validaNumeroBiglietti(int numeroBiglietti) {
        if (numeroBiglietti <= 0) {
            throw new IllegalArgumentException("Il numero di biglietti deve essere maggiore di zero");
        }

        if (numeroBiglietti > 10) {
            throw new IllegalArgumentException("Non è possibile acquistare più di 10 biglietti per transazione");
        }
    }

    private void validaImporto(double importo) {
        if (importo <= 0) {
            throw new IllegalArgumentException("L'importo deve essere maggiore di zero");
        }

        if (importo > 10000) {
            throw new IllegalArgumentException("L'importo supera il limite massimo consentito (€10.000)");
        }
    }

    private void validaStato(String stato) {
        List<String> statiValidi = List.of("Completato", "Rimborsato");

        if (stato == null || !statiValidi.contains(stato)) {
            throw new IllegalArgumentException("Stato non valido. Stati ammessi: " + statiValidi);
        }
    }

    //VERIFICA SE UN ACQUISTO È RIMBORSABILE
    public boolean isAcquistoRimborsabile(int idAcquisto) throws SQLException {
        Acquisto acquisto = acquistoDAO.doRetrieveById(idAcquisto);

        if (acquisto == null) {
            return false;
        }

        // Solo acquisti "Completato" sono rimborsabili
        return "Completato".equals(acquisto.getStato());
    }
}