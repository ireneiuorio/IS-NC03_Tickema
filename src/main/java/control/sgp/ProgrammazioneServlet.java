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
import service.sgc.FilmService;
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
public class ProgrammazioneServlet extends HttpServlet {

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
            case "slotDisponibili":
                caricaSlotDisponibili(richiesta, risposta);
                break;
            case "formMultipla":
                mostraFormCreazioneMultipla(richiesta, risposta);
                break;


            default:
                risposta.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "Azione non valida: " + azione);
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
    }

    // METODI VISUALIZZAZIONE

    /**
     * Mostra lista programmazioni filtrate
     */
    private void mostraLista(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        System.out.println("=== DEBUG MOSTRA LISTA ===");
        System.out.println("Context Path: " + richiesta.getContextPath());
        System.out.println("Servlet Path: " + richiesta.getServletPath());
        System.out.println("JSP Path: " + JSP_LISTA);

        ProgrammazioneService servizio = ottieniServizio(richiesta);

        try {
            String parametroIdFilm = richiesta.getParameter("idFilm");
            String parametroData = richiesta.getParameter("data");
            String parametroIdSala = richiesta.getParameter("idSala");

            System.out.println("Parametri ricevuti:");
            System.out.println("- idFilm: " + parametroIdFilm);
            System.out.println("- data: " + parametroData);
            System.out.println("- idSala: " + parametroIdSala);

            List<Programmazione> programmazioni;

            if (parametroIdFilm != null && !parametroIdFilm.isEmpty()) {
                System.out.println("→ Recupero programmazioni per film ID: " + parametroIdFilm);
                int idFilm = Integer.parseInt(parametroIdFilm);
                programmazioni = servizio.visualizzaProgrammazioniFilm(idFilm);

                FilmService servizioFilm = new FilmService(ottieniConnessione(richiesta));
                Film film = servizioFilm.visualizzaDettagliFilm(idFilm);
                System.out.println("→ Film trovato: " + (film != null ? film.getTitolo() : "NULL"));
                richiesta.setAttribute("film", film);

            } else if (parametroData != null && !parametroData.isEmpty()) {
                System.out.println("→ Recupero programmazioni per data: " + parametroData);
                LocalDate data = LocalDate.parse(parametroData, FORMATTATORE_DATA);

                if (parametroIdSala != null && !parametroIdSala.isEmpty()) {
                    int idSala = Integer.parseInt(parametroIdSala);
                    System.out.println("→ Con filtro sala ID: " + idSala);
                    programmazioni = servizio.getProgrammazioniPerSala(idSala, data);
                } else {
                    programmazioni = servizio.getProgrammazioniPerData(data);
                }

            } else {
                // ✅ MODIFICA: Recupera TUTTE le programmazioni
                System.out.println("→ Nessun parametro: recupero TUTTE le programmazioni");
                programmazioni = servizio.getAllProgrammazioni();
            }

            System.out.println("→ Programmazioni trovate: " + (programmazioni != null ? programmazioni.size() : "NULL"));

            richiesta.setAttribute("programmazioni", programmazioni);

            System.out.println("→ Tentativo di forward verso: " + JSP_LISTA);
            richiesta.getRequestDispatcher(JSP_LISTA).forward(richiesta, risposta);

            System.out.println("→ Forward completato con successo");
            System.out.println("=== FINE DEBUG MOSTRA LISTA ===");

        } catch (NumberFormatException e) {
            System.err.println("ERRORE: Parametro ID non valido");
            e.printStackTrace();
            throw new ServletException("Parametro ID non valido", e);
        } catch (DateTimeParseException e) {
            System.err.println("ERRORE: Formato data non valido");
            e.printStackTrace();
            throw new ServletException("Formato data non valido", e);
        } catch (RecuperoProgrammazioniException e) {
            System.err.println("ERRORE: Recupero programmazioni fallito");
            e.printStackTrace();
            throw new ServletException("Errore nel recupero delle programmazioni", e);
        } catch (Exception e) {
            System.err.println("ERRORE GENERICO in mostraLista:");
            System.err.println("Tipo: " + e.getClass().getName());
            System.err.println("Messaggio: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Errore imprevisto", e);
        }
    }

    /**
     * Mostra dettaglio singola programmazione
     */
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

    /**
     * AJAX endpoint per caricare slot disponibili
     */
    private void caricaSlotDisponibili(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        try {
            int idSala = leggiInteroObbligatorio(richiesta, "idSala");
            LocalDate data = leggiDataObbligatoria(richiesta, "data");

            Connection connessione = ottieniConnessione(richiesta);
            SlotOrariService servizioSlot = new SlotOrariService(connessione);

            List<SlotOrari> slots = servizioSlot.visualizzaSlotDisponibili(idSala, data);

            // Risposta JSON
            risposta.setContentType("application/json");
            risposta.setCharacterEncoding("UTF-8");

            StringBuilder json = new StringBuilder();
            json.append("{\"slots\":[");

            for (int i = 0; i < slots.size(); i++) {
                SlotOrari slot = slots.get(i);
                if (i > 0) json.append(",");

                json.append("{");
                json.append("\"idSlotOrario\":").append(slot.getIdSlotOrario()).append(",");
                json.append("\"oraInizio\":\"").append(slot.getOraInizio()).append("\",");
                json.append("\"oraFine\":\"").append(slot.getOraFine()).append("\",");
                json.append("\"stato\":\"").append(slot.getStato()).append("\"");
                json.append("}");
            }

            json.append("]}");

            risposta.getWriter().write(json.toString());

        } catch (IllegalArgumentException e) {
            risposta.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            risposta.setContentType("application/json");
            risposta.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");

        } catch (Exception e) {
            risposta.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            risposta.setContentType("application/json");
            risposta.getWriter().write("{\"error\":\"Errore nel recupero degli slot\"}");
        }
    }
    /**
     * Mostra form per creare nuova programmazione singola
     */
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

    /**
     * Mostra form per modificare programmazione esistente
     */
    private void mostraFormModifica(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        try {
            Connection connessione = ottieniConnessione(richiesta);

            // Prova prima da parametro, poi da attributo
            String idParam = richiesta.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                idParam = (String) richiesta.getAttribute("id");
            }

            if (idParam == null || idParam.isEmpty()) {
                throw new IllegalArgumentException("Parametro obbligatorio mancante: id");
            }

            int idProgrammazione = Integer.parseInt(idParam);

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
    /**
     * Mostra form per creazione multipla
     */
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

            // ✅ AGGIUNGI QUESTA RIGA
            richiesta.setAttribute("dataOggi", LocalDate.now().toString());

            richiesta.getRequestDispatcher(JSP_FORM_MULTIPLA).forward(richiesta, risposta);

        } catch (Exception e) {
            throw new ServletException("Errore nel caricamento del form multiplo", e);
        }
    }

    // METODI OPERAZIONI CRUD

    /**
     * Crea una nuova programmazione singola
     */
    private void creaProgrammazione(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        ProgrammazioneService servizio = ottieniServizio(richiesta);

        try {
            int idFilm = leggiInteroObbligatorio(richiesta, "idFilm");
            int idSala = leggiInteroObbligatorio(richiesta, "idSala");
            int idSlotOrario = leggiInteroObbligatorio(richiesta, "idSlotOrario");

            String tipo = leggiStringaObbligatoria(richiesta, "tipo");
            double prezzoBase = leggiDecimaleObbligatorio(richiesta, "prezzoBase");
            LocalDate data = leggiDataObbligatoria(richiesta, "data");

            Integer idTariffa = leggiInteroOpzionale(richiesta, "idTariffa");

            // RECUPERA L'ORA INIZIO DALLO SLOT
            Connection connessione = ottieniConnessione(richiesta);
            SlotOrariService slotService = new SlotOrariService(connessione);
            SlotOrari slot = slotService.getSlotOrarioById(idSlotOrario);

            if (slot == null) {
                throw new IllegalArgumentException("Slot orario non trovato");
            }

            LocalTime oraInizio = slot.getOraInizio();

            // Validazioni business
            if (prezzoBase <= 0) {
                throw new IllegalArgumentException("Il prezzo base deve essere maggiore di zero");
            }

            if (data.isBefore(LocalDate.now())) {
                throw new IllegalArgumentException("Non è possibile creare programmazioni nel passato");
            }

            // Creazione programmazione
            Programmazione programmazione = servizio.creaProgrammazioneSingola(
                    data, tipo, prezzoBase, oraInizio,
                    idFilm, idSala, idSlotOrario, idTariffa
            );

            HttpSession sessione = richiesta.getSession();
            sessione.setAttribute("messaggioSuccesso",
                    "Programmazione creata con successo! ID: " + programmazione.getIdProgrammazione());

            risposta.sendRedirect(richiesta.getContextPath() +
                    "/admin/programmazione?action=lista&idFilm=" + idFilm);

        } catch (IllegalArgumentException e) {
            // LOG DETTAGLIATO
            System.err.println("=== ERRORE IllegalArgumentException ===");
            System.err.println("Messaggio: " + e.getMessage());
            e.printStackTrace();
            System.err.println("=======================================");

            richiesta.setAttribute("messaggioErrore", e.getMessage());
            mostraFormCreazione(richiesta, risposta);

        } catch (CreazioneProgrammazioneException e) {
            // LOG DETTAGLIATO
            System.err.println("=== ERRORE CreazioneProgrammazioneException ===");
            System.err.println("Messaggio: " + e.getMessage());
            System.err.println("Causa: " + (e.getCause() != null ? e.getCause().getMessage() : "N/A"));
            e.printStackTrace();
            if (e.getCause() != null) {
                e.getCause().printStackTrace();
            }
            System.err.println("===============================================");

            richiesta.setAttribute("messaggioErrore",
                    "Impossibile creare la programmazione: " + e.getMessage());
            mostraFormCreazione(richiesta, risposta);

        } catch (Exception e) {
            // CATCH-ALL per altri errori
            System.err.println("=== ERRORE GENERICO ===");
            System.err.println("Tipo: " + e.getClass().getName());
            System.err.println("Messaggio: " + e.getMessage());
            e.printStackTrace();
            System.err.println("=======================");

            richiesta.setAttribute("messaggioErrore",
                    "Errore imprevisto: " + e.getMessage());
            mostraFormCreazione(richiesta, risposta);
        }
    }

    /**
     * Crea multiple programmazioni in batch
     */
    /**
     * Crea multiple programmazioni in batch
     */
    private void creaProgrammazioneMultipla(HttpServletRequest richiesta, HttpServletResponse risposta)
            throws ServletException, IOException {

        ProgrammazioneService servizio = ottieniServizio(richiesta);

        try {
            // Parsing parametri multipli
            int idFilm = leggiInteroObbligatorio(richiesta, "idFilm");
            String tipo = leggiStringaObbligatoria(richiesta, "tipo");
            double prezzoBase = leggiDecimaleObbligatorio(richiesta, "prezzoBase");

            String[] arrayDate = richiesta.getParameterValues("date[]");
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
            if (arraySale.length != numeroProgrammazioni ||
                    arraySlot.length != numeroProgrammazioni) {
                throw new IllegalArgumentException(
                        "I parametri delle programmazioni non corrispondono"
                );
            }

            // ✅ RECUPERA LE ORE DAGLI SLOT
            Connection connessione = ottieniConnessione(richiesta);
            SlotOrariService slotService = new SlotOrariService(connessione);

            // Converti in liste
            List<LocalDate> date = new ArrayList<>();
            List<LocalTime> ore = new ArrayList<>();
            List<Integer> idSale = new ArrayList<>();
            List<Integer> idSlot = new ArrayList<>();
            List<Integer> idTariffe = new ArrayList<>();

            for (int i = 0; i < numeroProgrammazioni; i++) {
                // Data
                date.add(LocalDate.parse(arrayDate[i], FORMATTATORE_DATA));

                // ✅ RECUPERA ORA INIZIO DALLO SLOT
                int idSlotOrario = Integer.parseInt(arraySlot[i]);
                SlotOrari slot = slotService.getSlotOrarioById(idSlotOrario);
                if (slot == null) {
                    throw new IllegalArgumentException(
                            "Slot orario non trovato per la programmazione " + (i + 1)
                    );
                }
                ore.add(slot.getOraInizio());

                // Sala
                idSale.add(Integer.parseInt(arraySale[i]));

                // Slot
                idSlot.add(idSlotOrario);

                // Tariffa (opzionale)
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

        } catch (Exception e) {
            // ✅ CATCH GENERICO PER ALTRI ERRORI
            e.printStackTrace();
            richiesta.setAttribute("messaggioErrore",
                    "Errore imprevisto: " + e.getMessage());
            mostraFormCreazioneMultipla(richiesta, risposta);
        }
    }

    /**
     * Modifica una programmazione esistente
     */
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
            String tipo = leggiStringaObbligatoria(richiesta, "tipo");
            String stato = leggiStringaObbligatoria(richiesta, "stato");
            double prezzoBase = leggiDecimaleObbligatorio(richiesta, "prezzoBase");

            Integer idTariffa = leggiInteroOpzionale(richiesta, "idTariffa");

            // RECUPERA L'ORA INIZIO DALLO SLOT
            Connection connessione = ottieniConnessione(richiesta);
            SlotOrariService slotService = new SlotOrariService(connessione);
            SlotOrari slot = slotService.getSlotOrarioById(idSlotOrario);

            if (slot == null) {
                throw new IllegalArgumentException("Slot orario non trovato");
            }

            LocalTime oraInizio = slot.getOraInizio();

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
            // Setta l'id come parametro manualmente
            richiesta.setAttribute("id", richiesta.getParameter("idProgrammazione"));
            mostraFormModifica(richiesta, risposta);

        } catch (ModificaProgrammazioneException e) {
            richiesta.setAttribute("messaggioErrore",
                    "Errore nella modifica: " + e.getMessage());
            // Setta l'id come parametro manualmente
            richiesta.setAttribute("id", richiesta.getParameter("idProgrammazione"));
            mostraFormModifica(richiesta, risposta);
        }
    }

    /**
     * Elimina una programmazione con gestione rimborsi automatici
     */
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

    private ProgrammazioneService ottieniServizio(HttpServletRequest richiesta) {
        Connection connessione = ottieniConnessione(richiesta);
        return new ProgrammazioneService(connessione);
    }

    private Connection ottieniConnessione(HttpServletRequest richiesta) {
        return (Connection) richiesta.getServletContext().getAttribute("dbConnection");
    }

    // PARSING PARAMETRI

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