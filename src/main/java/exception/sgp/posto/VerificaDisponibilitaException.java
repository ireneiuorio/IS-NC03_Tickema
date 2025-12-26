package exception.sgp.posto;

public class VerificaDisponibilitaException extends RuntimeException {
  public VerificaDisponibilitaException(Throwable cause) {
    super("Errore nella verifica della disponibilità", cause);
  }
}
