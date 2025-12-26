package exception.sgp.posto;

public class PostiInsufficentiException extends RuntimeException {
  public PostiInsufficentiException(int richiesti, int disponibili) {
    super(String.format(
            "Posti insufficienti. Richiesti: %d, Disponibili: %d",
            richiesti, disponibili
    ));
  }
}
