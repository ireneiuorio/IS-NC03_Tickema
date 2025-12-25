package exception.sgp.tariffa;

public class PercentualeScontoNonValidaException extends RuntimeException {
    public PercentualeScontoNonValidaException() {
        super("Percentuale sconto non valida: deve essere tra 0 e 100");
    }
}

