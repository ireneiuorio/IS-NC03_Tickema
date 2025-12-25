package exception.sgp.sala;

public class ModificaSalaException extends RuntimeException {
    public ModificaSalaException(Throwable cause) {
        super("Errore durante la modifica della sala", cause);
    }
}
