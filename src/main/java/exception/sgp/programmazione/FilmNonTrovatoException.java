package exception.sgp.programmazione;

public class FilmNonTrovatoException extends RuntimeException {
    public FilmNonTrovatoException(int idFilm) {
        super("Film non trovato con ID: " + idFilm);
    }
}
