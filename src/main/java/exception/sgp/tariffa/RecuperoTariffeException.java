package exception.sgp.tariffa;

public class RecuperoTariffeException extends RuntimeException {
    public RecuperoTariffeException(Throwable cause) {
        super("Errore nel recupero delle tariffe", cause);
    }
}
