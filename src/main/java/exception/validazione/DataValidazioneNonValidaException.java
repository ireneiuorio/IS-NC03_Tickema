package exception.validazione;

import java.time.LocalDate;

/**
 * Eccezione lanciata quando la data di validazione non corrisponde alla data della proiezione
 */
public class DataValidazioneNonValidaException extends Exception {

    private final String qrCode;
    private final LocalDate dataProiezione;
    private final LocalDate dataValidazione;

    public DataValidazioneNonValidaException(String qrCode, LocalDate dataProiezione, LocalDate dataValidazione, String messaggio) {
        super(messaggio);
        this.qrCode = qrCode;
        this.dataProiezione = dataProiezione;
        this.dataValidazione = dataValidazione;
    }

    public String getQrCode() {
        return qrCode;
    }

    public LocalDate getDataProiezione() {
        return dataProiezione;
    }

    public LocalDate getDataValidazione() {
        return dataValidazione;
    }
}