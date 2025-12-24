package service;

import entity.sgu.Utente;
import exception.EmailGiaRegistrataException;
import exception.PasswordErrataException;
import repository.sgu.UtenteDAO;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

public class AutenticazioneService {
    private UtenteDAO accountDAO = new UtenteDAO();

    public Utente registraUtente(String nome, String cognome, String email, String password, String numeroDiTelefono) throws SQLException, NoSuchAlgorithmException, EmailGiaRegistrataException {
        if (accountDAO.esisteEmail(email)) {
            throw new EmailGiaRegistrataException(); //vuol dire che c'è già un account registrato con quella email
        }

       //ora ci creiamo l'utente per poter hashare la password e salvarlo sul db
        //passiamo la password vuota così poi la hashiamo
        Utente nuovoUtente = new Utente(0, nome, cognome, numeroDiTelefono, "", email, "CLIENTE");

        //dobbiamo hashare la password che viene passata
        nuovoUtente.setPassword(password);

        //il saldo di default viene impostato dal db a 0

        if (accountDAO.doSave(nuovoUtente)) {
            return nuovoUtente;
        }

        return null;
    }

    public Utente login(String email, String passwordInserita) throws SQLException, NoSuchAlgorithmException, PasswordErrataException {
        //come prima cosa da fare si dovrebbe cercare l'utente nel database in base alla email passata
        Utente utenteDalDB = accountDAO.findUtenteByEmail(email);

        if (utenteDalDB != null) {
            //se entriamo qui vuol dire che l'utente esiste nel db, quindi dobbiamo verificare se la password che ha inserito è corretta
            //di conseguenza dobbiamo creare un utente temporaneo dove gli impostiamo la password hashata inserita, e le confrontiamo
            Utente temp = new Utente(0, "", "", "", "", "", "");
            temp.setPassword(passwordInserita);

            if (!temp.getPassword().equals(utenteDalDB.getPassword())) {
                throw new PasswordErrataException(); //password errata, chiamiamo l'eccezione
            }
        }

        return utenteDalDB; //login effettuato con successo
    }

    public boolean logout(int idAccount) {
        //qui seguendo l'ODD dobbiamo solo restituire il valore true perchè è la servlet che invalida la sessione, il service non sa che esiste la sessione
        return idAccount > 0;
    }

    public boolean verificaAutenticaizone(String token) {
        //se il token è nullo oppure vuoto l'utente non è autenticato
        if (token == null || token.isEmpty()) {
            return false;
        }

        //se il token esiste restituiamo true. Con token noi possiamo indicare magari l'id della sessione
        return true;
    }

}
