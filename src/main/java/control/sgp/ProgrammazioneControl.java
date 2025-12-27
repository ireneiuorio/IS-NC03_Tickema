package control.sgp;

import entity.sgc.Film;
import entity.sgp.Programmazione;
import entity.sgp.Sala;
import entity.sgp.SlotOrari;
import entity.sgp.Tariffa;
import entity.sgu.Utente;
import exception.sgp.programmazione.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.sgp.ProgrammazioneService;
import service.sgp.SalaService;
import service.sgp.SlotOrariService;
import service.sgp.TariffaService;

import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet per la gestione delle programmazioni singole e multiple (metodi crud)
 */
@WebServlet("/admin/programmazione")
public class ProgrammazioneControl extends HttpServlet {

    private static final String JSP_LISTA = "/WEB-INF/views/admin/programmazione/lista.jsp";
    private static final String JSP_DETTAGLIO = "/WEB-INF/views/admin/programmazione/dettaglio.jsp";
    private static final String JSP_FORM_CREA = "/WEB-INF/views/admin/programmazione/form-crea.jsp";
    private static final String JSP_FORM_MODIFICA = "/WEB-INF/views/admin/programmazione/form-modifica.jsp";
    private static final String JSP_FORM_MULTIPLA = "/WEB-INF/views/admin/programmazione/form-multipla.jsp";


    // Formattatori
    private static final DateTimeFormatter FORMATTATORE_DATA = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter FORMATTATORE_ORA = DateTimeFormatter.ofPattern("HH:mm");

    @Override
    protected void doGet(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        if (!verificaAccessoAdmin(richiesta, risposta)) {
            return;
        }

        String azione = richiesta.getParameter("action");
        if (azione == null) {
            azione = "lista";
        }

        try {
            switch (azione) {
                case "lista":
                    mostraLista(richiesta, risposta);
                    break;

                case "dettaglio":
                    mostraDettaglio(richiesta, risposta);
                    break;

                case "formCrea":
                    mostraFormCreazione(richiesta, risposta);
                    break;

                case "formModifica":
                    mostraFormModifica(richiesta, risposta);
                    break;

                case "formMultipla":
                    mostraFormCreazioneMultipla(richiesta, risposta);
                    break;

                default:
                    risposta.sendError(HttpServletResponse.SC_BAD_REQUEST,
                            "Azione non valida: " + azione);
            }

        } catch (Exception e) {
            gestisciErrore(richiesta, risposta, e, "Errore nella visualizzazione");
        }
    }

    //OPERAZIONI CRUD
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
                    creaProgrammazione(richiesta, risposta);
                    break;

                case "creaMultipla":
                    creaProgrammazioneMultipla(richiesta, risposta);
                    break;

                case "modifica":
                    modificaProgrammazione(richiesta, risposta);
                    break;

                case "elimina":
                    eliminaProgrammazione(richiesta, risposta);
                    break;

