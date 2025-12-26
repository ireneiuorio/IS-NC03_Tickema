package exception.sgp.programmazione;

public class CreazioneProgrammazioneException extends RuntimeException {
  public CreazioneProgrammazioneException(Throwable cause) {
    super("Errore critico durante la creazione della programmazione", cause);
  }
}
