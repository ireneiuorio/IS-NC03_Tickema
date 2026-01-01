package service.sgu;


import entity.sgu.Utente;
import repository.sgu.UtenteDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

public class UtenteService {

    private Connection connection;
    private UtenteDAO utenteDAO;

    public UtenteService(Connection connection) {
        this.connection = connection;
        this.utenteDAO = new UtenteDAO(connection);
    }

    /**
     * Recupera tutti gli utenti
     */
    public List<Utente> getAllUtenti() throws SQLException {
        return utenteDAO.doRetrieveAll();
    }

    /**
     * Recupera utenti per tipo account
     */
    public List<Utente> getUtentiPerTipo(String tipoAccount) throws SQLException {
        return utenteDAO.doRetrieveAll().stream()
                .filter(u -> tipoAccount.equalsIgnoreCase(u.getTipoAccount()))
                .collect(Collectors.toList());
    }

    /**
     * Cerca utenti per nome, cognome o email
     */
    public List<Utente> cercaUtenti(String query) throws SQLException {
        String searchLower = query.toLowerCase();

        return utenteDAO.doRetrieveAll().stream()
                .filter(u ->
                        u.getNome().toLowerCase().contains(searchLower) ||
                                u.getCognome().toLowerCase().contains(searchLower) ||
                                u.getEmail().toLowerCase().contains(searchLower)
                )
                .collect(Collectors.toList());
    }

    /**
     * Conta totale utenti
     */
    public int contaTotaleUtenti() throws SQLException {
        return utenteDAO.doRetrieveAll().size();
    }

    /**
     * Conta utenti per tipo
     */
    public int contaUtentiPerTipo(String tipoAccount) throws SQLException {
        return (int) utenteDAO.doRetrieveAll().stream()
                .filter(u -> tipoAccount.equalsIgnoreCase(u.getTipoAccount()))
                .count();
    }

    /**
     * Recupera utente per ID
     */
    public Utente getUtenteById(int idAccount) throws SQLException {
        return utenteDAO.doRetrieveByKey(idAccount);
    }
}