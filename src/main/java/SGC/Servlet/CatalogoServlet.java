package SGC.Servlet;

import SGC.CLASSI.FilmService;
import SGC.DAO.FilmDAO;
import SGC.CLASSI.Film;
import it.unisa.tickema.model.DBManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet per la gestione del Catalogo Film.
 * Supporta filtri per genere e ricerca per titolo.
 */
@WebServlet("/catalogo")
public class CatalogoServlet extends HttpServlet {

    private FilmService filmService;

    @Override
    public void init() throws ServletException {
        super.init();

        // Inizializza il DBManager (singleton a livello applicazione)
        DBManager dbManager = (DBManager) getServletContext().getAttribute("dbManager");
        if (dbManager == null) {
            dbManager = new DBManager();
            getServletContext().setAttribute("dbManager", dbManager);
        }

        // Inizializza il DAO
        FilmDAO filmDAO = new FilmDAO(dbManager);

        // Inizializza il Service (Facade Pattern)
        this.filmService = new FilmService(filmDAO);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Recupera parametri di filtro (opzionali)
            String ricerca = request.getParameter("search");
            String genere = request.getParameter("genere");
            String annoStr = request.getParameter("anno");

            Integer anno = null;
            if (annoStr != null && !annoStr.trim().isEmpty()) {
                try {
                    anno = Integer.parseInt(annoStr);
                } catch (NumberFormatException e) {
                    // Ignora anno non valido
                }
            }

            // Usa il Service per cercare i film con i filtri
            List<Film> films = filmService.cercaFilm(ricerca, genere, anno, null, null, null);

            // Passa i film e i parametri di ricerca alla JSP
            request.setAttribute("films", films);
            request.setAttribute("searchQuery", ricerca);
            request.setAttribute("selectedGenre", genere);
            request.setAttribute("selectedAnno", anno);

            // Forward alla pagina catalogo
            request.getRequestDispatcher("/WEB-INF/views/catalogo.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            System.err.println("Errore in CatalogoServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore nel caricamento del catalogo");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
