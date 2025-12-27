package exception.sga.acquisto.biglietto;



//Eccezione lanciata quando un'operazione sullo stato del biglietto non è consentita

public class OperazioneStatoBigliettoException extends Exception {

    private final int idBiglietto;
    private final String statoCorrente;
    private final String operazione;

    public OperazioneStatoBigliettoException(int idBiglietto, String statoCorrente, String operazione) {
        super("Operazione '" + operazione + "' non consentita per il biglietto " + idBiglietto +
                ". Stato corrente: " + statoCorrente);
        this.idBiglietto = idBiglietto;
        this.statoCorrente = statoCorrente;
        this.operazione = operazione;
    }

    public int getIdBiglietto() {
        return idBiglietto;
    }

    public String getStatoCorrente() {
        return statoCorrente;
    }

    public String getOperazione() {
        return operazione;
    }
}