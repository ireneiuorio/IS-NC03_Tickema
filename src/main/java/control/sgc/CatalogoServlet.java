package control.sgc;


import entity.sgc.Film;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.sgc.FilmService;

import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * CATALOGO SERVLET
 * Permette ricerca e filtri per: titolo, genere, durata, anno, data proiezione, film in programmazione
 */
@WebServlet("/catalogo")
public class CatalogoServlet extends HttpServlet {

    private FilmService filmService;

    @Override
    public void init() throws ServletException {
        Connection connection = (Connection) getServletContext().getAttribute("dbConnection");
        this.filmService = new FilmService(connection);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // ===== PARAMETRI DI RICERCA/FILTRO =====
            String searchTitolo = request.getParameter("titolo");
            String genere = request.getParameter("genere");
            String annoParam = request.getParameter("anno");
            String durataMinParam = request.getParameter("durataMin");
            String durataMaxParam = request.getParameter("durataMax");
            String dataProiezioneParam = request.getParameter("dataProiezione");
            String soloInProgrammazione = request.getParameter("inProgrammazione");

            // ===== CONVERSIONE PARAMETRI =====
            Integer anno = parseInteger(annoParam);
            Integer durataMin = parseInteger(durataMinParam);
            Integer durataMax = parseInteger(durataMaxParam);
            LocalDate dataProiezione = parseDate(dataProiezioneParam);
            boolean filtroInProgrammazione = "true".equals(soloInProgrammazione);

            // ===== LOG DEBUG =====
            System.out.println("=== CATALOGO SERVLET ===");
            System.out.println("Titolo: " + searchTitolo);
            System.out.println("Genere: " + genere);
            System.out.println("Anno: " + anno);
            System.out.println("Durata min: " + durataMin);
            System.out.println("Durata max: " + durataMax);
            System.out.println("Data proiezione: " + dataProiezione);
            System.out.println("Solo in programmazione: " + filtroInProgrammazione);

            // ===== APPLICA FILTRI =====
            List<Film> films = filmService.ricercaFilmConFiltri(
                    searchTitolo,
                    genere,
                    anno,
                    durataMin,
                    durataMax,
                    dataProiezione,
                    filtroInProgrammazione
            );

            System.out.println("Film trovati: " + films.size());

            // ===== DATI PER I FILTRI =====
            List<String> generiDisponibili = filmService.getAllGeneri();
            List<Integer> anniDisponibili = filmService.getAllAnni();

            // ===== PASSA DATI ALLA JSP =====
            request.setAttribute("films", films);
            request.setAttribute("generiDisponibili", generiDisponibili);
            request.setAttribute("anniDisponibili", anniDisponibili);

            // Mantieni i filtri selezionati (per ripopolare i campi)
            request.setAttribute("searchTitolo", searchTitolo != null ? searchTitolo : "");
            request.setAttribute("genereSelezionato", genere != null ? genere : "");
            request.setAttribute("annoSelezionato", anno);
            request.setAttribute("durataMin", durataMin);
            request.setAttribute("durataMax", durataMax);
            request.setAttribute("dataProiezione", dataProiezione);
            request.setAttribute("inProgrammazione", filtroInProgrammazione);

            // Forward alla JSP
            request.getRequestDispatcher("/WEB-INF/views/catalogo/catalogo.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println(" Errore nel catalogo: " + e.getMessage());
            e.printStackTrace();

            request.setAttribute("errore", "Errore nel caricamento del catalogo: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
        }
    }

    /**
     * Helper per parsing sicuro di Integer
     */
    private Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            System.err.println("Errore parsing integer: " + value);
            return null;
        }
    }

    /**
     * Helper per parsing sicuro di LocalDate
     */
    private LocalDate parseDate(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return LocalDate.parse(value.trim());
        } catch (DateTimeParseException e) {
            System.err.println("⚠Errore parsing data: " + value);
            return null;
        }
    }
}