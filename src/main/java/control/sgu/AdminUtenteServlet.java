package control.sgu;


import entity.sgu.Utente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.sgu.UtenteService;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/utenti")
public class AdminUtenteServlet extends HttpServlet {

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
            UtenteService utenteService = new UtenteService(connection);

            // Parametri per filtri e ricerca
            String tipoAccount = request.getParameter("tipo");
            String searchQuery = request.getParameter("search");

            List<Utente> utenti;

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                // Ricerca utenti
                utenti = utenteService.cercaUtenti(searchQuery.trim());
            } else if (tipoAccount != null && !tipoAccount.isEmpty()) {
                // Filtra per tipo account
                utenti = utenteService.getUtentiPerTipo(tipoAccount);
            } else {
                // Tutti gli utenti
                utenti = utenteService.getAllUtenti();
            }

            // Statistiche
            // Statistiche
            int totaleUtenti = utenteService.contaTotaleUtenti();
            int totaleUtente = utenteService.contaUtentiPerTipo("Utente");
            int totalePersonale = utenteService.contaUtentiPerTipo("Personale");
            int totaleAdmin = utenteService.contaUtentiPerTipo("Admin");

            request.setAttribute("utenti", utenti);
            request.setAttribute("totaleUtenti", totaleUtenti);
            request.setAttribute("totaleUtente", totaleUtente);
            request.setAttribute("totalePersonale", totalePersonale);
            request.setAttribute("totaleAdmin", totaleAdmin);

            request.getRequestDispatcher("/WEB-INF/views/admin/utenti/lista.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore nel recupero degli utenti");
        }
    }
}