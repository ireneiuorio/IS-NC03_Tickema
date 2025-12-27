package control.sga;

import entity.sgp.Posto;
import entity.sgp.Programmazione;
import entity.sgu.Utente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import repository.sgu.UtenteDAO;
import service.sga.AcquistoFacade;
import service.sga.RisultatoAcquisto;
import service.sgp.ProgrammazioneService;
import service.sgp.PostoService;
import service.sgp.RisultatoAssegnazione;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@WebServlet("/acquisto")
public class AcquistoServlet extends HttpServlet {

    private static final int DURATA_PRENOTAZIONE_MINUTI = 5; // Timer 5 minuti

    private ProgrammazioneService programmazioneService;
    private PostoService postoService;
    private AcquistoFacade acquistoFacade;

    @Override
    public void init() throws ServletException {
        Connection connection = (Connection) getServletContext().getAttribute("dbConnection");
        this.programmazioneService = new ProgrammazioneService(connection);
        this.postoService = new PostoService(connection);
        this.acquistoFacade = new AcquistoFacade(connection);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Verifica autenticazione
        Utente utente = (Utente) session.getAttribute("utente");
        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int idProgrammazione = Integer.parseInt(request.getParameter("idProgrammazione"));
            int numeroBiglietti = Integer.parseInt(request.getParameter("numeroBiglietti"));

            // Validazioni
            if (numeroBiglietti <= 0 || numeroBiglietti > 10) {
                request.setAttribute("errore", "Numero biglietti non valido (min 1, max 10)");
                request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
                return;
            }

            Programmazione programmazione = programmazioneService.getProgrammazioneById(idProgrammazione);

            if (programmazione == null) {
                request.setAttribute("errore", "Programmazione non trovata");
                request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
                return;
            }

            if (!"Disponibile".equals(programmazione.getStato())) {
                request.setAttribute("errore", "Programmazione non disponibile");
                request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
                return;
            }

            // Verifica disponibilità posti
            List<Posto> postiDisponibili = postoService.verificaDisponibilitaPosti(
                    idProgrammazione,
                    numeroBiglietti
            );

            if (postiDisponibili.isEmpty() || postiDisponibili.size() < numeroBiglietti) {
                request.setAttribute("errore",
                        "Posti insufficienti. Disponibili: " + postiDisponibili.size() +
                                ", Richiesti: " + numeroBiglietti);
                request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
                return;
            }

            // ASSEGNA POSTI AUTOMATICAMENTE
            RisultatoAssegnazione assegnazione = postoService.assegnaPostiAutomatico(
                    postiDisponibili,
                    numeroBiglietti
            );

            List<Posto> postiAssegnati = assegnazione.getPostiAssegnati();

            // ⏱️ OCCUPA TEMPORANEAMENTE I POSTI (5 minuti)
            boolean occupati = postoService.occupaTemporaneamente(postiAssegnati);

            if (!occupati) {
                request.setAttribute("errore",
                        "Alcuni posti sono stati prenotati da altri utenti. Riprova.");
                request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
                return;
            }

            // SALVA INFORMAZIONI IN SESSIONE
            session.setAttribute("postiOccupati", postiAssegnati);
            session.setAttribute("scadenzaCheckout",
                    LocalDateTime.now().plusMinutes(DURATA_PRENOTAZIONE_MINUTI));
            session.setAttribute("idProgrammazioneCheckout", idProgrammazione);
            session.setAttribute("vicinanzaGarantita", assegnazione.isVicinanzaGarantita());

            // Calcola prezzo
            double prezzoTotale = acquistoFacade.calcolaAnteprimaPrezzo(
                    idProgrammazione,
                    numeroBiglietti
            );

            // Passa dati alla JSP
            request.setAttribute("programmazione", programmazione);
            request.setAttribute("numeroBiglietti", numeroBiglietti);
            request.setAttribute("prezzoTotale", prezzoTotale);
            request.setAttribute("saldoDisponibile", utente.getSaldo());
            request.setAttribute("scadenzaCheckout",
                    LocalDateTime.now().plusMinutes(DURATA_PRENOTAZIONE_MINUTI));
            request.setAttribute("postiAssegnati", postiAssegnati);

            request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errore", "Parametri non validi");
            request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errore", "Errore database: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errore", "Errore imprevisto: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Verifica autenticazione
        Utente utente = (Utente) session.getAttribute("utente");
        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int idProgrammazione = Integer.parseInt(request.getParameter("idProgrammazione"));
            int numeroBiglietti = Integer.parseInt(request.getParameter("numeroBiglietti"));
            String usaSaldoParam = request.getParameter("usaSaldo");
            boolean usaSaldo = "true".equals(usaSaldoParam);

            // ⏱️ VERIFICA TIMEOUT
            LocalDateTime scadenza = (LocalDateTime) session.getAttribute("scadenzaCheckout");

            if (scadenza == null || LocalDateTime.now().isAfter(scadenza)) {
                // TEMPO SCADUTO → Libera i posti
                @SuppressWarnings("unchecked")
                List<Posto> postiOccupati = (List<Posto>) session.getAttribute("postiOccupati");

                if (postiOccupati != null && !postiOccupati.isEmpty()) {
                    postoService.liberaPostiDaCheckout(postiOccupati);
                }

                // Pulisci sessione
                session.removeAttribute("postiOccupati");
                session.removeAttribute("scadenzaCheckout");
                session.removeAttribute("idProgrammazioneCheckout");
                session.removeAttribute("vicinanzaGarantita");

                request.setAttribute("errore",
                        "Il tempo per completare l'acquisto è scaduto. I posti sono stati liberati. Riprova.");
                request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
                return;
            }

            // RECUPERA POSTI DALLA SESSIONE
            @SuppressWarnings("unchecked")
            List<Posto> postiPrenotati = (List<Posto>) session.getAttribute("postiOccupati");

            if (postiPrenotati == null || postiPrenotati.isEmpty()) {
                request.setAttribute("errore", "Nessun posto prenotato. Riprova dall'inizio.");
                request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
                return;
            }

            // ✅ ELABORA ACQUISTO (i posti sono già OCCUPATO)
            RisultatoAcquisto risultato = acquistoFacade.elaboraAcquisto(
                    utente,
                    idProgrammazione,
                    numeroBiglietti,
                    usaSaldo,
                    postiPrenotati  // Passa i posti dalla sessione
            );

            if (risultato.isSuccesso()) {
                // ✅ ACQUISTO COMPLETATO
                // I posti restano OCCUPATO (definitivo)

                // Pulisci sessione
                session.removeAttribute("postiOccupati");
                session.removeAttribute("scadenzaCheckout");
                session.removeAttribute("idProgrammazioneCheckout");
                session.removeAttribute("vicinanzaGarantita");

                // Aggiorna utente in sessione (saldo cambiato)
                try {
                    Connection connection = (Connection) getServletContext().getAttribute("dbConnection");
                    UtenteDAO utenteDAO = new UtenteDAO(connection);
                    Utente utenteAggiornato = utenteDAO.doRetrieveById(utente.getIdAccount());

                    if (utenteAggiornato != null) {
                        session.setAttribute("utente", utenteAggiornato);
                    }

                } catch (SQLException e) {
                    System.err.println("Errore aggiornamento utente in sessione: " + e.getMessage());
                }

                // Passa risultato alla pagina riepilogo
                request.setAttribute("risultato", risultato);
                request.getRequestDispatcher("/WEB-INF/views/riepilogo-acquisto.jsp")
                        .forward(request, response);

            } else {
                // ❌ ACQUISTO FALLITO → Libera i posti
                postoService.liberaPostiDaCheckout(postiPrenotati);

                // Pulisci sessione
                session.removeAttribute("postiOccupati");
                session.removeAttribute("scadenzaCheckout");
                session.removeAttribute("idProgrammazioneCheckout");
                session.removeAttribute("vicinanzaGarantita");

                request.setAttribute("errore", risultato.getMessaggioFinale());
                request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            // Libera posti in caso di errore
            liberaPostiInCasoDiErrore(session);

            request.setAttribute("errore", "Parametri non validi");
            request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);

        } catch (SQLException e) {
            // Libera posti in caso di errore
            liberaPostiInCasoDiErrore(session);

            request.setAttribute("errore", "Errore database: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);

        } catch (IllegalStateException e) {
            // Libera posti in caso di errore
            liberaPostiInCasoDiErrore(session);

            request.setAttribute("errore", "Errore durante l'acquisto: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);

        } catch (Exception e) {
            // Libera posti in caso di errore
            liberaPostiInCasoDiErrore(session);

            request.setAttribute("errore", "Errore imprevisto: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
        }
    }

    /**
     * METODO HELPER: Libera i posti in caso di errore
     */
    private void liberaPostiInCasoDiErrore(HttpSession session) {
        @SuppressWarnings("unchecked")
        List<Posto> postiOccupati = (List<Posto>) session.getAttribute("postiOccupati");

        if (postiOccupati != null && !postiOccupati.isEmpty()) {
            try {
                postoService.liberaPostiDaCheckout(postiOccupati);
            } catch (Exception ex) {
                System.err.println("Errore durante la liberazione posti: " + ex.getMessage());
            }
        }

        // Pulisci sessione
        session.removeAttribute("postiOccupati");
        session.removeAttribute("scadenzaCheckout");
        session.removeAttribute("idProgrammazioneCheckout");
        session.removeAttribute("vicinanzaGarantita");
    }
}