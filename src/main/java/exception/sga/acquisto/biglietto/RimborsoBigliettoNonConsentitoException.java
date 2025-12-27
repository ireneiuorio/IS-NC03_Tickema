package exception.sga.acquisto.biglietto;


//Eccezione lanciata quando si tenta di rimborsare un biglietto non rimborsabile

public class RimborsoBigliettoNonConsentitoException extends Exception {

    private final int idBiglietto;
    private final String statoCorrente;

    public RimborsoBigliettoNonConsentitoException(int idBiglietto, String statoCorrente) {
        super("Impossibile rimborsare il biglietto " + idBiglietto +
                ". Biglietti validati non possono essere rimborsati. Stato corrente: " + statoCorrente);
        this.idBiglietto = idBiglietto;
        this.statoCorrente = statoCorrente;
    }

    public int getIdBiglietto() {
        return idBiglietto;
    }

    public String getStatoCorrente() {
        return statoCorrente;
    }
}