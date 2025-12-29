package control.sgu;

import entity.sgu.Utente;
import exception.EmailGiaRegistrataException;
import exception.PasswordErrataException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.sgu.AutenticazioneService;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/utente/*")
public class UtenteServlet extends HttpServlet {

    private AutenticazioneService autenticazioneService;

    public void init() throws ServletException {

        Connection connection = (Connection) getServletContext().getAttribute("dbConnection");
        this.autenticazioneService = new AutenticazioneService(connection);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String path = request.getPathInfo();

        switch (path) {
            case "/login":
                request.getRequestDispatcher(request.getContextPath() + "/WEB-INF/jsp/login.jsp").forward(request, response);
                break;
            case "/logout":
                eseguiLogout(request, response);
                break;
            case "/regsitrazione":
                request.getRequestDispatcher(request.getContextPath() + "/WEB-INF/jsp/registrazione.jsp").forward(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String path = request.getPathInfo();

        switch (path) {
            case "/login":
                eseguiLogin(request, response);
                break;
            case "/registrazione":
                eseguiRegistrazione(request, response);
                break;
        }
    }

    private void eseguiLogin(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {

            Utente utente = autenticazioneService.login(email, password);
            if (utente != null) {
                request.getSession().setAttribute("utenteLoggato", utente);
                response.sendRedirect(request.getContextPath() + "/WEB-INF/jsp/home.jsp");
            }
        } catch(PasswordErrataException e) {
            request.setAttribute("errore", e.getMessage());
            request.getRequestDispatcher(request.getContextPath() + "/WEB-INF/jsp/login.jsp").forward(request, response);
        } catch(SQLException | NoSuchAlgorithmException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void eseguiRegistrazione(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String telefono = request.getParameter("telefono");

        try {
            autenticazioneService.registraUtente(nome, cognome, email, password, telefono);
            response.sendRedirect(request.getContextPath() + "/WEB-INF/jsp/home.jsp");
        } catch(EmailGiaRegistrataException e) {
            request.setAttribute("errore", e.getMessage());
            request.getRequestDispatcher(request.getContextPath() + "/WEB-INF/jsp/registrazione.jsp").forward(request, response);
        } catch(SQLException | NoSuchAlgorithmException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void eseguiLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);

        if (session != null) {
            Utente u = (Utente) session.getAttribute("utenteLoggato");
            if (u != null) {
                autenticazioneService.logout(u.getIdAccount());
            }
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/WEB-INF/jsp/login.jsp");
    }
}
