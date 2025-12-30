package exception.sgu.autenticazione;

public class CredenzialiNonValideException extends Exception {
    public  CredenzialiNonValideException() {
        super("Le credenziali inserite non sono corrette");
    }
}
