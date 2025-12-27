package service.sgu;

import entity.sgu.Utente;
import exception.sgu.autenticazione.EmailGiaRegistrataException;
import exception.sgu.autenticazione.PasswordErrataException;
import repository.sgu.UtenteDAO;

import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.SQLException;

public class AutenticazioneService {

    private Connection connection;
    private UtenteDAO utenteDAO;

    public AutenticazioneService(Connection connection) {
        this.connection = connection;
        this.utenteDAO = new UtenteDAO(connection);
    }

    //REGISTRA NUOVO UTENTE
    public Utente registraUtente(String nome, String cognome, String email, String password, String numeroDiTelefono)
            throws SQLException, NoSuchAlgorithmException, EmailGiaRegistrataException {

        // Verifica email già esistente
        if (utenteDAO.esisteEmail(email)) {
            throw new EmailGiaRegistrataException();
        }

        // Crea nuovo utente (usa costruttore SENZA idAccount)
        Utente nuovoUtente = new Utente(
                nome,
                cognome,
                numeroDiTelefono,
                "", // Password vuota, la hashiamo dopo
                email,
                "Utente Autenticato"
        );

        // Hasha la password
        nuovoUtente.setPassword(password);

        // Salva nel database (il saldo viene impostato a 0 dal DAO)
        if (utenteDAO.doSave(nuovoUtente)) {
            return nuovoUtente;
        }

        return null;
    }

    //LOGIN UTENTE
    public Utente login(String email, String passwordInserita)
            throws SQLException, NoSuchAlgorithmException, PasswordErrataException {

        // Cerca utente per email
        Utente utenteDalDB = utenteDAO.doRetrieveByEmail(email);

        if (utenteDalDB == null) {
            throw new PasswordErrataException(); // Email non trovata
        }

        // Hasha la password inserita per confrontarla
        Utente temp = new Utente();
        temp.setPassword(passwordInserita);

        // Confronta le password hashate
        if (!temp.getPassword().equals(utenteDalDB.getPassword())) {
            throw new PasswordErrataException();
        }

        return utenteDalDB; // Login riuscito
    }

    //LOGOUT UTENTE
    public boolean logout(int idAccount) {
        // Il service restituisce true se l'id è valido
        // La servlet invaliderà la sessione
        return idAccount > 0;
    }

    //VERIFICA AUTENTICAZIONE
    public boolean verificaAutenticazione(String token) {
        // Se il token è nullo o vuoto, utente non autenticato
        if (token == null || token.isEmpty()) {
            return false;
        }

        return true;
    }
}