package exception.sgp.programmazione;

public class SlotNonDisponibileException extends RuntimeException {
    public SlotNonDisponibileException(String stato) {
        super("Lo slot orario non è disponibile. Stato: " + stato);
    }
}
