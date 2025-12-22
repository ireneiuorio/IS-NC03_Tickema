package control;

package techvibe.control.gestioneAcquisti;


import entity.SGA.Acquisto;
import repository.SGA.AcquistoDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

/**
 * SERVICE per la gestione della logica business degli Acquisti
 *
 * Responsabilità:
 * - Validazione dati acquisto
 * - Creazione e gestione acquisti
 * - Calcolo totali e sconti
 * - Recupero storico acquisti
 */
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
        acquisto.setStato("In Corso"); // Stati: In Corso, Completato, Annullato, Rimborsato

        // 3. Salva nel database
        boolean salvato = acquistoDAO.doSave(acquisto);

        if (!salvato) {
            throw new SQLException("Impossibile salvare l'acquisto nel database");
        }

        return acquisto;
    }



    //COMPLETA UN ACQUISTO
    public boolean completaAcquisto(int idAcquisto) throws SQLException {
        Acquisto acquisto = acquistoDAO.doRetrieveById(idAcquisto);

        if (acquisto == null) {
            throw new IllegalArgumentException("Acquisto non trovato");
        }

        if (!"In Corso".equals(acquisto.getStato())) {
            throw new IllegalStateException("L'acquisto non è in uno stato che permette il completamento");
        }

        return acquistoDAO.doUpdateStato(idAcquisto, "Completato");
    }

    //ANNULLA UN ACQUISTO
    public boolean annullaAcquisto(int idAcquisto) throws SQLException {
        Acquisto acquisto = acquistoDAO.doRetrieveById(idAcquisto);

        if (acquisto == null) {
            throw new IllegalArgumentException("Acquisto non trovato");
        }

        if ("Completato".equals(acquisto.getStato())) {
            throw new IllegalStateException("Non è possibile annullare un acquisto completato. Usa il rimborso.");
        }

        return acquistoDAO.doUpdateStato(idAcquisto, "Annullato");
    }

    //RIMBORSA UN ACQUISTO
    public boolean rimborsaAcquisto(int idAcquisto) throws SQLException {
        Acquisto acquisto = acquistoDAO.doRetrieveById(idAcquisto);

        if (acquisto == null) {
            throw new IllegalArgumentException("Acquisto non trovato");
        }

        if (!"Completato".equals(acquisto.getStato())) {
            throw new IllegalStateException("Solo gli acquisti completati possono essere rimborsati");
        }

        return acquistoDAO.doUpdateStato(idAcquisto, "Rimborsato");
    }


    //RECUPERA UN ACQUISTO PER ID
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


    //CALCOLA IMPORTO CON SCONTO
    public double calcolaImportoConSconto(double importoBase, double percentualeSconto) {
        if (importoBase < 0) {
            throw new IllegalArgumentException("L'importo base non può essere negativo");
        }

        if (percentualeSconto < 0 || percentualeSconto > 100) {
            throw new IllegalArgumentException("La percentuale di sconto deve essere tra 0 e 100");
        }

        double sconto = (importoBase * percentualeSconto) / 100.0;
        double importoFinale = importoBase - sconto;

        // Arrotonda a 2 decimali
        return Math.round(importoFinale * 100.0) / 100.0;
    }

    //CALCOLA TOTALE INCASSI PER PERIODO
    public double calcolaTotaleIncassi(LocalDateTime dataInizio, LocalDateTime dataFine)
            throws SQLException {

        if (dataInizio == null || dataFine == null) {
            throw new IllegalArgumentException("Date non valide");
        }

        return acquistoDAO.doCalcolaTotaleIncassi(dataInizio, dataFine);
    }

    //CONTA ACQUISTI DI UN UTENTE
    public int contaAcquistiUtente(int idAccount) throws SQLException {
        return acquistoDAO.doCountAcquistiByUtente(idAccount);
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
            throw new IllegalArgumentException("L'importo supera il limite massimo consentito");
        }
    }

    private void validaStato(String stato) {
        List<String> statiValidi = List.of("Completato", "Annullato", "Rimborsato");

        if (stato == null || !statiValidi.contains(stato)) {
            throw new IllegalArgumentException("Stato non valido. Stati ammessi: " + statiValidi);
        }
    }

    // ========================================================
    // VERIFICA BUSINESS RULES
    // ========================================================

    /**
     * VERIFICA SE UN UTENTE PUÒ EFFETTUARE UN ACQUISTO
     */
    public boolean puoEffettuareAcquisto(Utente utente) throws SQLException {
        if (utente == null) {
            return false;
        }

        // Verifica che l'utente non abbia troppi acquisti pendenti
        List<Acquisto> acquistiInCorso = acquistoDAO.doRetrieveByUtente(utente.getIdAccount())
                .stream()
                .filter(a -> "In Corso".equals(a.getStato()))
                .toList();

        // Limite: massimo 3 acquisti in corso contemporaneamente
        return acquistiInCorso.size() < 3;
    }

    /**
     * VERIFICA SE UN ACQUISTO È MODIFICABILE
     */
    public boolean isAcquistoModificabile(int idAcquisto) throws SQLException {
        Acquisto acquisto = acquistoDAO.doRetrieveById(idAcquisto);

        if (acquisto == null) {
            return false;
        }

        // Solo acquisti "In Corso" sono modificabili
        return "In Corso".equals(acquisto.getStato());
    }

    /**
     * VERIFICA SE UN ACQUISTO È RIMBORSABILE
     */
    public boolean isAcquistoRimborsabile(int idAcquisto) throws SQLException {
        Acquisto acquisto = acquistoDAO.doRetrieveById(idAcquisto);

        if (acquisto == null) {
            return false;
        }

        // Solo acquisti "Completato" sono rimborsabili
        if (!"Completato".equals(acquisto.getStato())) {
            return false;
        }

        // Verifica che non siano passati più di 30 giorni
        LocalDateTime dataLimite = LocalDateTime.now().minusDays(30);
        return acquisto.getDataOraAcquisto().isAfter(dataLimite);
    }
}