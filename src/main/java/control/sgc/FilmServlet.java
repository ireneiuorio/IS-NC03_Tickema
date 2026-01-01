package control.sgc;

import com.cloudinary.utils.ObjectUtils;
import entity.sgc.Film;
import entity.sgu.Utente;
import it.unisa.tickema.model.CloudinaryConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import service.sgc.FilmService;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import java.util.Map;


@WebServlet("/film")
@MultipartConfig
public class FilmServlet extends HttpServlet {

    private static final String JSP_CATALOGO = "/WEB-INF/views/film/catalogo.jsp";
    private static final String JSP_DETTAGLIO = "/WEB-INF/views/film/dettaglio.jsp";
    private static final String JSP_ADMIN_LISTA = "/WEB-INF/views/admin/film/lista.jsp";
    private static final String JSP_ADMIN_FORM = "/WEB-INF/views/admin/film/form-crea.jsp";

    @Override
    protected void doGet(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        String azione = richiesta.getParameter("action");

        // ✅ DEBUG DETTAGLIATO
        System.out.println("=== FILMCONTROL doGet DEBUG ===");
        System.out.println("Action ricevuta: [" + azione + "]");
        System.out.println("Action è null? " + (azione == null));

        if (azione != null) {
            System.out.println("Action length: " + azione.length());
            System.out.println("Action bytes: " + java.util.Arrays.toString(azione.getBytes()));
            System.out.println("Action equals 'api-lista': " + azione.equals("api-lista"));
            System.out.println("Action equals 'apilista': " + azione.equals("apilista"));
        }

        System.out.println("URL: " + richiesta.getRequestURL());
        System.out.println("Query: " + richiesta.getQueryString());
        System.out.println("================================");

        if (azione == null) {
            azione = "catalogo";
        }

        switch (azione) {
            case "catalogo":
                System.out.println("→ Caso: catalogo");
                mostraCatalogo(richiesta, risposta);
                break;

            case "dettaglio":
                System.out.println("→ Caso: dettaglio");
                mostraDettaglio(richiesta, risposta);
                break;

            case "api-lista":
            case "apilista":  // ✅ Aggiungi entrambi per sicurezza
                System.out.println("→ Caso: api-lista o apilista");
                listaFilmJSON(richiesta, risposta);
                return;

            case "admin-lista":
                System.out.println("→ Caso: admin-lista");
                if (!verificaAccessoAdmin(richiesta, risposta)) return;
                mostraListaAdmin(richiesta, risposta);
                break;

            case "admin-form-crea":
                System.out.println("→ Caso: admin-form-crea");
                if (!verificaAccessoAdmin(richiesta, risposta)) return;
                mostraFormCreazione(richiesta, risposta);
                break;

            case "admin-form-modifica":
                System.out.println("→ Caso: admin-form-modifica");
                if (!verificaAccessoAdmin(richiesta, risposta)) return;
                mostraFormModifica(richiesta, risposta);
                break;

            default:
                System.err.println("❌ CASO DEFAULT - Action non riconosciuta: [" + azione + "]");
                risposta.sendError(HttpServletResponse.SC_BAD_REQUEST, "Azione non valida: " + azione);
        }
    }

    @Override
    protected void doPost(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        if (!verificaAccessoAdmin(richiesta, risposta)) {
            return;
        }

        String azione = richiesta.getParameter("action");
        if (azione == null) {
            risposta.sendError(HttpServletResponse.SC_BAD_REQUEST, "Azione mancante");
            return;
        }

        switch (azione) {
            case "crea":
                //Inserimento film
                creaFilm(richiesta, risposta);
                break;

            case "modifica":
                //Modifica film
                modificaFilm(richiesta, risposta);
                break;

            case "elimina":
                //Eliminazione film
                eliminaFilm(richiesta, risposta);
                break;

            default:
                risposta.sendError(HttpServletResponse.SC_BAD_REQUEST, "Azione non valida");
        }
    }

