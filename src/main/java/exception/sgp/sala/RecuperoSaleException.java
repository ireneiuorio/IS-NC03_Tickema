package exception.sgp.sala;

public class RecuperoSaleException extends RuntimeException {
    public RecuperoSaleException(Throwable cause) {
        super("Errore nel recupero delle sale", cause);
    }
}
