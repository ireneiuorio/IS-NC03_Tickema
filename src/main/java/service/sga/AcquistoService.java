package service.sga;

import entity.sga.Acquisto;
import entity.sgu.Utente;
import exception.sga.acquisto.AcquistoNonTrovatoException;
import exception.sga.acquisto.AcquistoNonValidoException;
import exception.sga.acquisto.RimborsoNonConsentitoException;
import exception.sga.acquisto.SalvataggioAcquistoException;
import repository.sga.AcquistoDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class AcquistoService {

    private Connection connection;
    private AcquistoDAO acquistoDAO;

    public AcquistoService(Connection connection) {
        this.connection = connection;
        this.acquistoDAO = new AcquistoDAO(connection);
    }

    public Acquisto creaAcquisto(Utente utente, int numeroBiglietti, double importoTotale)
            throws AcquistoNonValidoException, SalvataggioAcquistoException, SQLException {

        validaNumeroBiglietti(numeroBiglietti);
        validaImporto(importoTotale);

        if (utente == null || utente.getIdAccount() == 0) {
            throw new AcquistoNonValidoException("Utente non valido");
        }

        Acquisto acquisto = new Acquisto();
        acquisto.setUtente(utente);
        acquisto.setNumeroBiglietti(numeroBiglietti);
        acquisto.setImportoTotale(importoTotale);
        acquisto.setDataOraAcquisto(LocalDateTime.now());
        acquisto.setStato("Completato");

        boolean salvato = acquistoDAO.doSave(acquisto);

        if (!salvato) {
            throw new SalvataggioAcquistoException("Impossibile salvare l'acquisto nel database");
        }

        return acquisto;
    }

    public boolean rimborsaAcquisto(int idAcquisto)
            throws AcquistoNonTrovatoException, RimborsoNonConsentitoException, SQLException {

        Acquisto acquisto = acquistoDAO.doRetrieveById(idAcquisto);

        if (acquisto == null) {
            throw new AcquistoNonTrovatoException(idAcquisto);
        }

        if (!"Completato".equals(acquisto.getStato())) {
            throw new RimborsoNonConsentitoException(idAcquisto, acquisto.getStato());
        }

        return acquistoDAO.doUpdateStato(idAcquisto, "Rimborsato");
    }

    public Acquisto getAcquistoById(int idAcquisto) throws AcquistoNonTrovatoException, SQLException {
        Acquisto acquisto = acquistoDAO.doRetrieveById(idAcquisto);

        if (acquisto == null) {
            throw new AcquistoNonTrovatoException(idAcquisto);
        }

        return acquisto;
    }

    public List<Acquisto> getAcquistiUtente(int idAccount) throws SQLException {
        return acquistoDAO.doRetrieveByUtente(idAccount);
    }

    public List<Acquisto> getAcquistiPerStato(String stato) throws AcquistoNonValidoException, SQLException {
        validaStato(stato);
        return acquistoDAO.doRetrieveByStato(stato);
    }

    public List<Acquisto> getAcquistiPerPeriodo(LocalDateTime dataInizio, LocalDateTime dataFine)
            throws AcquistoNonValidoException, SQLException {

        if (dataInizio == null || dataFine == null) {
            throw new AcquistoNonValidoException("Date non valide");
        }

        if (dataInizio.isAfter(dataFine)) {
            throw new AcquistoNonValidoException("La data di inizio deve essere precedente alla data di fine");
        }

        return acquistoDAO.doRetrieveByDataRange(dataInizio, dataFine);
    }

    public int contaAcquistiUtente(int idAccount) throws SQLException {
        return acquistoDAO.doCountAcquistiByUtente(idAccount);
    }

    public List<Acquisto> getAcquistiCompletatiUtente(int idAccount) throws SQLException {
        return acquistoDAO.doRetrieveByUtente(idAccount)
                .stream()
                .filter(a -> "Completato".equals(a.getStato()))
                .toList();
    }

    public List<Acquisto> getAcquistiRimborsatiUtente(int idAccount) throws SQLException {
        return acquistoDAO.doRetrieveByUtente(idAccount)
                .stream()
                .filter(a -> "Rimborsato".equals(a.getStato()))
                .toList();
    }

    private void validaNumeroBiglietti(int numeroBiglietti) throws AcquistoNonValidoException {
        if (numeroBiglietti <= 0) {
            throw new AcquistoNonValidoException("Il numero di biglietti deve essere maggiore di zero");
        }

        if (numeroBiglietti > 10) {
            throw new AcquistoNonValidoException("Non è possibile acquistare più di 10 biglietti per transazione");
        }
    }

    private void validaImporto(double importo) throws AcquistoNonValidoException {
        if (importo <= 0) {
            throw new AcquistoNonValidoException("L'importo deve essere maggiore di zero");
        }

        if (importo > 10000) {
            throw new AcquistoNonValidoException("L'importo supera il limite massimo consentito (€10.000)");
        }
    }

    private void validaStato(String stato) throws AcquistoNonValidoException {
        List<String> statiValidi = List.of("Completato", "Rimborsato");

        if (stato == null || !statiValidi.contains(stato)) {
            throw new AcquistoNonValidoException("Stato non valido. Stati ammessi: " + statiValidi);
        }
    }

    public boolean isAcquistoRimborsabile(int idAcquisto) throws SQLException {
        Acquisto acquisto = acquistoDAO.doRetrieveById(idAcquisto);

        if (acquisto == null) {
            return false;
        }

        return "Completato".equals(acquisto.getStato());
    }
}