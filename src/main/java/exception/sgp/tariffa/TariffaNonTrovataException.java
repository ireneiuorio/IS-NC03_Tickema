package exception.sgp.tariffa;

public class TariffaNonTrovataException extends RuntimeException {
    public TariffaNonTrovataException(int idTariffa) {
        super("Tariffa non trovata con ID: " + idTariffa);
    }
}
