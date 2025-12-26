package exception.sgp.sala;

public class CapienzaIncoerenteException extends RuntimeException {
    public CapienzaIncoerenteException() {
        super("Capienza incoerente con il calcolo.");
    }
}
