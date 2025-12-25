package exception.saldo;

//Eccezione lanciata quando il saldo è insufficiente per completare l'operazione

public class SaldoInsufficienteException extends Exception {

    private final int idAccount;
    private final double saldoDisponibile;
    private final double importoRichiesto;

    public SaldoInsufficienteException(int idAccount, double saldoDisponibile, double importoRichiesto) {
        super("Saldo insufficiente per l'utente " + idAccount +
                ". Disponibile: €" + saldoDisponibile + ", Richiesto: €" + importoRichiesto);
        this.idAccount = idAccount;
        this.saldoDisponibile = saldoDisponibile;
        this.importoRichiesto = importoRichiesto;
    }

    public int getIdAccount() {
        return idAccount;
    }

    public double getSaldoDisponibile() {
        return saldoDisponibile;
    }

    public double getImportoRichiesto() {
        return importoRichiesto;
    }
}