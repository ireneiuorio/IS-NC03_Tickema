package exception.pagamento;

//Eccezione lanciata quando i dati di un pagamento non sono validi

public class PagamentoNonValidoException extends Exception {
    public PagamentoNonValidoException(String message) {
        super(message);
    }

    public PagamentoNonValidoException(String message, Throwable cause) {
        super(message, cause);
    }
}