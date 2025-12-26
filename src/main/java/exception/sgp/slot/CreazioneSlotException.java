package exception.sgp.slot;

public class CreazioneSlotException extends RuntimeException {
    public CreazioneSlotException(Throwable cause) {
        super("Errore nella creazione dello slot orario", cause);
    }
}
