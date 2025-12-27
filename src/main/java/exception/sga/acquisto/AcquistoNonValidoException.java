package exception.sga.acquisto;

//Eccezione lanciata quando i dati di un acquisto non sono validi

public class AcquistoNonValidoException extends Exception {

    public AcquistoNonValidoException(String message) {
        super(message);
    }

    public AcquistoNonValidoException(String message, Throwable cause) {
        super(message, cause);
    }
}