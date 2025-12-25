package exception.sgp.programmazione;

public class ProgrammazioneNonTrovataException extends RuntimeException {
    public ProgrammazioneNonTrovataException(int idProgrammazione) {
        super("Programmazione non trovata con ID: " + idProgrammazione);
    }
}
