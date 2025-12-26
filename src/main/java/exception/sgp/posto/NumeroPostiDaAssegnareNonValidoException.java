package exception.sgp.posto;

public class NumeroPostiDaAssegnareNonValidoException extends RuntimeException {
    public NumeroPostiDaAssegnareNonValidoException() {
        super("Il numero di posti da assegnare deve essere positivo");
    }
}
