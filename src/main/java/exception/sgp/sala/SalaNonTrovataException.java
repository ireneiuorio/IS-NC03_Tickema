package exception.sgp.sala;

public class SalaNonTrovataException extends RuntimeException {
    public SalaNonTrovataException(int idSala) {
        super("Sala non trovata con ID: " + idSala);
    }
}
