package exception.sgp.posto;

public class GenerazionePostiException extends RuntimeException {
    public GenerazionePostiException(Throwable cause) {
        super("Errore nella generazione dei posti per la programmazione", cause);
    }
}
