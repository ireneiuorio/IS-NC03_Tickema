package exception.sgp.slot;

public class CalcoloSlotDisponibiliException extends RuntimeException {
  public CalcoloSlotDisponibiliException(Throwable cause) {
    super("Errore nel calcolo degli slot disponibili", cause);
  }
}
