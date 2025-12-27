package exception.sga.acquisto;

// Eccezione lanciata quando il salvataggio di un acquisto fallisce

public class SalvataggioAcquistoException extends Exception {

    public SalvataggioAcquistoException(String message) {
        super(message);
    }

    public SalvataggioAcquistoException(String message, Throwable cause) {
        super(message, cause);
    }
}