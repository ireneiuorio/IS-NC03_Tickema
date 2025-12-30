package control.sgu;


import entity.sgu.Utente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verifica accesso admin
        if (!verificaAccessoAdmin(request, response)) {
            return;
        }

        // Mostra la dashboard admin
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
                .forward(request, response);
    }

    private boolean verificaAccessoAdmin(HttpServletRequest request, HttpServletResponse response)
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

        if (!"Admin".equalsIgnoreCase(utente.getTipoAccount())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Accesso negato: permessi amministratore richiesti");
            return false;
        }

        return true;
    }
}