package exception.sgp.tariffa;

public class ModificaTariffaException extends RuntimeException {
  public ModificaTariffaException(Throwable cause) {
    super("Errore nella modifica della tariffa", cause);
  }
}
