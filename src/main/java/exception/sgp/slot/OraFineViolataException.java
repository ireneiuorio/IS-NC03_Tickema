package exception.sgp.slot;

public class OraFineViolataException extends RuntimeException {
  public OraFineViolataException() {
    super("Invariante violata: l'ora di fine deve essere successiva all'inizio");
  }
}
