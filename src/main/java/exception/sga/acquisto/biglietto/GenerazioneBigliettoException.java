package exception.sga.acquisto.biglietto;



//Eccezione lanciata quando la generazione di un biglietto fallisce

public class GenerazioneBigliettoException extends Exception {

    public GenerazioneBigliettoException(String message) {
        super(message);
    }

    public GenerazioneBigliettoException(String message, Throwable cause) {
        super(message, cause);
    }
}