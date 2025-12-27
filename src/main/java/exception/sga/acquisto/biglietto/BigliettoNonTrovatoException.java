package exception.sga.acquisto.biglietto;


//Eccezione lanciata quando un biglietto non viene trovato

public class BigliettoNonTrovatoException extends Exception {

    private final Integer idBiglietto;
    private final String qrCode;

    public BigliettoNonTrovatoException(int idBiglietto) {
        super("Biglietto con ID " + idBiglietto + " non trovato");
        this.idBiglietto = idBiglietto;
        this.qrCode = null;
    }

    public BigliettoNonTrovatoException(String qrCode) {
        super("Biglietto con QR Code " + qrCode + " non trovato");
        this.idBiglietto = null;
        this.qrCode = qrCode;
    }

    public Integer getIdBiglietto() {
        return idBiglietto;
    }

    public String getQrCode() {
        return qrCode;
    }
}