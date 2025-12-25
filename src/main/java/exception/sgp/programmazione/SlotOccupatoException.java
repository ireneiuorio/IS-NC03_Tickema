package exception.sgp.programmazione;

public class SlotOccupatoException extends RuntimeException {
    public SlotOccupatoException() {
        super("Lo slot orario è già occupato per questa sala");
    }
    public SlotOccupatoException(int idSala) {
        super("Slot già occupato per sala " + idSala);
    }
}
