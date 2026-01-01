package control.sgu;

import entity.sga.Acquisto;
import entity.sgu.Utente;
import exception.sga.acquisto.AcquistoNonValidoException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.sga.AcquistoService;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/admin/gestione-acquisti")
public class AdminAcquistiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verifica autenticazione admin
        HttpSession session = request.getSession(false);
        Utente utente = (session != null) ? (Utente) session.getAttribute("utenteLoggato") : null;

        if (utente == null || !"Admin".equalsIgnoreCase(utente.getTipoAccount())) {
            response.sendRedirect(request.getContextPath() + "/utente/login");
            return;
        }

        try {
            Connection connection = (Connection) getServletContext().getAttribute("dbConnection");
            AcquistoService acquistoService = new AcquistoService(connection);

            // Parametri per filtri
            String statoFiltro = request.getParameter("stato");

            List<Acquisto> acquisti;

            if (statoFiltro != null && !statoFiltro.isEmpty()) {
                // Filtra per stato
                acquisti = acquistoService.getAcquistiPerStato(statoFiltro);
            } else {
                // Tutti gli acquisti
                acquisti = acquistoService.getAllAcquisti();
            }

            // Statistiche
            int totaleAcquisti = acquistoService.contaTotaleAcquisti();
            int totaleCompletati = acquistoService.contaAcquistiPerStato("Completato");
            int totaleRimborsati = acquistoService.contaAcquistiPerStato("Rimborsato");
            double importoTotale = acquistoService.calcolaImportoTotaleAcquisti();

            request.setAttribute("acquisti", acquisti);
            request.setAttribute("totaleAcquisti", totaleAcquisti);
            request.setAttribute("totaleCompletati", totaleCompletati);
            request.setAttribute("totaleRimborsati", totaleRimborsati);
            request.setAttribute("importoTotale", importoTotale);
            request.setAttribute("statoFiltro", statoFiltro);

            request.getRequestDispatcher("/WEB-INF/views/admin/acquisti/lista.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore nel recupero degli acquisti");
        } catch (AcquistoNonValidoException e) {
            throw new RuntimeException(e);
        }
    }
}