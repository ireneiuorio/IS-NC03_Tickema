package exception.sgp.programmazione;

public class RecuperoProgrammazioniException extends RuntimeException {
    public RecuperoProgrammazioniException(Throwable cause) {
        super("Errore nel recupero della/e programmazione/i", cause);
    }
}
