package exception;

public class PasswordErrataException extends Exception {
    public PasswordErrataException() {
        super("La password inserita è errata.");
    }
}
