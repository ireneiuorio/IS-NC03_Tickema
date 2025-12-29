package control.SGC.Servlet;

import control.SGC.CLASSI.FilmService;
import control.SGC.DAO.FilmDAO;
import control.SGC.CLASSI.Film;
import exception.sgc.FilmNonTrovatoException;
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
 * Pattern URL: /catalogo/*
 *
 * Rotte:
 * - /catalogo/ o /catalogo -> Lista completa film
 * - /catalogo/film?id=X -> Dettaglio singolo film
 */
@WebServlet("/catalogo/*")
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

        // Ottiene il path dopo /catalogo/
        String path = request.getPathInfo() != null ? request.getPathInfo() : "/";

        try {
            switch (path) {
                case "/":
                    handleLista(request, response);
                    break;

                case "/film":
                    handleDettaglio(request, response);
                    break;

                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.err.println("Errore in CatalogoServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore nel caricamento della pagina");
        }
    }

    /**
     * Gestisce il catalogo completo con filtri per ricerca.
     */
    private void handleLista(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
    }

    /**
     * Gestisce il dettaglio di un singolo film.
     */
    private void handleDettaglio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Recupera l'ID del film dalla query string
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "ID film mancante");
                return;
            }

            int idFilm = Integer.parseInt(idParam);

            // Recupera il film tramite il Service
            Film film = filmService.visualizzaDettagliFilm(idFilm);

            // Passa il film alla JSP
            request.setAttribute("film", film);

            // Forward alla pagina dettaglio
            request.getRequestDispatcher("/WEB-INF/views/dettaglio-film.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "ID film non valido");
        } catch (FilmNonTrovatoException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                    e.getMessage());
        } catch (Exception e) {
            System.err.println("Errore nel caricamento del film: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                    "Film non trovato");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}