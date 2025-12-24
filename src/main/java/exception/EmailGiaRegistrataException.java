package exception;

public class EmailGiaRegistrataException extends Exception {
    public EmailGiaRegistrataException() {
        super("L'indirizzo email è già associato ad un account");
    }
}
