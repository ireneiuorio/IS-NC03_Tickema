package exception.sgp.programmazione;

public class ParametriException extends RuntimeException {
  public ParametriException() {
    super("Le liste di parametri devono avere la stessa lunghezza");
  }
}
