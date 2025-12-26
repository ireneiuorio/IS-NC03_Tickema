package exception.sgp.slot;

public class SlotNonTrovatoException extends RuntimeException {
    public SlotNonTrovatoException(int idSlot) {
        super("Slot orario non trovato con ID: " + idSlot);
    }
}
