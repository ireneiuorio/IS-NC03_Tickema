package exception.sgp.programmazione;

public class DataException extends RuntimeException {
    public DataException() {
        super("La data specificata non corrisponde alla data dello slot");
    }
}
