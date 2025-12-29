package control.SGC.DAO;

import control.SGC.CLASSI.Film;
import it.unisa.tickema.model.DBManager;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

    /**
     * DAO per la gestione dei Film nel database.
     * Implementa operazioni CRUD (Create, Read, Update, Delete).
     */
    public class FilmDAO {

        private DBManager dbManager;

        public FilmDAO(DBManager dbManager) {
            this.dbManager = dbManager;
        }

        /**
         * Recupera tutti i film dal database.
         * @return Lista di tutti i film
         */
        public List<Film> findAll() {
            List<Film> films = new ArrayList<>();
            String query = "SELECT * FROM Film ORDER BY titolo ASC";

            try (Connection conn = dbManager.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(query)) {

                while (rs.next()) {
                    Film film = extractFilmFromResultSet(rs);
                    films.add(film);
                }

            } catch (SQLException e) {
                System.err.println("Errore nel recupero dei film: " + e.getMessage());
                e.printStackTrace();
            }

            return films;
        }

        /**
         * Recupera un film specifico tramite ID.
         * @param idFilm ID del film da cercare
         * @return Film trovato o null se non esiste
         */
        public Film findById(int idFilm) {
            String query = "SELECT * FROM Film WHERE idFilm = ?";
            Film film = null;

            try (Connection conn = dbManager.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(query)) {

                pstmt.setInt(1, idFilm);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    film = extractFilmFromResultSet(rs);
                }

                rs.close();

            } catch (SQLException e) {
                System.err.println("Errore nel recupero del film ID " + idFilm + ": " + e.getMessage());
                e.printStackTrace();
            }

            return film;
        }

        /**
         * Recupera film filtrati per genere.
         * @param genere Genere da filtrare
         * @return Lista di film del genere specificato
         */
        public List<Film> findByGenre(String genere) {
            List<Film> films = new ArrayList<>();
            String query = "SELECT * FROM Film WHERE genere = ? ORDER BY titolo ASC";

            try (Connection conn = dbManager.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(query)) {

                pstmt.setString(1, genere);
                ResultSet rs = pstmt.executeQuery();

                while (rs.next()) {
                    Film film = extractFilmFromResultSet(rs);
                    films.add(film);
                }

                rs.close();

            } catch (SQLException e) {
                System.err.println("Errore nel recupero dei film per genere: " + e.getMessage());
                e.printStackTrace();
            }

            return films;
        }

        /**
         * Cerca film per titolo (ricerca parziale).
         * @param titolo Titolo o parte del titolo da cercare
         * @return Lista di film che corrispondono alla ricerca
         */
        public List<Film> searchByTitle(String titolo) {
            List<Film> films = new ArrayList<>();
            String query = "SELECT * FROM Film WHERE titolo LIKE ? ORDER BY titolo ASC";

            try (Connection conn = dbManager.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(query)) {

                pstmt.setString(1, "%" + titolo + "%");
                ResultSet rs = pstmt.executeQuery();

                while (rs.next()) {
                    Film film = extractFilmFromResultSet(rs);
                    films.add(film);
                }

                rs.close();

            } catch (SQLException e) {
                System.err.println("Errore nella ricerca dei film: " + e.getMessage());
                e.printStackTrace();
            }

            return films;
        }

        /**
         * Salva un nuovo film nel database.
         * @param film Film da salvare
         * @return true se l'inserimento è riuscito, false altrimenti
         */
        public boolean save(Film film) {
            String query = "INSERT INTO Film (trama, titolo, anno, regista, genere, durata, locandina) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (Connection conn = dbManager.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

                pstmt.setString(1, film.getTrama());
                pstmt.setString(2, film.getTitolo());
                pstmt.setInt(3, film.getAnno());
                pstmt.setString(4, film.getRegista());
                pstmt.setString(5, film.genere());
                pstmt.setInt(6, film.getDurata());
                pstmt.setString(7, film.getLocandina());

                int rowsAffected = pstmt.executeUpdate();

                // Recupera l'ID generato
                if (rowsAffected > 0) {
                    ResultSet generatedKeys = pstmt.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        film.setIdFilm(generatedKeys.getInt(1));
                    }
                    generatedKeys.close();
                    return true;
                }

            } catch (SQLException e) {
                System.err.println("Errore nel salvataggio del film: " + e.getMessage());
                e.printStackTrace();
            }

            return false;
        }

        /**
         * Aggiorna un film esistente nel database.
         * @param film Film con i dati aggiornati
         * @return true se l'aggiornamento è riuscito, false altrimenti
         */
        public boolean update(Film film) {
            String query = "UPDATE Film SET trama = ?, titolo = ?, anno = ?, regista = ?, " +
                    "genere = ?, durata = ?, locandina = ? WHERE idFilm = ?";

            try (Connection conn = dbManager.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(query)) {

                pstmt.setString(1, film.getTrama());
                pstmt.setString(2, film.getTitolo());
                pstmt.setInt(3, film.getAnno());
                pstmt.setString(4, film.getRegista());
                pstmt.setString(5, film.genere());
                pstmt.setInt(6, film.getDurata());
                pstmt.setString(7, film.getLocandina());
                pstmt.setInt(8, film.getIdFilm());

                return pstmt.executeUpdate() > 0;

            } catch (SQLException e) {
                System.err.println("Errore nell'aggiornamento del film: " + e.getMessage());
                e.printStackTrace();
            }

            return false;
        }

        /**
         * Elimina un film dal database.
         * @param idFilm ID del film da eliminare
         * @return true se l'eliminazione è riuscita, false altrimenti
         */
        public boolean delete(int idFilm) {
            String query = "DELETE FROM Film WHERE idFilm = ?";

            try (Connection conn = dbManager.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(query)) {

                pstmt.setInt(1, idFilm);
                return pstmt.executeUpdate() > 0;

            } catch (SQLException e) {
                System.err.println("Errore nell'eliminazione del film: " + e.getMessage());
                e.printStackTrace();
            }

            return false;
        }

        /**
         * Metodo helper per estrarre un Film dal ResultSet.
         * @param rs ResultSet da cui estrarre i dati
         * @return Oggetto Film
         * @throws SQLException se ci sono errori nell'accesso ai dati
         */
        private Film extractFilmFromResultSet(ResultSet rs) throws SQLException {
            return new Film(
                    rs.getInt("idFilm"),
                    rs.getString("trama"),
                    rs.getString("titolo"),
                    rs.getInt("anno"),
                    rs.getString("regista"),
                    rs.getString("genere"),
                    rs.getInt("durata"),
                    rs.getString("locandina")
            );
        }
    }
