package service;


import entity.sgu.Utente;
import repository.sgu.UtenteDAO;

import java.sql.Connection;
import java.sql.SQLException;

//SERVICE per la gestione del Saldo degli Utenti

public class SaldoService {

    private Connection connection;
    private UtenteDAO utenteDAO;

    public SaldoService(Connection connection) {
        this.connection = connection;
        this.utenteDAO = new UtenteDAO(connection);
    }


    //RECUPERA SALDO DISPONIBILE
    public double getSaldoDisponibile(int idAccount) throws SQLException {
        Utente utente = utenteDAO.doRetrieveById(idAccount);

        if (utente == null) {
            throw new IllegalArgumentException("Utente con ID " + idAccount + " non trovato");
        }

        // Verifica che sia un utente autenticato (non admin/personale)
        if (!"Utente Autenticato".equals(utente.getTipoAccount())) {
            throw new IllegalStateException(
                    "Solo gli utenti autenticati hanno un saldo. Tipo account: "
                            + utente.getTipoAccount()
            );
        }

        // Gestisce NULL nel database (ritorna 0.0)
        return utente.getSaldo() != 0 ? utente.getSaldo() : 0.0;
    }


    //UTILIZZA SALDO per un acquisto

    public boolean utilizzaSaldo(int idAccount, double importo) throws SQLException {

        // Validazioni
        if (importo <= 0) {
            throw new IllegalArgumentException("L'importo deve essere maggiore di zero");
        }

        // Recupera saldo attuale
        double saldoAttuale = getSaldoDisponibile(idAccount);

        // Verifica disponibilità
        if (saldoAttuale < importo) {
            return false; // Saldo insufficiente
        }

        // Calcola nuovo saldo
        double nuovoSaldo = saldoAttuale - importo;

        // Aggiorna nel database
        boolean aggiornato = utenteDAO.doUpdateSaldo(idAccount, nuovoSaldo);

        if (!aggiornato) {
            throw new SQLException("Errore nell'aggiornamento del saldo");
        }

        return true;
    }

    // ========================================================
    // RIMBORSO SALDO (UNICO MODO PER RICARICARE)
    // ========================================================

    //RIMBORSA IMPORTO SUL SALDO
    public boolean rimborsaSaldo(int idAccount, double importo) throws SQLException {

        // Validazioni
        if (importo <= 0) {
            throw new IllegalArgumentException("L'importo del rimborso deve essere maggiore di zero");
        }

        // Recupera saldo attuale
        double saldoAttuale = getSaldoDisponibile(idAccount);

        // Calcola nuovo saldo
        double nuovoSaldo = saldoAttuale + importo;

        // Aggiorna nel database
        boolean aggiornato = utenteDAO.doUpdateSaldo(idAccount, nuovoSaldo);

        if (!aggiornato) {
            throw new SQLException("Errore nel rimborso del saldo");
        }

        return true;
    }

    // ========================================================
    // VERIFICA DISPONIBILITÀ
    // ========================================================

    //VERIFICA SE IL SALDO È SUFFICIENTE
    public boolean isSaldoSufficiente(int idAccount, double importoRichiesto)
            throws SQLException {

        double saldoDisponibile = getSaldoDisponibile(idAccount);
        return saldoDisponibile >= importoRichiesto;
    }

    //CALCOLA QUANTO SALDO VERRÀ USATO

    public double calcolaImportoSaldoDaUsare(int idAccount, double importoTotale)
            throws SQLException {

        double saldoDisponibile = getSaldoDisponibile(idAccount);

        // Se saldo sufficiente, usa solo il necessario
        if (saldoDisponibile >= importoTotale) {
            return importoTotale;
        }

        // Se saldo insufficiente, usa tutto quello disponibile
        return saldoDisponibile;
    }

    //CALCOLA DIFFERENZA DA PAGARE CON CARTA

    public double calcolaDifferenzaConCarta(int idAccount, double importoTotale)
            throws SQLException {

        double saldoDisponibile = getSaldoDisponibile(idAccount);
        double differenza = importoTotale - saldoDisponibile;

        return differenza > 0 ? differenza : 0.0;
    }
}