    // METODI VISUALIZZAZIONE (PUBBLICI)
    /**
     * Mostra catalogo film con titolo, locandina, genere, durata
     */
    private void mostraCatalogo(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        FilmService servizio = ottieniServizio(richiesta);
        List<Film> film = servizio.visualizzaTuttiFilm();

        // Carica anche i generi per il filtro
        List<String> generi = servizio.getGeneriDisponibili();

        richiesta.setAttribute("film", film);
        richiesta.setAttribute("generi", generi);
        richiesta.getRequestDispatcher(JSP_CATALOGO).forward(richiesta, risposta);
    }

    /**
     * Mostra dettaglio film con tutte le info e programmazioni
     */
    private void mostraDettaglio(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        int idFilm = leggiInteroObbligatorio(richiesta, "id");
        FilmService servizio = ottieniServizio(richiesta);

        Film film = servizio.visualizzaDettagliFilm(idFilm);

        if (film == null) {
            risposta.sendError(HttpServletResponse.SC_NOT_FOUND, "Film non trovato");
            return;
        }

        // Carica le programmazioni per questo film (da ProgrammazioneService)
        // Le programmazioni verranno caricate via AJAX o in questa chiamata
        richiesta.setAttribute("film", film);
        richiesta.getRequestDispatcher(JSP_DETTAGLIO).forward(richiesta, risposta);
    }


    // METODI ADMIN

    /**
     *  Lista film per amministratore
     */
    private void mostraListaAdmin(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        FilmService servizio = ottieniServizio(richiesta);
        List<Film> films = servizio.visualizzaTuttiFilm();

        richiesta.setAttribute("films", films);
        richiesta.getRequestDispatcher(JSP_ADMIN_LISTA).forward(richiesta, risposta);
    }

    /**
     * Form per creare nuovo film
     */
    private void mostraFormCreazione(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        richiesta.setAttribute("azione", "crea");
        richiesta.getRequestDispatcher(JSP_ADMIN_FORM).forward(richiesta, risposta);
    }

    /**
     * Form per modificare film esistente
     */
    private void mostraFormModifica(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        int idFilm = leggiInteroObbligatorio(richiesta, "id");
        FilmService servizio = ottieniServizio(richiesta);

        Film film = servizio.visualizzaDettagliFilm(idFilm);

        if (film == null) {
            risposta.sendError(HttpServletResponse.SC_NOT_FOUND, "Film non trovato");
            return;
        }

        richiesta.setAttribute("film", film);
        richiesta.setAttribute("azione", "modifica");
        richiesta.getRequestDispatcher(JSP_ADMIN_FORM).forward(richiesta, risposta);
    }

    /**
     * Crea nuovo film nel catalogo
     */
    /**
     * Crea nuovo film nel catalogo con upload Cloudinary
     */
    private void creaFilm(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        FilmService servizio = ottieniServizio(richiesta);

        try {
            String trama = richiesta.getParameter("trama");
            String titolo = leggiStringaObbligatoria(richiesta, "titolo");
            int anno = leggiInteroObbligatorio(richiesta, "anno");
            String regista = leggiStringaObbligatoria(richiesta, "regista");
            String genere = leggiStringaObbligatoria(richiesta, "genere");
            int durata = leggiInteroObbligatorio(richiesta, "durata");

            // UPLOAD IMMAGINE SU CLOUDINARY
            Part filePart = richiesta.getPart("locandina");
            String urlLocandina = null;

            if (filePart != null && filePart.getSize() > 0) {
                byte[] fileBytes = filePart.getInputStream().readAllBytes();

                Map uploadResult = CloudinaryConfig.getCloudinary()
                        .uploader()
                        .upload(fileBytes, ObjectUtils.emptyMap());

                urlLocandina = (String) uploadResult.get("url");
            } else {
                throw new IllegalArgumentException("La locandina è obbligatoria");
            }

            Film film = servizio.creaFilm(trama, titolo, anno, regista, genere, durata, urlLocandina);

            HttpSession sessione = richiesta.getSession();
            sessione.setAttribute("messaggioSuccesso",
                    "Film '" + film.getTitolo() + "' creato con successo!");

            risposta.sendRedirect(richiesta.getContextPath() + "/film?action=admin-lista");

        } catch (IllegalArgumentException e) {
            richiesta.setAttribute("messaggioErrore", e.getMessage());
            mostraFormCreazione(richiesta, risposta);
        } catch (Exception e) {
            richiesta.setAttribute("messaggioErrore", "Errore durante l'upload: " + e.getMessage());
            mostraFormCreazione(richiesta, risposta);
        }
    }

