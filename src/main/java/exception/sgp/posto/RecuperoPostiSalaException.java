package exception.sgp.posto;

public class RecuperoPostiSalaException extends RuntimeException {
  public RecuperoPostiSalaException(Throwable cause) {
    super("Errore nel recupero dei posti della sala", cause);
  }
}
