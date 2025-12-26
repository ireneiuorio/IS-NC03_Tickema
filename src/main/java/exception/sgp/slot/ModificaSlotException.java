package exception.sgp.slot;

public class ModificaSlotException extends RuntimeException {
    public ModificaSlotException(Throwable cause) {
        super("Errore nella modifica dello slot orario", cause);
    }
}