    /**
     * Modifica film esistente
     */
    private void modificaFilm(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        FilmService servizio = ottieniServizio(richiesta);

        try {
            int idFilm = leggiInteroObbligatorio(richiesta, "idFilm");
            String trama = richiesta.getParameter("trama");
            String titolo = leggiStringaObbligatoria(richiesta, "titolo");
            int anno = leggiInteroObbligatorio(richiesta, "anno");
            String regista = leggiStringaObbligatoria(richiesta, "regista");
            String genere = leggiStringaObbligatoria(richiesta, "genere");
            int durata = leggiInteroObbligatorio(richiesta, "durata");
            String locandina = leggiStringaObbligatoria(richiesta, "locandina");

            boolean successo = servizio.modificaFilm(idFilm, trama, titolo, anno,
                    regista, genere, durata, locandina);

            if (successo) {
                HttpSession sessione = richiesta.getSession();
                sessione.setAttribute("messaggioSuccesso",
                        "Film modificato con successo!");

                risposta.sendRedirect(richiesta.getContextPath() + "/film?action=admin-lista");
            } else {
                throw new RuntimeException("Errore durante la modifica");
            }

        } catch (Exception e) {
            richiesta.setAttribute("messaggioErrore", e.getMessage());
            mostraFormModifica(richiesta, risposta);
        }
    }

    /**
     * Elimina film dal catalogo
     * Richiede conferma se ci sono programmazioni attive
     */
    private void eliminaFilm(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        FilmService servizio = ottieniServizio(richiesta);

        try {
            int idFilm = leggiInteroObbligatorio(richiesta, "id");
            String conferma = richiesta.getParameter("conferma");

            // Verifica se ci sono programmazioni attive (da implementare)
            // boolean hasProgrammazioniAttive = verificaProgrammazioniAttive(idFilm);

            if (!"true".equals(conferma)) {
                // Richiedi conferma
                Film film = servizio.visualizzaDettagliFilm(idFilm);
                richiesta.setAttribute("film", film);
                richiesta.setAttribute("richiestaConferma", true);
                richiesta.getRequestDispatcher(JSP_ADMIN_LISTA).forward(richiesta, risposta);
                return;
            }

            boolean successo = servizio.eliminaFilm(idFilm);

            if (successo) {
                HttpSession sessione = richiesta.getSession();
                sessione.setAttribute("messaggioSuccesso", "Film eliminato con successo!");
            }

            risposta.sendRedirect(richiesta.getContextPath() + "/film?action=admin-lista");

        } catch (Exception e) {
            HttpSession sessione = richiesta.getSession();
            sessione.setAttribute("messaggioErrore", "Errore: " + e.getMessage());
            risposta.sendRedirect(richiesta.getContextPath() + "/film?action=admin-lista");
        }
    }

