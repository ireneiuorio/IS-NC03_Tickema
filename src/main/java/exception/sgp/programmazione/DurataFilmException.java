package exception.sgp.programmazione;

public class DurataFilmException extends RuntimeException {
    public DurataFilmException() {
        super("Errore nel caloclo della durata del film rispetto allo slot considerato");
    }
}
