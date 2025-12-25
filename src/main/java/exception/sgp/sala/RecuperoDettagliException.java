package exception.sgp.sala;

public class RecuperoDettagliException extends RuntimeException {
    public RecuperoDettagliException(Throwable cause) {
        super("Errore nel recupero dei dettagli della sala", cause);
    }
}
