package control.sga;


import entity.sga.Biglietto;
import entity.sgu.Utente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.sga.ValidazioneService;
import service.sga.BigliettoService;
import exception.sga.acquisto.biglietto.BigliettoNonTrovatoException;
import exception.sga.validazione.StatoBigliettoNonValidoException;
import exception.sga.validazione.DataValidazioneNonValidaException;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/personale/valida-biglietto")
public class ValidazioneBigliettoServlet extends HttpServlet {

    private ValidazioneService validazioneService;
    private BigliettoService bigliettoService;

    @Override
    public void init() throws ServletException {
        Connection connection = (Connection) getServletContext().getAttribute("dbConnection");
        this.validazioneService = new ValidazioneService(connection);
        this.bigliettoService = new BigliettoService(connection);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===== VERIFICA AUTENTICAZIONE =====
        if (!verificaAccessoPersonale(request, response)) {
            return;
        }

        // Mostra pagina di scansione QR
        request.getRequestDispatcher("/WEB-INF/views/personale/valida-biglietto.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===== VERIFICA AUTENTICAZIONE =====
        if (!verificaAccessoPersonale(request, response)) {
            return;
        }

        HttpSession session = request.getSession();
        Utente personale = (Utente) session.getAttribute("utenteLoggato");

        try {
            String qrCode = request.getParameter("qrCode");

            if (qrCode == null || qrCode.trim().isEmpty()) {
                request.setAttribute("errore", "QR Code non valido");
                request.getRequestDispatcher("/WEB-INF/views/personale/valida-biglietto.jsp")
                        .forward(request, response);
                return;
            }

            // ===== VALIDA BIGLIETTO =====
            boolean validato = validazioneService.validaBiglietto(
                    qrCode.trim(),
                    personale.getIdAccount()
            );

            if (validato) {
                // Recupera biglietto validato per mostrare i dettagli
                Biglietto biglietto = bigliettoService.getBigliettoByQRCode(qrCode.trim());


                if (biglietto.getDataUtilizzo() != null) {
                    String dataUtilizzoFormattata = biglietto.getDataUtilizzo()
                            .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
                    request.setAttribute("dataUtilizzoFormattata", dataUtilizzoFormattata);
                }

                request.setAttribute("successo", "Biglietto validato con successo!");
                request.setAttribute("biglietto", biglietto);
                request.getRequestDispatcher("/WEB-INF/views/personale/valida-biglietto.jsp")
                        .forward(request, response);
            }



        } catch (BigliettoNonTrovatoException e) {
            request.setAttribute("errore", "Biglietto non trovato");
            request.getRequestDispatcher("/WEB-INF/views/personale/valida-biglietto.jsp")
                    .forward(request, response);

        } catch (StatoBigliettoNonValidoException e) {
            request.setAttribute("warning", e.getMessage());
            try {
                Biglietto biglietto = bigliettoService.getBigliettoByQRCode(request.getParameter("qrCode").trim());
                request.setAttribute("biglietto", biglietto);
            } catch (Exception ex) {
                // Ignora
            }
            request.getRequestDispatcher("/WEB-INF/views/personale/valida-biglietto.jsp")
                    .forward(request, response);

        } catch (DataValidazioneNonValidaException e) {
            request.setAttribute("errore", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/personale/valida-biglietto.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errore", "Errore: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/personale/valida-biglietto.jsp")
                    .forward(request, response);
        }
    }

    /**
     * Verifica che l'utente sia autenticato come Personale
     */
    private boolean verificaAccessoPersonale(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/utente/login");
            return false;
        }

        Utente utente = (Utente) session.getAttribute("utenteLoggato");

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/utente/login");
            return false;
        }

        if (!"Personale".equalsIgnoreCase(utente.getTipoAccount())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Accesso negato: permessi personale richiesti");
            return false;
        }

        return true;
    }
}