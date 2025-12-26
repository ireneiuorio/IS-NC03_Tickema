package exception.sgp.posto;

public class ProgrammazioneNonDisponibileException extends RuntimeException {
    public ProgrammazioneNonDisponibileException(String stato) {
        super("La programmazione non è disponibile per l'acquisto. Stato: " + stato);
    }
}
