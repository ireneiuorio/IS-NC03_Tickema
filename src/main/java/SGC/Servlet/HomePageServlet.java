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
 * Servlet per la gestione della Home Page.
 * Mostra i film in evidenza o consigliati.
 */
@WebServlet("/home")
public class HomePageServlet extends HttpServlet {

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
            // Recupera tutti i film tramite il Service Layer
            List<Film> films = filmService.visualizzaCatalogoFilm();

            // Limita a 8 film per la home (4 per riga su 2 righe)
            if (films.size() > 8) {
                films = films.subList(0, 8);
            }

            // Passa i film alla JSP
            request.setAttribute("films", films);

            // Forward alla home page
            request.getRequestDispatcher("/WEB-INF/views/home.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            System.err.println("Errore in HomeServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore nel caricamento della home page");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}