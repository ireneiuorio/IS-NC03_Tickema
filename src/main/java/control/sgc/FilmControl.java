package control.sgc;

import entity.sgc.Film;
import entity.sgu.Utente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.sgc.FilmService;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/film")
    public class FilmControl extends HttpServlet {

        private static final String JSP_CATALOGO = "/WEB-INF/views/film/catalogo.jsp";
        private static final String JSP_DETTAGLIO = "/WEB-INF/views/film/dettaglio.jsp";
        private static final String JSP_ADMIN_LISTA = "/WEB-INF/views/admin/film/lista.jsp";
        private static final String JSP_ADMIN_FORM = "/WEB-INF/views/admin/film/form.jsp";

        @Override
        protected void doGet(HttpServletRequest richiesta, HttpServletResponse risposta)
                throws ServletException, IOException {

            String azione = richiesta.getParameter("action");
            if (azione == null) {
                azione = "catalogo";
            }

            try {
                switch (azione) {
                    case "catalogo":
                        //Visualizzazione catalogo film (pubblico)
                        mostraCatalogo(richiesta, risposta);
                        break;

                    case "dettaglio":
                        //Visualizzazione dettaglio e programmazioni (pubblico)
                        mostraDettaglio(richiesta, risposta);
                        break;

                    case "ricerca":
                        //Ricerca e filtri
                        effettuaRicerca(richiesta, risposta);
                        break;

                    case "admin-lista":
                        //Gestione admin
                        if (!verificaAccessoAdmin(richiesta, risposta)) return;
                        mostraListaAdmin(richiesta, risposta);
                        break;

                    case "admin-form-crea":
                        //Form inserimento
                        if (!verificaAccessoAdmin(richiesta, risposta)) return;
                        mostraFormCreazione(richiesta, risposta);
                        break;

                    case "admin-form-modifica":
                        //Form modifica
                        if (!verificaAccessoAdmin(richiesta, risposta)) return;
                        mostraFormModifica(richiesta, risposta);
                        break;

                    default:
                        risposta.sendError(HttpServletResponse.SC_BAD_REQUEST, "Azione non valida");
                }

            } catch (Exception e) {
                gestisciErrore(richiesta, risposta, e);
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

            try {
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

            } catch (Exception e) {
                gestisciErrore(richiesta, risposta, e);
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

        /**
         * Ricerca con filtri (titolo, genere, anno, data proiezione)
         */
        private void effettuaRicerca(HttpServletRequest richiesta, HttpServletResponse risposta)
                throws ServletException, IOException {

            FilmService servizio = ottieniServizio(richiesta);

            String titolo = richiesta.getParameter("titolo");
            String genere = richiesta.getParameter("genere");
            String annoStr = richiesta.getParameter("anno");

            List<Film> risultati;

            // Applica filtri in base ai parametri
            if (titolo != null && !titolo.trim().isEmpty()) {
                risultati = servizio.cercaFilmPerTitolo(titolo);
            } else if (genere != null && !genere.trim().isEmpty()) {
                risultati = servizio.getFilmPerGenere(genere);
            } else if (annoStr != null && !annoStr.trim().isEmpty()) {
                int anno = Integer.parseInt(annoStr);
                risultati = servizio.getFilmPerAnno(anno);
            } else {
                risultati = servizio.visualizzaTuttiFilm();
            }

            // Carica generi per il filtro
            List<String> generi = servizio.getGeneriDisponibili();

            richiesta.setAttribute("films", risultati);
            richiesta.setAttribute("generi", generi);
            richiesta.setAttribute("filtroApplicato", true);
            richiesta.getRequestDispatcher(JSP_CATALOGO).forward(richiesta, risposta);
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
                String locandina = leggiStringaObbligatoria(richiesta, "locandina");

                Film film = servizio.creaFilm(trama, titolo, anno, regista, genere, durata, locandina);

                HttpSession sessione = richiesta.getSession();
                sessione.setAttribute("messaggioSuccesso",
                        "Film '" + film.getTitolo() + "' creato con successo!");

                risposta.sendRedirect(richiesta.getContextPath() + "/film?action=admin-lista");

            } catch (IllegalArgumentException e) {
                richiesta.setAttribute("messaggioErrore", e.getMessage());
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


        // METODI UTILITY
        private boolean verificaAccessoAdmin(HttpServletRequest richiesta, HttpServletResponse risposta)
                throws IOException {

            HttpSession sessione = richiesta.getSession(false);
            if (sessione == null) {
                risposta.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Autenticazione richiesta");
                return false;
            }

            Utente utente = (Utente) sessione.getAttribute("user");
            if (utente == null || !"ADMIN".equals(utente.getTipoAccount())) {
                risposta.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Accesso negato: permessi amministratore richiesti");
                return false;
            }

            return true;
        }

        private FilmService ottieniServizio(HttpServletRequest richiesta) {
            Connection connessione = (Connection) richiesta.getServletContext()
                    .getAttribute("DBConnection");
            return new FilmService(connessione);
        }

        private void gestisciErrore(HttpServletRequest richiesta, HttpServletResponse risposta,
                                    Exception eccezione) throws ServletException, IOException {
            System.err.println("[ERRORE FilmControl] " + eccezione.getMessage());
            eccezione.printStackTrace();

            richiesta.setAttribute("messaggioErrore", eccezione.getMessage());
            risposta.sendRedirect(richiesta.getContextPath() + "/film");
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

