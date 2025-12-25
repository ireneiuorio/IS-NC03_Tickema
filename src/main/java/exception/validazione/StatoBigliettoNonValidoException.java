package exception.validazione;

//Eccezione lanciata quando un biglietto non è nello stato corretto per essere validato

public class StatoBigliettoNonValidoException extends Exception {

    private final String qrCode;
    private final String statoCorrente;
    private final String messaggioDettagliato;

    public StatoBigliettoNonValidoException(String qrCode, String statoCorrente, String messaggioDettagliato) {
        super(messaggioDettagliato);
        this.qrCode = qrCode;
        this.statoCorrente = statoCorrente;
        this.messaggioDettagliato = messaggioDettagliato;
    }

    public String getQrCode() {
        return qrCode;
    }

    public String getStatoCorrente() {
        return statoCorrente;
    }

    public String getMessaggioDettagliato() {
        return messaggioDettagliato;
    }
}