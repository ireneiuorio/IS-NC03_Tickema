package repository.sgc;

import entity.sgc.Film;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FilmDAO {
    private final Connection connection;

    public FilmDAO(Connection connection) {
        if (connection == null) {
            throw new IllegalArgumentException("La connessione non può essere null");
        }
        this.connection = connection;
    }

    /**
     * Inserisce un nuovo film
     */
    public boolean doSave(Film film) throws SQLException {
        String query = "INSERT INTO FILM (trama, titolo, anno, regista, genere, durata, locandina) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, film.getTrama());
            ps.setString(2, film.getTitolo());
            ps.setInt(3, film.getAnno());
            ps.setString(4, film.getRegista());
            ps.setString(5, film.getGenere());
            ps.setInt(6, film.getDurata());
            ps.setString(7, film.getLocandina());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        film.setIdFilm(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        }
    }

    /**
     * Recupera un film tramite ID (chiave primaria)
     */
    public Film doRetrieveByKey(int idFilm) throws SQLException {
        String query = "SELECT * FROM FILM WHERE idFilm = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idFilm);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractFilmFromResultSet(rs);
                }
            }
        }

        return null;
    }

    /**
     * Recupera un film tramite ID (alias)
     */
    public Film doRetrieveById(int idFilm) throws SQLException {
        return doRetrieveByKey(idFilm);
    }

    /**
     * Recupera tutti i film ordinati per titolo
     */
    public List<Film> doRetrieveAll() throws SQLException {
        String query = "SELECT * FROM FILM ORDER BY titolo, anno DESC";
        List<Film> films = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                films.add(extractFilmFromResultSet(rs));
            }
        }

        return films;
    }

    /**
     * Cerca film per titolo (ricerca parziale)
     */
    public List<Film> doRetrieveByTitolo(String titolo) throws SQLException {
        String query = "SELECT * FROM FILM WHERE titolo LIKE ? ORDER BY anno DESC";
        List<Film> films = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, "%" + titolo + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    films.add(extractFilmFromResultSet(rs));
                }
            }
        }

        return films;
    }

    /**
     * Recupera film per genere
     */
    public List<Film> doRetrieveByGenere(String genere) throws SQLException {
        String query = "SELECT * FROM FILM WHERE genere = ? ORDER BY titolo";
        List<Film> films = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, genere);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    films.add(extractFilmFromResultSet(rs));
                }
            }
        }

        return films;
    }

    /**
     * Recupera film per anno
     */
    public List<Film> doRetrieveByAnno(int anno) throws SQLException {
        String query = "SELECT * FROM FILM WHERE anno = ? ORDER BY titolo";
        List<Film> films = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, anno);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    films.add(extractFilmFromResultSet(rs));
                }
            }
        }

        return films;
    }

    /**
     * Recupera film per regista
     */
    public List<Film> doRetrieveByRegista(String regista) throws SQLException {
        String query = "SELECT * FROM FILM WHERE regista LIKE ? ORDER BY anno DESC";
        List<Film> films = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, "%" + regista + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    films.add(extractFilmFromResultSet(rs));
                }
            }
        }

        return films;
    }

    /**
     * Aggiorna un film esistente
     */
    public boolean doUpdate(Film film) throws SQLException {
        String query = "UPDATE FILM SET trama = ?, titolo = ?, anno = ?, regista = ?, " +
                "genere = ?, durata = ?, locandina = ? WHERE idFilm = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, film.getTrama());
            ps.setString(2, film.getTitolo());
            ps.setInt(3, film.getAnno());
            ps.setString(4, film.getRegista());
            ps.setString(5, film.getGenere());
            ps.setInt(6, film.getDurata());
            ps.setString(7, film.getLocandina());
            ps.setInt(8, film.getIdFilm());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Elimina un film
     */
    public boolean doDelete(int idFilm) throws SQLException {
        String query = "DELETE FROM FILM WHERE idFilm = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idFilm);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Verifica se esiste un film con stesso titolo, anno e regista (constraint UNIQUE)
     */
    public boolean doExistsByUniqueConstraint(String titolo, int anno, String regista) throws SQLException {
        String query = "SELECT COUNT(*) as count FROM FILM WHERE titolo = ? AND anno = ? AND regista = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, titolo);
            ps.setInt(2, anno);
            ps.setString(3, regista);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        }

        return false;
    }

    /**
     * Conta il numero totale di film
     */
    public int doCountAll() throws SQLException {
        String query = "SELECT COUNT(*) as totale FROM FILM";

        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("totale");
            }
        }

        return 0;
    }

    /**
     * Conta film per genere
     */
    public int doCountByGenere(String genere) throws SQLException {
        String query = "SELECT COUNT(*) as totale FROM FILM WHERE genere = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, genere);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("totale");
                }
            }
        }

        return 0;
    }

    /**
     * Recupera i generi distinti presenti nel catalogo
     */
    public List<String> doRetrieveGeneri() throws SQLException {
        String query = "SELECT DISTINCT genere FROM FILM ORDER BY genere";
        List<String> generi = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                generi.add(rs.getString("genere"));
            }
        }

        return generi;
    }

    /**
     * Estrae oggetto Film da ResultSet
     */
    private Film extractFilmFromResultSet(ResultSet rs) throws SQLException {
        Film film = new Film();
        film.setIdFilm(rs.getInt("idFilm"));
        film.setTrama(rs.getString("trama"));
        film.setTitolo(rs.getString("titolo"));
        film.setAnno(rs.getInt("anno"));
        film.setRegista(rs.getString("regista"));
        film.setGenere(rs.getString("genere"));
        film.setDurata(rs.getInt("durata"));
        film.setLocandina(rs.getString("locandina"));

        return film;
    }
}
