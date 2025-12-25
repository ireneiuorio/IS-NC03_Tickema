package exception.sgp.programmazione;

public class DatiProgrammazioneNonValidiException extends RuntimeException {
    public DatiProgrammazioneNonValidiException(Throwable cause) {
        super("Dati non validi: " + cause);
    }
}
