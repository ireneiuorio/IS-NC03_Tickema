package service.sgc;

import entity.sgc.Film;
import repository.sgc.FilmDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class FilmService {
    private final FilmDAO filmDAO;

    public FilmService(Connection connection) {
        this.filmDAO = new FilmDAO(connection);
    }

    /**
     * Visualizza i dettagli di un film
     */
    public Film visualizzaDettagliFilm(int idFilm) {
        try {
            Film film = filmDAO.doRetrieveByKey(idFilm);

            if (film == null) {
                throw new IllegalArgumentException("Film con ID " + idFilm + " non trovato");
            }

            return film;
        } catch (SQLException e) {
            throw new RuntimeException("Errore nel recupero del film: " + e.getMessage(), e);
        }
    }

    /**
     * Visualizza tutti i film
     */
    public List<Film> visualizzaTuttiFilm() {
        try {
            return filmDAO.doRetrieveAll();
        } catch (SQLException e) {
            throw new RuntimeException("Errore nel recupero dei film: " + e.getMessage(), e);
        }
    }

    /**
     * Cerca film per titolo
     */
    public List<Film> cercaFilmPerTitolo(String titolo) {
        try {
            if (titolo == null || titolo.trim().isEmpty()) {
                throw new IllegalArgumentException("Il titolo di ricerca non può essere vuoto");
            }

            return filmDAO.doRetrieveByTitolo(titolo);
        } catch (SQLException e) {
            throw new RuntimeException("Errore nella ricerca dei film: " + e.getMessage(), e);
        }
    }

    /**
     * Recupera film per genere
     */
    public List<Film> getFilmPerGenere(String genere) {
        try {
            if (genere == null || genere.trim().isEmpty()) {
                throw new IllegalArgumentException("Il genere non può essere vuoto");
            }

            return filmDAO.doRetrieveByGenere(genere);
        } catch (SQLException e) {
            throw new RuntimeException("Errore nel recupero dei film per genere: " + e.getMessage(), e);
        }
    }

    /**
     * Recupera film per anno
     */
    public List<Film> getFilmPerAnno(int anno) {
        try {
            if (anno < 1888) {
                throw new IllegalArgumentException("Anno non valido");
            }

            return filmDAO.doRetrieveByAnno(anno);
        } catch (SQLException e) {
            throw new RuntimeException("Errore nel recupero dei film per anno: " + e.getMessage(), e);
        }
    }

    /**
     * Recupera film per regista
     */
    public List<Film> getFilmPerRegista(String regista) {
        try {
            if (regista == null || regista.trim().isEmpty()) {
                throw new IllegalArgumentException("Il regista non può essere vuoto");
            }

            return filmDAO.doRetrieveByRegista(regista);
        } catch (SQLException e) {
            throw new RuntimeException("Errore nel recupero dei film per regista: " + e.getMessage(), e);
        }
    }

    /**
     * Crea un nuovo film
     */
    public Film creaFilm(String trama, String titolo, int anno, String regista,
                         String genere, int durata, String locandina) {
        try {
            // Validazioni
            if (titolo == null || titolo.trim().isEmpty()) {
                throw new IllegalArgumentException("Il titolo è obbligatorio");
            }

            if (anno < 1888) {
                throw new IllegalArgumentException("Anno non valido");
            }

            if (regista == null || regista.trim().isEmpty()) {
                throw new IllegalArgumentException("Il regista è obbligatorio");
            }

            if (genere == null || genere.trim().isEmpty()) {
                throw new IllegalArgumentException("Il genere è obbligatorio");
            }

            if (durata <= 0) {
                throw new IllegalArgumentException("La durata deve essere positiva");
            }

            if (locandina == null || locandina.trim().isEmpty()) {
                throw new IllegalArgumentException("La locandina è obbligatoria");
            }

            // Verifica unicità (titolo, anno, regista)
            if (filmDAO.doExistsByUniqueConstraint(titolo, anno, regista)) {
                throw new IllegalArgumentException(
                        "Esiste già un film con questo titolo, anno e regista"
                );
            }

            // Crea entità
            Film film = new Film();
            film.setTrama(trama);
            film.setTitolo(titolo);
            film.setAnno(anno);
            film.setRegista(regista);
            film.setGenere(genere);
            film.setDurata(durata);
            film.setLocandina(locandina);

            // Salva nel database
            boolean success = filmDAO.doSave(film);

            if (!success) {
                throw new RuntimeException("Errore durante il salvataggio del film");
            }

            return film;

        } catch (SQLException e) {
            throw new RuntimeException("Errore nella creazione del film: " + e.getMessage(), e);
        }
    }

    /**
     * Modifica un film esistente
     */
    public boolean modificaFilm(int idFilm, String trama, String titolo, int anno,
                                String regista, String genere, int durata, String locandina) {
        try {
            Film film = filmDAO.doRetrieveByKey(idFilm);

            if (film == null) {
                throw new IllegalArgumentException("Film non trovato");
            }

            // Aggiorna campi
            film.setTrama(trama);
            film.setTitolo(titolo);
            film.setAnno(anno);
            film.setRegista(regista);
            film.setGenere(genere);
            film.setDurata(durata);
            film.setLocandina(locandina);

            return filmDAO.doUpdate(film);

        } catch (SQLException e) {
            throw new RuntimeException("Errore nella modifica del film: " + e.getMessage(), e);
        }
    }

    /**
     * Elimina un film
     */
    public boolean eliminaFilm(int idFilm) {
        try {
            if (!filmEsiste(idFilm)) {
                throw new IllegalArgumentException("Film non trovato");
            }

            // TODO: Verificare che non ci siano programmazioni attive collegate

            return filmDAO.doDelete(idFilm);

        } catch (SQLException e) {
            throw new RuntimeException("Errore nell'eliminazione del film: " + e.getMessage(), e);
        }
    }

    /**
     * Verifica se un film esiste
     */
    public boolean filmEsiste(int idFilm) {
        try {
            return filmDAO.doRetrieveByKey(idFilm) != null;
        } catch (SQLException e) {
            throw new RuntimeException("Errore nella verifica del film: " + e.getMessage(), e);
        }
    }

    /**
     * Conta il numero totale di film
     */
    public int contaFilm() {
        try {
            return filmDAO.doCountAll();
        } catch (SQLException e) {
            throw new RuntimeException("Errore nel conteggio dei film: " + e.getMessage(), e);
        }
    }

    /**
     * Recupera tutti i generi disponibili
     */
    public List<String> getGeneriDisponibili() {
        try {
            return filmDAO.doRetrieveGeneri();
        } catch (SQLException e) {
            throw new RuntimeException("Errore nel recupero dei generi: " + e.getMessage(), e);
        }
    }
}
