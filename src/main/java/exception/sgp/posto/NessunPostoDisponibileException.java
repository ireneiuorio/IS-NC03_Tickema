package exception.sgp.posto;

public class NessunPostoDisponibileException extends RuntimeException {
  public NessunPostoDisponibileException() {
    super("Nessun posto disponibile");
  }
}
