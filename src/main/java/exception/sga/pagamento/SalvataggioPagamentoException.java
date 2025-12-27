package exception.sga.pagamento;

//Eccezione lanciata quando il salvataggio di un pagamento fallisce

public class SalvataggioPagamentoException extends Exception {

    public SalvataggioPagamentoException(String message) {
        super(message);
    }

    public SalvataggioPagamentoException(String message, Throwable cause) {
        super(message, cause);
    }
}