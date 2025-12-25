package exception.validazione;

//Eccezione lanciata quando l'aggiornamento del biglietto durante la validazione fallisce
public class AggiornamentoBigliettoException extends Exception {

    private final String qrCode;

    public AggiornamentoBigliettoException(String qrCode, String message) {
        super(message);
        this.qrCode = qrCode;
    }

    public AggiornamentoBigliettoException(String qrCode, String message, Throwable cause) {
        super(message, cause);
        this.qrCode = qrCode;
    }

    public String getQrCode() {
        return qrCode;
    }
}