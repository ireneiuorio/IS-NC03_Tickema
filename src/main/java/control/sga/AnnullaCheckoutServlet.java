package control.sga;


import entity.sgp.Posto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.sgp.PostoService;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

/**
 * SERVLET per annullare il checkout e liberare i posti
 * Chiamata via AJAX quando:
 * - Il timer scade (5 minuti)
 * - L'utente chiude la pagina (beforeunload)
 * - L'utente clicca "Annulla"
 */
@WebServlet("/annulla-checkout")
public class AnnullaCheckoutServlet extends HttpServlet {

    private PostoService postoService;

    @Override
    public void init() throws ServletException {
        Connection connection = (Connection) getServletContext()
                .getAttribute("dbConnection");
        this.postoService = new PostoService(connection);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Imposta risposta JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false); // Non creare nuova sessione

        if (session == null) {
            // Nessuna sessione attiva
            response.getWriter().write("{\"success\": true, \"message\": \"Nessuna sessione attiva\"}");
            return;
        }

        try {
            // Recupera posti dalla sessione
            @SuppressWarnings("unchecked")
            List<Posto> postiOccupati = (List<Posto>) session.getAttribute("postiOccupati");

            if (postiOccupati != null && !postiOccupati.isEmpty()) {
                // LIBERA I POSTI
                postoService.liberaPostiDaCheckout(postiOccupati);

                // Pulisci sessione
                session.removeAttribute("postiOccupati");
                session.removeAttribute("scadenzaCheckout");
                session.removeAttribute("idProgrammazioneCheckout");
                session.removeAttribute("vicinanzaGarantita");

                System.out.println("Liberati " + postiOccupati.size() + " posti dal checkout");

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(
                        "{\"success\": true, \"message\": \"Posti liberati: " +
                                postiOccupati.size() + "\"}"
                );

            } else {
                // Nessun posto da liberare
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(
                        "{\"success\": true, \"message\": \"Nessun posto da liberare\"}"
                );
            }

        } catch (Exception e) {
            System.err.println("Errore liberazione posti: " + e.getMessage());
            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(
                    "{\"success\": false, \"message\": \"" +
                            e.getMessage().replace("\"", "'") + "\"}"
            );
        }
    }
}