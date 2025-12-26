package exception.sgp.posto;

public class ConteggioPostiException extends RuntimeException {
    public ConteggioPostiException(Throwable cause) {
        super("Errore nel conteggio dei posti disponibili", cause);
    }
}
