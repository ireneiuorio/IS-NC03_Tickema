package service.sgu;

import entity.sgu.Utente;
import exception.sgu.EmailGiaRegistrataException;
import exception.sgu.PasswordErrataException;
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
    public Utente registraUtente(String nome, String cognome, String email, String password, String confermaPassword, String numeroDiTelefono)
            throws SQLException, NoSuchAlgorithmException, EmailGiaRegistrataException, PasswordDiverseException {

        // Verifica email già esistente
        if (utenteDAO.esisteEmail(email)) {
            throw new EmailGiaRegistrataException();
        }

        //verifica che le due password corrispondano
        if(!password.equals(confermaPassword)) {
            throw new PasswordDiverseException();
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
            throws SQLException, NoSuchAlgorithmException, CredenzialiNonValideException {

        // Cerca utente per email
        Utente utenteDalDB = utenteDAO.doRetrieveByEmail(email);

        if (utenteDalDB == null) {
            throw new CredenzialiNonValideException(); // Email non trovata
        }

        // Hasha la password inserita per confrontarla
        Utente temp = new Utente();
        temp.setPassword(passwordInserita);

        // Confronta le password hashate
        if (!temp.getPassword().equals(utenteDalDB.getPassword())) {
            throw new CredenzialiNonValideException();
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

    //modifica il profilo (nome, cognome, e numero di telefono)
    public boolean modificaProfilo(int idAccount, String nome, String cognome, String numeroDiTelefono) throws SQLException {
        return utenteDAO.doUpdateProfilo(idAccount, nome, cognome, numeroDiTelefono);
    }

    public boolean modificaCredenziali(int idAccount, String email, String password, String confermaPassword) throws PasswordDiverseException, NoSuchAlgorithmException, SQLException {
        if (!password.equals(confermaPassword)) {
            throw new PasswordDiverseException();
        }

        //creiamo un utente temporaneo per poter hashare la password
        Utente temp = new Utente();
        temp.setPassword(password);

        return utenteDAO.doUpdateCredenziali(idAccount, email, temp.getPassword());
    }
}