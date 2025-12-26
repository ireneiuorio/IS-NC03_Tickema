package exception.biglietto;

//Eccezione lanciata quando i dati di un biglietto non sono validi
public class BigliettoNonValidoException extends Exception {

    public BigliettoNonValidoException(String message) {
        super(message);
    }

    public BigliettoNonValidoException(String message, Throwable cause) {
        super(message, cause);
    }
}