package control.sgc;

import entity.sgc.Film;
import entity.sgp.Programmazione;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.sgc.FilmService;
import service.sgp.ProgrammazioneService;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

/**
 * DETTAGLIO FILM SERVLET
 * Mostra i dettagli completi di un film e le sue programmazioni disponibili
 * con possibilità di acquisto diretto
 */
@WebServlet("/dettaglio-film")
public class DettaglioFilmServlet extends HttpServlet {

    private FilmService filmService;
    private ProgrammazioneService programmazioneService;

    @Override
    public void init() throws ServletException {
        Connection connection = (Connection) getServletContext().getAttribute("dbConnection");
        this.filmService = new FilmService(connection);
        this.programmazioneService = new ProgrammazioneService(connection);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // ===== RECUPERA ID FILM =====
            String idFilmParam = request.getParameter("idFilm");

            if (idFilmParam == null || idFilmParam.trim().isEmpty()) {
                System.err.println("ID Film mancante, redirect a catalogo");
                response.sendRedirect(request.getContextPath() + "/catalogo");
                return;
            }

            int idFilm;
            try {
                idFilm = Integer.parseInt(idFilmParam);
            } catch (NumberFormatException e) {
                System.err.println("ID Film non valido: " + idFilmParam);
                response.sendRedirect(request.getContextPath() + "/catalogo");
                return;
            }

            System.out.println("=== DETTAGLIO FILM SERVLET ===");
            System.out.println("ID Film richiesto: " + idFilm);

            // ===== RECUPERA FILM =====
            Film film = filmService.visualizzaDettagliFilm(idFilm);

            if (film == null) {
                System.err.println("Film non trovato con ID: " + idFilm);
                request.setAttribute("errore", "Film non trovato");
                request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
                return;
            }

            System.out.println("Film recuperato: " + film.getTitolo());

            // ===== RECUPERA TUTTE LE PROGRAMMAZIONI DEL FILM =====
            List<Programmazione> programmazioni = programmazioneService.visualizzaProgrammazioniFilm(idFilm);

            System.out.println("Programmazioni trovate: " + programmazioni.size());

            // ===== ORDINA PER DATA E ORA =====
            programmazioni.sort((p1, p2) -> {
                int compareData = p1.getDataProgrammazione().compareTo(p2.getDataProgrammazione());
                if (compareData != 0) {
                    return compareData;
                }
                // Se hanno la stessa data, ordina per ora
                if (p1.getSlotOrari() != null && p2.getSlotOrari() != null) {
                    return p1.getSlotOrari().getOraInizio().compareTo(p2.getSlotOrari().getOraInizio());
                }
                return 0;
            });

            // ===== PASSA DATI ALLA JSP =====
            request.setAttribute("film", film);
            request.setAttribute("programmazioni", programmazioni);

            System.out.println("Forward a dettaglio-film.jsp");

            // Forward alla pagina dettaglio
            request.getRequestDispatcher("/WEB-INF/views/film/dettaglio-film.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            System.err.println("Errore business logic: " + e.getMessage());
            request.setAttribute("errore", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Errore imprevisto nel dettaglio film: " + e.getMessage());
            e.printStackTrace();

            request.setAttribute("errore", "Errore nel caricamento del dettaglio film");
            request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
        }
    }
}