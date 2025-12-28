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
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

/**
 * HOME SERVLET
 * Mostra la homepage con film consigliati e programmazioni
 */
@WebServlet(urlPatterns = {"", "/", "/home"})
public class HomeServlet extends HttpServlet {

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

        System.out.println("=== HOME SERVLET START ===");

        try {
            System.out.println("1. Recupero filmService...");

            // ===== FILM CONSIGLIATI =====
            System.out.println("2. Chiamata filmService.visualizzaTuttiFilm()...");
            List<Film> filmConsigliati = filmService.visualizzaTuttiFilm();
            System.out.println("3. Film recuperati: " + (filmConsigliati != null ? filmConsigliati.size() : "NULL"));

            // ===== PROGRAMMAZIONI DI OGGI =====
            LocalDate oggi = LocalDate.now();
            System.out.println("4. Data oggi: " + oggi);

            System.out.println("5. Chiamata programmazioneService.getProgrammazioniPerData()...");
            List<Programmazione> programmazioniOggi = programmazioneService.getProgrammazioniPerData(oggi);
            System.out.println("6. Programmazioni recuperate: " + (programmazioniOggi != null ? programmazioniOggi.size() : "NULL"));

            // Limita a massimo 6 per la home
            if (programmazioniOggi != null && programmazioniOggi.size() > 6) {
                programmazioniOggi = programmazioniOggi.subList(0, 6);
            }

            // Passa dati alla JSP
            System.out.println("7. Setting attributes...");
            request.setAttribute("filmConsigliati", filmConsigliati);
            request.setAttribute("programmazioniOggi", programmazioniOggi);
            request.setAttribute("dataOggi", oggi);

            System.out.println("8. Forward a index.jsp...");
            // Forward alla home
            request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);

            System.out.println("=== HOME SERVLET END ===");

        } catch (Exception e) {
            System.err.println("❌❌❌ ERRORE NELLA HOME SERVLET ❌❌❌");
            System.err.println("Tipo errore: " + e.getClass().getName());
            System.err.println("Messaggio: " + e.getMessage());
            System.err.println("Stack trace:");
            e.printStackTrace();

            request.setAttribute("errore", "Si è verificato un errore imprevisto: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
        }
    }
}