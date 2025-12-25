package exception.validazione;

//Eccezione lanciata quando la validazione di un biglietto fallisce

public class ValidazioneNonRiuscitaException extends Exception {

    private final String qrCode;
    private final String motivo;

    public ValidazioneNonRiuscitaException(String qrCode, String motivo) {
        super("Validazione biglietto fallita. QR Code: " + qrCode + ". Motivo: " + motivo);
        this.qrCode = qrCode;
        this.motivo = motivo;
    }

    public String getQrCode() {
        return qrCode;
    }

    public String getMotivo() {
        return motivo;
    }
}