    //ENDPOINT API
    /**
     * Restituisce la lista di tutti i film in formato JSON
     * Per uso nel modal di selezione film
     */
    private void listaFilmJSON(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws IOException {

        System.out.println("=== LISTA FILM JSON ===");

        FilmService servizio = ottieniServizio(richiesta);

        try {
            List<Film> films = servizio.visualizzaTuttiFilm();
            System.out.println("Film recuperati: " + films.size());

            // Imposta headers
            risposta.setContentType("application/json");
            risposta.setCharacterEncoding("UTF-8");
            risposta.setHeader("Cache-Control", "no-cache");

            // Costruisci JSON
            StringBuilder json = new StringBuilder("[");

            for (int i = 0; i < films.size(); i++) {
                Film film = films.get(i);

                if (i > 0) {
                    json.append(",");
                }

                json.append("{");
                json.append("\"idFilm\":").append(film.getIdFilm()).append(",");
                json.append("\"titolo\":\"").append(escapeJson(film.getTitolo())).append("\",");
                json.append("\"anno\":").append(film.getAnno()).append(",");
                json.append("\"genere\":\"").append(escapeJson(film.getGenere())).append("\",");
                json.append("\"durata\":").append(film.getDurata()).append(",");
                json.append("\"regista\":\"").append(escapeJson(film.getRegista())).append("\"");
                json.append("}");
            }

            json.append("]");

            String jsonString = json.toString();
            System.out.println("JSON generato, lunghezza: " + jsonString.length());

            // Scrivi e chiudi
            risposta.getWriter().write(jsonString);
            risposta.getWriter().flush();
            risposta.getWriter().close();  // ✅ CHIUDI LO STREAM

            System.out.println("✅ Risposta JSON inviata");

            // ✅ IMPORTANTE: NON continuare l'esecuzione
            return;

        } catch (Exception e) {
            System.err.println("❌ ERRORE in listaFilmJSON:");
            e.printStackTrace();

            risposta.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            risposta.setContentType("application/json");
            risposta.setCharacterEncoding("UTF-8");

            String errorMsg = escapeJson(e.getMessage());
            risposta.getWriter().write("{\"error\":\"" + errorMsg + "\"}");
            risposta.getWriter().flush();
            risposta.getWriter().close();  // ✅ CHIUDI

            return;  // ✅ ESCI
        }
    }

    /**
     * Escape dei caratteri speciali per JSON
     */
    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }

        StringBuilder sb = new StringBuilder();

        for (char c : str.toCharArray()) {
            switch (c) {
                case '"':
                    sb.append("\\\"");
                    break;
                case '\\':
                    sb.append("\\\\");
                    break;
                case '/':
                    sb.append("\\/");
                    break;
                case '\b':
                    sb.append("\\b");
                    break;
                case '\f':
                    sb.append("\\f");
                    break;
                case '\n':
                    sb.append("\\n");
                    break;
                case '\r':
                    sb.append("\\r");
                    break;
                case '\t':
                    sb.append("\\t");
                    break;
                default:
                    // Caratteri speciali Unicode
                    if (c < ' ' || c > '~') {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
                    break;
            }
        }

        return sb.toString();
    }


    // METODI UTILITY
    private boolean verificaAccessoAdmin(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws IOException {

        HttpSession sessione = richiesta.getSession(false);

        if (sessione == null) {
            risposta.sendRedirect(richiesta.getContextPath() + "/utente/login");
            return false;
        }

        Utente utente = (Utente) sessione.getAttribute("utenteLoggato");

        if (utente == null) {
            risposta.sendRedirect(richiesta.getContextPath() + "/utente/login");
            return false;
        }

        if (!"Admin".equalsIgnoreCase(utente.getTipoAccount())) {
            risposta.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Accesso negato: permessi amministratore richiesti");
            return false;
        }

        return true;
    }

    private FilmService ottieniServizio(HttpServletRequest richiesta) {
        Connection connessione = (Connection) richiesta.getServletContext()
                .getAttribute("dbConnection"); // ← minuscolo!
        return new FilmService(connessione);
    }

    private int leggiInteroObbligatorio(HttpServletRequest richiesta, String nome) {
        String valore = richiesta.getParameter(nome);
        if (valore == null || valore.trim().isEmpty()) {
            throw new IllegalArgumentException("Parametro obbligatorio: " + nome);
        }
        return Integer.parseInt(valore.trim());
    }

    private String leggiStringaObbligatoria(HttpServletRequest richiesta, String nome) {
        String valore = richiesta.getParameter(nome);
        if (valore == null || valore.trim().isEmpty()) {
            throw new IllegalArgumentException("Parametro obbligatorio: " + nome);
        }
        return valore.trim();
    }
}