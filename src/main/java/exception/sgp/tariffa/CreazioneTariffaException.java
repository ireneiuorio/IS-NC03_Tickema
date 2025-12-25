package exception.sgp.tariffa;

public class CreazioneTariffaException extends RuntimeException {
    public CreazioneTariffaException(Throwable cause) {
        super("Errore nella creazione della tariffa:" + cause);
    }
}
