package exception.sgp.programmazione;

public class CalcoloPrezzoTariffatoException extends RuntimeException {
    public CalcoloPrezzoTariffatoException(Throwable cause) {
        super("Errore nel calcolo del prezzo tariffato", cause);
    }
}
