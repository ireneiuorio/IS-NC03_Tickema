package exception.saldo;

//Eccezione lanciata quando l'aggiornamento del saldo fallisce

public class AggiornamentoSaldoException extends Exception {

    private final int idAccount;

    public AggiornamentoSaldoException(int idAccount, String message) {
        super(message);
        this.idAccount = idAccount;
    }

    public AggiornamentoSaldoException(int idAccount, String message, Throwable cause) {
        super(message, cause);
        this.idAccount = idAccount;
    }

    public int getIdAccount() {
        return idAccount;
    }
}