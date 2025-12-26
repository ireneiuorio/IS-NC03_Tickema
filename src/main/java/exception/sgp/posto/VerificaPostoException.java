package exception.sgp.posto;

public class VerificaPostoException extends RuntimeException {
    public VerificaPostoException(Throwable cause) {
        super("Errore nella verifica del posto", cause);
    }
}
