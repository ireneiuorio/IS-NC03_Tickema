package exception.sgp.programmazione;

public class CreazioneProgrammazioneMultiplaException extends RuntimeException {
  public CreazioneProgrammazioneMultiplaException(Throwable cause) {
    super("Errore nella creazione multipla di programmazioni", cause);
  }
}
