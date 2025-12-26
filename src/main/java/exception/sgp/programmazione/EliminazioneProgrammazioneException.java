package exception.sgp.programmazione;

public class EliminazioneProgrammazioneException extends RuntimeException {
  public EliminazioneProgrammazioneException(Throwable cause) {
    super("Fallimento procedura di annullamento e rimborso", cause);
  }
}
