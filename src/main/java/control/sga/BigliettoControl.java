package control.sga;


import entity.sga.Biglietto;
import entity.sgu.Utente;
import exception.sga.acquisto.biglietto.BigliettoNonTrovatoException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.sga.BigliettoService;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/biglietto/dettaglio")
public class BigliettoControl extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Utente utente = (session != null) ? (Utente) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/utente/login");
            return;
        }

        try {
            String idBigliettoParam = request.getParameter("id");

            if (idBigliettoParam == null || idBigliettoParam.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID biglietto mancante");
                return;
            }

            int idBiglietto = Integer.parseInt(idBigliettoParam);

            Connection connection = (Connection) getServletContext().getAttribute("dbConnection");
            BigliettoService bigliettoService = new BigliettoService(connection);

            Biglietto biglietto = bigliettoService.getBigliettoById(idBiglietto);

            if (biglietto == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Biglietto non trovato");
                return;
            }

            // Verifica che il biglietto appartenga all'utente loggato
            if (biglietto.getAcquisto().getUtente().getIdAccount() != utente.getIdAccount()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accesso negato");
                return;
            }

            request.setAttribute("biglietto", biglietto);
            request.getRequestDispatcher("/WEB-INF/views/biglietto/dettaglio.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID biglietto non valido");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore nel recupero del biglietto");
        } catch (BigliettoNonTrovatoException e) {
            throw new RuntimeException(e);
        }
    }
}