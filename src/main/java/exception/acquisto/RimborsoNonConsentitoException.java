package exception.acquisto;
//Eccezione lanciata quando si tenta di rimborsare un acquisto non rimborsabile

public class RimborsoNonConsentitoException extends Exception {

    private final int idAcquisto;
    private final String statoCorrente;

    public RimborsoNonConsentitoException(int idAcquisto, String statoCorrente) {
        super("Impossibile rimborsare l'acquisto " + idAcquisto +
                ". Solo gli acquisti completati possono essere rimborsati. Stato corrente: " + statoCorrente);
        this.idAcquisto = idAcquisto;
        this.statoCorrente = statoCorrente;
    }

    public int getIdAcquisto() {
        return idAcquisto;
    }

    public String getStatoCorrente() {
        return statoCorrente;
    }
}