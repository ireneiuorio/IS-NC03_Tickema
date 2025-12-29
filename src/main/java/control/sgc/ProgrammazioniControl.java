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
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Servlet per la visualizzazione delle programmazioni lato utente
 * Gestisce la vista pubblica delle proiezioni disponibili
 */
@WebServlet("/programmazioni")
public class ProgrammazioniControl extends HttpServlet {

    private static final String JSP_DETTAGLIO = "/WEB-INF/views/programmazioni-dettaglio.jsp";

    @Override
    protected void doGet(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        try {
            // Ottieni ID film (obbligatorio)
            String idFilmParam = richiesta.getParameter("idFilm");

            if (idFilmParam == null || idFilmParam.trim().isEmpty()) {
                risposta.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "ID film mancante");
                return;
            }

            int idFilm = Integer.parseInt(idFilmParam);

            // Ottieni connessione
            Connection connection = ottieniConnessione(richiesta);

            // Recupera informazioni film
            FilmService filmService = new FilmService(connection);
            Film film = filmService.visualizzaDettagliFilm(idFilm);

            if (film == null) {
                risposta.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Film non trovato");
                return;
            }

            // Recupera programmazioni del film
            ProgrammazioneService programmazioneService =
                    new ProgrammazioneService(connection);

            List<Programmazione> tutteProgrammazioni =
                    programmazioneService.visualizzaProgrammazioniFilm(idFilm);

            // Filtra solo programmazioni future e disponibili
            LocalDate oggi = LocalDate.now();
            List<Programmazione> programmazioniFuture = tutteProgrammazioni.stream()
                    .filter(p -> !p.getDataProgrammazione().isBefore(oggi))
                    .filter(p -> "DISPONIBILE".equals(p.getStato()) ||
                            "IN CORSO".equals(p.getStato()))
                    .collect(Collectors.toList());

            // Gestione filtro data opzionale
            String dataParam = richiesta.getParameter("data");
            if (dataParam != null && !dataParam.trim().isEmpty()) {
                LocalDate dataFiltro = LocalDate.parse(dataParam);
                programmazioniFuture = programmazioniFuture.stream()
                        .filter(p -> p.getDataProgrammazione().equals(dataFiltro))
                        .collect(Collectors.toList());

                richiesta.setAttribute("dataFiltro", dataFiltro);
            }

            // Passa dati alla JSP
            richiesta.setAttribute("film", film);
            richiesta.setAttribute("programmazioni", programmazioniFuture);

            // Forward alla vista
            richiesta.getRequestDispatcher(JSP_DETTAGLIO)
                    .forward(richiesta, risposta);

        } catch (NumberFormatException e) {
            risposta.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "ID film non valido");
        } catch (Exception e) {
            System.err.println("[ERRORE ProgrammazioniControl] " + e.getMessage());
            e.printStackTrace();

            richiesta.setAttribute("messaggioErrore",
                    "Errore durante il caricamento delle programmazioni: " +
                            e.getMessage());
            richiesta.getRequestDispatcher("/WEB-INF/views/errore.jsp")
                    .forward(richiesta, risposta);
        }
    }

    /**
     * Recupera la connessione dal contesto dell'applicazione
     */
    private Connection ottieniConnessione(HttpServletRequest richiesta) {
        return (Connection) richiesta.getServletContext()
                .getAttribute("DBConnection");
    }
}