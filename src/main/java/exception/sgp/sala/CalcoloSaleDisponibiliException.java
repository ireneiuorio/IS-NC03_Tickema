package exception.sgp.sala;

public class CalcoloSaleDisponibiliException extends RuntimeException {
    public CalcoloSaleDisponibiliException(Throwable cause) {
        super("Errore nel calcolo delle sale disponibili", cause);
    }
}
