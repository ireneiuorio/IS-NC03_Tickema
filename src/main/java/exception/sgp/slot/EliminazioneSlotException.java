package exception.sgp.slot;

public class EliminazioneSlotException extends RuntimeException {
    public EliminazioneSlotException() {
        super("Errore durante l'eliminazione dello slot");
    }
}
