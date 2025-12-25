package exception.sgp.sala;

public class CreazioneSalaException extends RuntimeException {
    public CreazioneSalaException(Throwable cause) {
        super("Fallimento creazione sala e posti: " + cause);
    }
}
