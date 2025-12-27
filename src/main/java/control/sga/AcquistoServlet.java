package control.sga;

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
import service.sga.AcquistoFacade;


import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/acquisto")
public class AcquistoServlet extends HttpServlet {

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

            int postiDisponibili = postoService.contaPostiDisponibili(idProgrammazione);

            if (postiDisponibili < numeroBiglietti) {
                request.setAttribute("errore",
                        "Posti insufficienti. Disponibili: " + postiDisponibili +
                                ", Richiesti: " + numeroBiglietti);
                request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
                return;
            }

            double prezzoTotale = acquistoFacade.calcolaAnteprimaPrezzo(
                    idProgrammazione,
                    numeroBiglietti
            );

            request.setAttribute("programmazione", programmazione);
            request.setAttribute("numeroBiglietti", numeroBiglietti);
            request.setAttribute("prezzoTotale", prezzoTotale);
            request.setAttribute("saldoDisponibile", utente.getSaldo());

            request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errore", "Parametri non validi");
            request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errore", "Errore database: " + e.getMessage());
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

            // CHIAMA LA FACADE per elaborare l'acquisto
            RisultatoAcquisto risultato = acquistoFacade.elaboraAcquisto(
                    utente,
                    idProgrammazione,
                    numeroBiglietti,
                    usaSaldo
            );

            if (risultato.isSuccesso()) {
                // Acquisto completato con successo!

                // AGGIORNA UTENTE IN SESSIONE (il saldo è cambiato!)
                try {
                    Connection connection = (Connection) getServletContext().getAttribute("dbConnection");
                    UtenteDAO utenteDAO = new UtenteDAO(connection);

                    Utente utenteAggiornato = utenteDAO.doRetrieveById(utente.getIdAccount());

                    if (utenteAggiornato != null) {
                        session.setAttribute("utente", utenteAggiornato);
                    }

                } catch (SQLException e) {
                    // Log errore ma non bloccare il flusso
                    System.err.println("Errore aggiornamento utente in sessione: " + e.getMessage());
                }

                // Passa risultato alla pagina riepilogo
                request.setAttribute("risultato", risultato);
                request.getRequestDispatcher("/WEB-INF/views/riepilogo-acquisto.jsp")
                        .forward(request, response);

            } else {
                // Acquisto fallito
                request.setAttribute("errore", risultato.getMessaggioFinale());
                request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errore", "Parametri non validi");
            request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("errore", "Errore database: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);

        } catch (IllegalStateException e) {
            request.setAttribute("errore", "Errore durante l'acquisto: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
        }
    }
}