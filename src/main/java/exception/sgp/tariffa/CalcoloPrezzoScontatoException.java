package exception.sgp.tariffa;

public class CalcoloPrezzoScontatoException extends RuntimeException {
  public CalcoloPrezzoScontatoException(Throwable cause) {
    super("Errore nel calcolo del prezzo scontato", cause);
  }
}
