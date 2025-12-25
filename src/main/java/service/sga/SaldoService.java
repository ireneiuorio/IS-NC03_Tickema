package service.sga;

import entity.sgu.Utente;
import exception.saldo.AggiornamentoSaldoException;
import exception.saldo.OperazioneSaldoNonValidaException;
import exception.saldo.TipoAccountNonValidoException;
import exception.saldo.UtenteNonTrovatoException;
import repository.sgu.UtenteDAO;

import java.sql.Connection;
import java.sql.SQLException;

public class SaldoService {

    private Connection connection;
    private UtenteDAO utenteDAO;

    public SaldoService(Connection connection) {
        this.connection = connection;
        this.utenteDAO = new UtenteDAO(connection);
    }

    //RECUPERA SALDO DISPONIBILE
    public double getSaldoDisponibile(int idAccount)
            throws UtenteNonTrovatoException, TipoAccountNonValidoException, SQLException {

        Utente utente = utenteDAO.doRetrieveById(idAccount);

        if (utente == null) {
            throw new UtenteNonTrovatoException(idAccount);
        }

        // Verifica che sia un utente autenticato (non admin/personale)
        if (!"Utente Autenticato".equals(utente.getTipoAccount())) {
            throw new TipoAccountNonValidoException(idAccount, utente.getTipoAccount());
        }

        // Gestisce NULL nel database (ritorna 0.0)
        return utente.getSaldo() != 0 ? utente.getSaldo() : 0.0;
    }

    //UTILIZZA SALDO per un acquisto
    public boolean utilizzaSaldo(int idAccount, double importo)
            throws OperazioneSaldoNonValidaException, UtenteNonTrovatoException,
            TipoAccountNonValidoException, AggiornamentoSaldoException, SQLException {

        // Validazioni
        if (importo <= 0) {
            throw new OperazioneSaldoNonValidaException("L'importo deve essere maggiore di zero");
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
            throw new AggiornamentoSaldoException(idAccount, "Errore nell'aggiornamento del saldo");
        }

        return true;
    }

    //RIMBORSA IMPORTO SUL SALDO
    public boolean rimborsaSaldo(int idAccount, double importo)
            throws OperazioneSaldoNonValidaException, UtenteNonTrovatoException,
            TipoAccountNonValidoException, AggiornamentoSaldoException, SQLException {

        // Validazioni
        if (importo <= 0) {
            throw new OperazioneSaldoNonValidaException("L'importo del rimborso deve essere maggiore di zero");
        }

        // Recupera saldo attuale
        double saldoAttuale = getSaldoDisponibile(idAccount);

        // Calcola nuovo saldo
        double nuovoSaldo = saldoAttuale + importo;

        // Aggiorna nel database
        boolean aggiornato = utenteDAO.doUpdateSaldo(idAccount, nuovoSaldo);

        if (!aggiornato) {
            throw new AggiornamentoSaldoException(idAccount, "Errore nel rimborso del saldo");
        }

        return true;
    }

    //VERIFICA SE IL SALDO È SUFFICIENTE
    public boolean isSaldoSufficiente(int idAccount, double importoRichiesto)
            throws UtenteNonTrovatoException, TipoAccountNonValidoException, SQLException {

        double saldoDisponibile = getSaldoDisponibile(idAccount);
        return saldoDisponibile >= importoRichiesto;
    }

    //CALCOLA QUANTO SALDO VERRÀ USATO
    public double calcolaImportoSaldoDaUsare(int idAccount, double importoTotale)
            throws UtenteNonTrovatoException, TipoAccountNonValidoException, SQLException {

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
            throws UtenteNonTrovatoException, TipoAccountNonValidoException, SQLException {

        double saldoDisponibile = getSaldoDisponibile(idAccount);
        double differenza = importoTotale - saldoDisponibile;

        return differenza > 0 ? differenza : 0.0;
    }
}