                default:
                    risposta.sendError(HttpServletResponse.SC_BAD_REQUEST,
                            "Azione non valida: " + azione);
            }

        } catch (Exception e) {
            gestisciErrore(richiesta, risposta, e, "Errore nell'operazione");
        }
    }


    // METODI VISUALIZZAZIONE
    //Mostra lista programmazioni filtrate
    private void mostraLista(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        ProgrammazioneService servizio = ottieniServizio(richiesta);

        try {
            String parametroIdFilm = richiesta.getParameter("idFilm");
            String parametroData = richiesta.getParameter("data");
            String parametroIdSala = richiesta.getParameter("idSala");

            List<Programmazione> programmazioni;

            if (parametroIdFilm != null && !parametroIdFilm.isEmpty()) {
                // Lista per film specifico
                int idFilm = Integer.parseInt(parametroIdFilm);
                programmazioni = servizio.visualizzaProgrammazioniFilm(idFilm);

                // Carica dettagli film
                FilmService servizioFilm = new FilmService(ottieniConnessione(richiesta));
                Film film = servizioFilm.visualizzaDettagliFilm(idFilm);
                richiesta.setAttribute("film", film);

            } else if (parametroData != null && !parametroData.isEmpty()) {
                // Lista per data specifica
                LocalDate data = LocalDate.parse(parametroData, FORMATTATORE_DATA);

                if (parametroIdSala != null && !parametroIdSala.isEmpty()) {
                    int idSala = Integer.parseInt(parametroIdSala);
                    programmazioni = servizio.getProgrammazioniPerSala(idSala, data);
                } else {
                    programmazioni = servizio.getProgrammazioniPerData(data);
                }

            } else {
                // Programmazioni di oggi
                programmazioni = servizio.getProgrammazioniPerData(LocalDate.now());
            }

            richiesta.setAttribute("programmazioni", programmazioni);
            richiesta.getRequestDispatcher(JSP_LISTA).forward(richiesta, risposta);

        } catch (NumberFormatException e) {
            throw new ServletException("Parametro ID non valido", e);
        } catch (DateTimeParseException e) {
            throw new ServletException("Formato data non valido", e);
        } catch (RecuperoProgrammazioniException e) {
            throw new ServletException("Errore nel recupero delle programmazioni", e);
        }
    }

    //Mostra dettaglio singola programmazione
    private void mostraDettaglio(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        ProgrammazioneService servizio = ottieniServizio(richiesta);

        try {
            int idProgrammazione = leggiInteroObbligatorio(richiesta, "id");

            Programmazione programmazione = servizio.getProgrammazioneById(idProgrammazione);

            if (programmazione == null) {
                risposta.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Programmazione non trovata");
                return;
            }

            richiesta.setAttribute("programmazione", programmazione);
            richiesta.getRequestDispatcher(JSP_DETTAGLIO).forward(richiesta, risposta);

        } catch (RecuperoProgrammazioniException e) {
            throw new ServletException("Errore nel recupero della programmazione", e);
        }
    }

    //Mostra form per creare nuova programmazione singola
    private void mostraFormCreazione(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        try {
            Connection connection = ottieniConnessione(richiesta);
            int idFilm = leggiInteroObbligatorio(richiesta, "idFilm");

            // Carica film
            FilmService servizioFilm = new FilmService(connection);
            Film film = servizioFilm.visualizzaDettagliFilm(idFilm);

            if (film == null) {
                risposta.sendError(HttpServletResponse.SC_NOT_FOUND, "Film non trovato");
                return;
            }

            // Carica sale disponibili
            SalaService servizioSala = new SalaService(connection);
            List<Sala> sale = servizioSala.visualizzaTutteLeSale();

            // Carica tariffe disponibili
            TariffaService servizioTariffa = new TariffaService(connection);
            List<Tariffa> tariffe = servizioTariffa.visualizzaTariffe();

            richiesta.setAttribute("film", film);
            richiesta.setAttribute("sale", sale);
            richiesta.setAttribute("tariffe", tariffe);
            richiesta.setAttribute("dataDefault", LocalDate.now());

            richiesta.getRequestDispatcher(JSP_FORM_CREA).forward(richiesta, risposta);

        } catch (Exception e) {
            throw new ServletException("Errore nel caricamento del form", e);
        }
    }

    //Mostra form per modificare programmazione esistente
    private void mostraFormModifica(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        try {
            Connection connessione = ottieniConnessione(richiesta);
            int idProgrammazione = leggiInteroObbligatorio(richiesta, "id");

            ProgrammazioneService servizio = ottieniServizio(richiesta);
            Programmazione programmazione = servizio.getProgrammazioneById(idProgrammazione);

            if (programmazione == null) {
                risposta.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Programmazione non trovata");
                return;
            }

            // Carica dati per il form
            SalaService servizioSala = new SalaService(connessione);
            List<Sala> sale = servizioSala.visualizzaTutteLeSale();

            TariffaService servizioTariffa = new TariffaService(connessione);
            List<Tariffa> tariffe = servizioTariffa.visualizzaTariffe();

            SlotOrariService servizioSlot = new SlotOrariService(connessione);
            List<SlotOrari> slotDisponibili = servizioSlot.visualizzaSlotDisponibili(
                    programmazione.getIdSala(),
                    programmazione.getDataProgrammazione()
            );

            richiesta.setAttribute("programmazione", programmazione);
            richiesta.setAttribute("sale", sale);
            richiesta.setAttribute("tariffe", tariffe);
            richiesta.setAttribute("slotDisponibili", slotDisponibili);

            richiesta.getRequestDispatcher(JSP_FORM_MODIFICA).forward(richiesta, risposta);

        } catch (Exception e) {
            throw new ServletException("Errore nel caricamento del form modifica", e);
        }
    }

    //Mostra form per creazione multipla
    private void mostraFormCreazioneMultipla(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        try {
            Connection connessione = ottieniConnessione(richiesta);
            int idFilm = leggiInteroObbligatorio(richiesta, "idFilm");

            FilmService servizioFilm = new FilmService(connessione);
            Film film = servizioFilm.visualizzaDettagliFilm(idFilm);

            if (film == null) {
                risposta.sendError(HttpServletResponse.SC_NOT_FOUND, "Film non trovato");
                return;
            }

            SalaService servizioSala = new SalaService(connessione);
            List<Sala> sale = servizioSala.visualizzaTutteLeSale();

            TariffaService servizioTariffa = new TariffaService(connessione);
            List<Tariffa> tariffe = servizioTariffa.visualizzaTariffe();

            richiesta.setAttribute("film", film);
            richiesta.setAttribute("sale", sale);
            richiesta.setAttribute("tariffe", tariffe);

            richiesta.getRequestDispatcher(JSP_FORM_MULTIPLA).forward(richiesta, risposta);

        } catch (Exception e) {
            throw new ServletException("Errore nel caricamento del form multiplo", e);
        }
    }


    // METODI OPERAZIONI CRUD
    //Crea una nuova programmazione singola
    private void creaProgrammazione(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        ProgrammazioneService servizio = ottieniServizio(richiesta);

        try {
            // Validazione e parsing parametri
            int idFilm = leggiInteroObbligatorio(richiesta, "idFilm");
            int idSala = leggiInteroObbligatorio(richiesta, "idSala");
            int idSlotOrario = leggiInteroObbligatorio(richiesta, "idSlotOrario");

            String tipo = leggiStringaObbligatoria(richiesta, "tipo");
            double prezzoBase = leggiDecimaleObbligatorio(richiesta, "prezzoBase");

            LocalDate data = leggiDataObbligatoria(richiesta, "data");
            LocalTime oraInizio = leggiOraObbligatoria(richiesta, "oraInizio");

            Integer idTariffa = leggiInteroOpzionale(richiesta, "idTariffa");

            // Validazioni business
            if (prezzoBase <= 0) {
                throw new IllegalArgumentException(
                        "Il prezzo base deve essere maggiore di zero"
                );
            }

            if (data.isBefore(LocalDate.now())) {
                throw new IllegalArgumentException(
                        "Non è possibile creare programmazioni nel passato"
                );
            }

            // Creazione programmazione
            Programmazione programmazione = servizio.creaProgrammazioneSingola(
                    data, tipo, prezzoBase, oraInizio,
                    idFilm, idSala, idSlotOrario, idTariffa
            );

            // Risposta successo
            HttpSession sessione = richiesta.getSession();
            sessione.setAttribute("messaggioSuccesso",
                    "Programmazione creata con successo! ID: " + programmazione.getIdProgrammazione());

            risposta.sendRedirect(richiesta.getContextPath() +
                    "/admin/programmazione?action=lista&idFilm=" + idFilm);

        } catch (IllegalArgumentException e) {
            richiesta.setAttribute("messaggioErrore", e.getMessage());
            mostraFormCreazione(richiesta, risposta);

        } catch (CreazioneProgrammazioneException e) {
            richiesta.setAttribute("messaggioErrore",
                    "Impossibile creare la programmazione: " + e.getMessage());
            mostraFormCreazione(richiesta, risposta);
        }
    }

    //Crea multiple programmazioni in batch
    private void creaProgrammazioneMultipla(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        ProgrammazioneService servizio = ottieniServizio(richiesta);

        try {
            // Parsing parametri multipli
            int idFilm = leggiInteroObbligatorio(richiesta, "idFilm");
            String tipo = leggiStringaObbligatoria(richiesta, "tipo");
            double prezzoBase = leggiDecimaleObbligatorio(richiesta, "prezzoBase");

            String[] arrayDate = richiesta.getParameterValues("date[]");
            String[] arrayOre = richiesta.getParameterValues("ore[]");
            String[] arraySale = richiesta.getParameterValues("idSale[]");
            String[] arraySlot = richiesta.getParameterValues("idSlot[]");
            String[] arrayTariffe = richiesta.getParameterValues("idTariffa[]");

            if (arrayDate == null || arrayDate.length == 0) {
                throw new IllegalArgumentException(
                        "È necessario specificare almeno una programmazione"
                );
            }

            // Validazione lunghezze array
            int numeroProgrammazioni = arrayDate.length;
            if (arrayOre.length != numeroProgrammazioni ||
                    arraySale.length != numeroProgrammazioni ||
                    arraySlot.length != numeroProgrammazioni) {
                throw new IllegalArgumentException(
                        "I parametri delle programmazioni non corrispondono"
                );
            }

            // Converti in liste
            List<LocalDate> date = new ArrayList<>();
            List<LocalTime> ore = new ArrayList<>();
            List<Integer> idSale = new ArrayList<>();
            List<Integer> idSlot = new ArrayList<>();
            List<Integer> idTariffe = new ArrayList<>();

            for (int i = 0; i < numeroProgrammazioni; i++) {
                date.add(LocalDate.parse(arrayDate[i], FORMATTATORE_DATA));
                ore.add(LocalTime.parse(arrayOre[i], FORMATTATORE_ORA));
                idSale.add(Integer.parseInt(arraySale[i]));
                idSlot.add(Integer.parseInt(arraySlot[i]));

                if (arrayTariffe != null && i < arrayTariffe.length &&
                        !arrayTariffe[i].isEmpty()) {
                    idTariffe.add(Integer.parseInt(arrayTariffe[i]));
                } else {
                    idTariffe.add(null);
                }
            }

            // Creazione multipla
            List<Programmazione> programmazioni = servizio.creaProgrammazioneMultipla(
                    date, tipo, prezzoBase, ore, idFilm, idSale, idSlot, idTariffe
            );

            // Risposta successo
            HttpSession sessione = richiesta.getSession();
            sessione.setAttribute("messaggioSuccesso",
                    String.format("Create %d programmazioni con successo!",
                            programmazioni.size()));

            risposta.sendRedirect(richiesta.getContextPath() +
                    "/admin/programmazione?action=lista&idFilm=" + idFilm);

        } catch (IllegalArgumentException e) {
            richiesta.setAttribute("messaggioErrore", e.getMessage());
            mostraFormCreazioneMultipla(richiesta, risposta);

        } catch (CreazioneProgrammazioneMultiplaException e) {
            richiesta.setAttribute("messaggioErrore",
                    "Errore nella creazione multipla: " + e.getMessage());
            mostraFormCreazioneMultipla(richiesta, risposta);
        }
    }

    //Modifica una programmazione esistente
    private void modificaProgrammazione(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        ProgrammazioneService servizio = ottieniServizio(richiesta);

        try {
            // Parsing parametri
            int idProgrammazione = leggiInteroObbligatorio(richiesta, "idProgrammazione");
            int idFilm = leggiInteroObbligatorio(richiesta, "idFilm");
            int idSala = leggiInteroObbligatorio(richiesta, "idSala");
            int idSlotOrario = leggiInteroObbligatorio(richiesta, "idSlotOrario");

            LocalDate data = leggiDataObbligatoria(richiesta, "data");
            LocalTime oraInizio = leggiOraObbligatoria(richiesta, "oraInizio");
            String tipo = leggiStringaObbligatoria(richiesta, "tipo");
            String stato = leggiStringaObbligatoria(richiesta, "stato");
            double prezzoBase = leggiDecimaleObbligatorio(richiesta, "prezzoBase");

            Integer idTariffa = leggiInteroOpzionale(richiesta, "idTariffa");

            // Validazioni
            if (prezzoBase <= 0) {
                throw new IllegalArgumentException("Prezzo base non valido");
            }

            // Modifica
            boolean successo = servizio.modificaProgrammazione(
                    idProgrammazione, data, tipo, prezzoBase, stato, oraInizio,
                    idFilm, idSala, idSlotOrario, idTariffa
            );

            // Risposta
            if (successo) {
                HttpSession sessione = richiesta.getSession();
                sessione.setAttribute("messaggioSuccesso",
                        "Programmazione modificata con successo!");

                risposta.sendRedirect(richiesta.getContextPath() +
                        "/admin/programmazione?action=dettaglio&id=" + idProgrammazione);
            } else {
                throw new ModificaProgrammazioneException();
            }

        } catch (IllegalArgumentException e) {
            richiesta.setAttribute("messaggioErrore", e.getMessage());
            mostraFormModifica(richiesta, risposta);

        } catch (ModificaProgrammazioneException e) {
            richiesta.setAttribute("messaggioErrore",
                    "Errore nella modifica: " + e.getMessage());
            mostraFormModifica(richiesta, risposta);
        }
    }

    //Elimina una programmazione con gestione rimborsi automatici
    private void eliminaProgrammazione(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        ProgrammazioneService servizio = ottieniServizio(richiesta);

        try {
            int idProgrammazione = leggiInteroObbligatorio(richiesta, "id");
            int idFilm = leggiInteroObbligatorio(richiesta, "idFilm");

            // Conferma eliminazione
            String conferma = richiesta.getParameter("conferma");
            if (!"true".equals(conferma)) {
                Programmazione programmazione = servizio.getProgrammazioneById(idProgrammazione);
                richiesta.setAttribute("programmazione", programmazione);
                richiesta.setAttribute("richiestaConferma", true);
                richiesta.getRequestDispatcher(JSP_DETTAGLIO).forward(richiesta, risposta);
                return;
            }

            // Eliminazione con rimborsi
            boolean successo = servizio.eliminaProgrammazione(idProgrammazione);

            // Risposta
            if (successo) {
                HttpSession sessione = richiesta.getSession();
                sessione.setAttribute("messaggioSuccesso",
                        "Programmazione eliminata con successo. " +
                                "Tutti i biglietti sono stati rimborsati automaticamente.");

                risposta.sendRedirect(richiesta.getContextPath() +
                        "/admin/programmazione?action=lista&idFilm=" + idFilm);
            } else {
                throw new EliminazioneProgrammazioneException();
            }

        } catch (EliminazioneProgrammazioneException e) {
            HttpSession sessione = richiesta.getSession();
            sessione.setAttribute("messaggioErrore",
                    "Impossibile eliminare: " + e.getMessage());

            risposta.sendRedirect(richiesta.getContextPath() +
                    "/admin/programmazione?action=dettaglio&id=" +
                    richiesta.getParameter("id"));
        }
    }


    //Verifica che l'utente corrente sia un amministratore
    private boolean verificaAccessoAdmin(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws IOException {

        HttpSession sessione = richiesta.getSession(false);

        if (sessione == null) {
            risposta.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Sessione non valida");
            return false;
        }

        Utente utente = (Utente) sessione.getAttribute("user");

        if (utente == null) {
            risposta.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Autenticazione richiesta");
            return false;
        }

        if (!"ADMIN".equals(utente.getTipoAccount())) {
            risposta.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Accesso negato: permessi amministratore richiesti");
            return false;
        }

        return true;
    }

    /**
     * Recupera il service inizializzato con la connessione
     */
    private ProgrammazioneService ottieniServizio(HttpServletRequest richiesta) {
        Connection connessione = ottieniConnessione(richiesta);
        return new ProgrammazioneService(connessione);
    }

    /**
     * Recupera la connessione dal contesto dell'applicazione
     */
    private Connection ottieniConnessione(HttpServletRequest richiesta) {
        return (Connection) richiesta.getServletContext().getAttribute("DBConnection");
    }

    /**
     * Gestione centralizzata degli errori
     */
    private void gestisciErrore(HttpServletRequest richiesta, HttpServletResponse risposta,
                                Exception eccezione, String messaggioDefault)
            throws ServletException, IOException {

        System.err.println("[ERRORE] " + messaggioDefault + ": " + eccezione.getMessage());
        eccezione.printStackTrace();

        richiesta.setAttribute("messaggioErrore", messaggioDefault + ": " + eccezione.getMessage());

        String azione = richiesta.getParameter("action");
        if (azione != null && azione.startsWith("form")) {
            richiesta.getRequestDispatcher(JSP_FORM_CREA).forward(richiesta, risposta);
        } else {
            risposta.sendRedirect(richiesta.getContextPath() + "/admin/programmazione?action=lista");
        }
    }

    // ========================================
    // PARSING PARAMETRI
    // ========================================

    private int leggiInteroObbligatorio(HttpServletRequest richiesta, String nomeParametro) {
        String valore = richiesta.getParameter(nomeParametro);

        if (valore == null || valore.trim().isEmpty()) {
            throw new IllegalArgumentException("Parametro obbligatorio mancante: " + nomeParametro);
        }

        try {
            return Integer.parseInt(valore.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Formato non valido per " + nomeParametro + ": " + valore);
        }
    }

    private Integer leggiInteroOpzionale(HttpServletRequest richiesta, String nomeParametro) {
        String valore = richiesta.getParameter(nomeParametro);

        if (valore == null || valore.trim().isEmpty()) {
            return null;
        }

        try {
            return Integer.parseInt(valore.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String leggiStringaObbligatoria(HttpServletRequest richiesta, String nomeParametro) {
        String valore = richiesta.getParameter(nomeParametro);

        if (valore == null || valore.trim().isEmpty()) {
            throw new IllegalArgumentException("Parametro obbligatorio mancante: " + nomeParametro);
        }

        return valore.trim();
    }

    private double leggiDecimaleObbligatorio(HttpServletRequest richiesta, String nomeParametro) {
        String valore = richiesta.getParameter(nomeParametro);

        if (valore == null || valore.trim().isEmpty()) {
        throw new IllegalArgumentException("Parametro obbligatorio mancante: " + nomeParametro);
}
        try {
        return Double.parseDouble(valore.trim());
        } catch (NumberFormatException e) {
        throw new IllegalArgumentException("Formato decimale non valido per " + nomeParametro + ": " + valore);
    }
            }

private LocalDate leggiDataObbligatoria(HttpServletRequest richiesta, String nomeParametro) {
    String valore = richiesta.getParameter(nomeParametro);

    if (valore == null || valore.trim().isEmpty()) {
        throw new IllegalArgumentException("Parametro obbligatorio mancante: " + nomeParametro);
    }

    try {
        return LocalDate.parse(valore.trim(), FORMATTATORE_DATA);
    } catch (DateTimeParseException e) {
        throw new IllegalArgumentException(
                "Formato data non valido per " + nomeParametro + ": " + valore +
                        " (atteso: yyyy-MM-dd)"
        );
    }
}

private LocalTime leggiOraObbligatoria(HttpServletRequest richiesta, String nomeParametro) {
    String valore = richiesta.getParameter(nomeParametro);

    if (valore == null || valore.trim().isEmpty()) {
        throw new IllegalArgumentException("Parametro obbligatorio mancante: " + nomeParametro);
    }

    try {
        return LocalTime.parse(valore.trim(), FORMATTATORE_ORA);
    } catch (DateTimeParseException e) {
        throw new IllegalArgumentException(
                "Formato ora non valido per " + nomeParametro + ": " + valore +
                        " (atteso: HH:mm)"
        );
    }
}
}