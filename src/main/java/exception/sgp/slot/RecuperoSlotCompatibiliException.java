package exception.sgp.slot;

public class RecuperoSlotCompatibiliException extends RuntimeException {
    public RecuperoSlotCompatibiliException(Throwable cause) {
        super("Errore nel recupero degli slot compatibili", cause);
    }
}
