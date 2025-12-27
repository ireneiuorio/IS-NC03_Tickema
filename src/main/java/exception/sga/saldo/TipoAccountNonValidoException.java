package exception.sga.saldo;

//Eccezione lanciata quando si tenta di operare sul saldo di un account non autorizzato

public class TipoAccountNonValidoException extends Exception {

    private final int idAccount;
    private final String tipoAccount;

    public TipoAccountNonValidoException(int idAccount, String tipoAccount) {
        super("Solo gli utenti autenticati hanno un saldo. Tipo account: " + tipoAccount);
        this.idAccount = idAccount;
        this.tipoAccount = tipoAccount;
    }

    public int getIdAccount() {
        return idAccount;
    }

    public String getTipoAccount() {
        return tipoAccount;
    }
}