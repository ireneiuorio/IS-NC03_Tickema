package exception.sgp.programmazione;

public class ModificaProgrammazioneException extends RuntimeException {
  public ModificaProgrammazioneException(Throwable cause) {
    super("Errore durante la modifica della programmazione", cause);
  }

  public ModificaProgrammazioneException() {
    super("Errore durante la modifica della programmazione");
  }
}
