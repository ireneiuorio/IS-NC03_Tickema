package exception.sgp.posto;

public class AssegnazionePostiException extends RuntimeException {
    public AssegnazionePostiException(Throwable cause) {
        super("Errore nell'assegnazione dei posti", cause);
    }
}
