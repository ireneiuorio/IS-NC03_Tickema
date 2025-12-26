package exception.sgp.posto;

public class RecuperoPostiDisponibiliException extends RuntimeException {
    public RecuperoPostiDisponibiliException(Throwable cause) {
        super("Errore nel recupero dei posti disponibili", cause);
    }
}