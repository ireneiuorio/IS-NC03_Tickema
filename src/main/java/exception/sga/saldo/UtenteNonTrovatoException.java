package exception.sga.saldo;

//Eccezione lanciata quando un utente non viene trovato

public class UtenteNonTrovatoException extends Exception {

    private final int idAccount;

    public UtenteNonTrovatoException(int idAccount) {
        super("Utente con ID " + idAccount + " non trovato");
        this.idAccount = idAccount;
    }

    public int getIdAccount() {
        return idAccount;
    }
}