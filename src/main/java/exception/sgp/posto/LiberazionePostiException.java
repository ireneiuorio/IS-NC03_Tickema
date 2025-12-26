package exception.sgp.posto;

public class LiberazionePostiException extends RuntimeException {
    public LiberazionePostiException() {
        super("Errore nella liberazione dei posti.");
    }
}
