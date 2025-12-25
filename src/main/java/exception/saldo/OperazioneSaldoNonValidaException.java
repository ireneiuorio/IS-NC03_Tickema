package exception.saldo;

//Eccezione lanciata quando un'operazione sul saldo non è valida
public class OperazioneSaldoNonValidaException extends Exception {

    public OperazioneSaldoNonValidaException(String message) {
        super(message);
    }

    public OperazioneSaldoNonValidaException(String message, Throwable cause) {
        super(message, cause);
    }
}