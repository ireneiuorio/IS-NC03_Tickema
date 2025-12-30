package exception.sgu.autenticazione;

public class PasswordDiverseException extends Exception {
    public PasswordDiverseException() {
        super("Le password non corrispondono.");
    }
}
