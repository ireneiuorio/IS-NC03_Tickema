package control.sgu;

import entity.sgu.Utente;
import exception.sgu.autenticazione.CredenzialiNonValideException;
import exception.sgu.autenticazione.EmailGiaRegistrataException;
import exception.sgu.autenticazione.PasswordDiverseException;
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

    @Override
    public void init() throws ServletException {
        Connection connection = (Connection) getServletContext().getAttribute("dbConnection");
        this.autenticazioneService = new AutenticazioneService(connection);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String path = request.getPathInfo();
        HttpSession session = request.getSession(false);
        Utente utente = (session != null) ? (Utente) session.getAttribute("utenteLoggato") : null;

        // Se path è null, redirect alla home
        if (path == null || path.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        switch (path) {
            case "/login":
                request.getRequestDispatcher("/WEB-INF/views/account/login.jsp")
                        .forward(request, response);
                break;

            case "/logout":
                eseguiLogout(request, response);
                break;

            case "/registrazione":
                request.getRequestDispatcher("/WEB-INF/views/account/registrazione.jsp")
                        .forward(request, response);
                break;

            case "/mostra-profilo":
                mostraProfilo(request, response);
                break;

            case "/modifica-credenziali":
                if (utente == null) {
                    response.sendRedirect(request.getContextPath() + "/utente/login");
                    return;
                }

                // Passa l'utente alla JSP per pre-compilare i campi
                request.setAttribute("utente", utente);
                request.getRequestDispatcher("/WEB-INF/views/account/modifica-credenziali.jsp")
                        .forward(request, response);
                break;

            case "/modifica-profilo":
                if (utente == null) {
                    response.sendRedirect(request.getContextPath() + "/utente/login");
                    return;
                }

                // Passa l'utente alla JSP per pre-compilare i campi
                request.setAttribute("utente", utente);
                request.getRequestDispatcher("/WEB-INF/views/account/modifica-profilo.jsp")
                        .forward(request, response);
                break;

            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String path = request.getPathInfo();

        if (path == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (path) {
            case "/login":
                eseguiLogin(request, response);
                break;

            case "/registrazione":
                eseguiRegistrazione(request, response);
                break;

            case "/modifica-profilo":
                eseguiModificaProfilo(request, response);
                break;

            case "/modifica-credenziali":
                eseguiModificaCredenziali(request, response);
                break;

            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    /**
     * Mostra la pagina del profilo utente
     */
    private void mostraProfilo(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        Utente utente = (session != null) ? (Utente) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/utente/login");
            return;
        }

        // Passa l'utente alla JSP
        request.setAttribute("utente", utente);
        request.getRequestDispatcher("/WEB-INF/views/account/profilo-utente.jsp")
                .forward(request, response);
    }

    /**
     * Gestisce il processo di login
     */
    private void eseguiLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Utente utente = autenticazioneService.login(email, password);

            if (utente != null) {
                // Salva l'utente in sessione
                HttpSession session = request.getSession();
                session.setAttribute("utenteLoggato", utente);

                // Redirect alla home
                response.sendRedirect(request.getContextPath() + "/");
            }

        } catch (CredenzialiNonValideException e) {
            request.setAttribute("errore", "Credenziali non valide");
            request.getRequestDispatcher("/WEB-INF/views/account/login.jsp")
                    .forward(request, response);

        } catch (SQLException | NoSuchAlgorithmException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore del server. Riprova più tardi.");
        }
    }

    /**
     * Gestisce il processo di registrazione
     */
    private void eseguiRegistrazione(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confermaPassword = request.getParameter("confermaPassword");
        String telefono = request.getParameter("telefono");

        try {
            Utente nuovoUtente = autenticazioneService.registraUtente(
                    nome, cognome, email, password, confermaPassword, telefono
            );

            if (nuovoUtente != null) {
                // Registrazione riuscita - login automatico
                HttpSession session = request.getSession();
                session.setAttribute("utenteLoggato", nuovoUtente);

                // Redirect alla home
                response.sendRedirect(request.getContextPath() + "/");
            } else {
                request.setAttribute("errore", "Registrazione fallita. Riprova.");
                request.getRequestDispatcher("/WEB-INF/views/account/registrazione.jsp")
                        .forward(request, response);
            }

        } catch (EmailGiaRegistrataException e) {
            request.setAttribute("errore", "Email già registrata");
            request.getRequestDispatcher("/WEB-INF/views/account/registrazione.jsp")
                    .forward(request, response);

        } catch (PasswordDiverseException e) {
            request.setAttribute("errore", "Le password non corrispondono");
            request.getRequestDispatcher("/WEB-INF/views/account/registrazione.jsp")
                    .forward(request, response);

        } catch (SQLException | NoSuchAlgorithmException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore del server. Riprova più tardi.");
        }
    }

    /**
     * Gestisce il logout
     */
    private void eseguiLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);

        if (session != null) {
            Utente utente = (Utente) session.getAttribute("utenteLoggato");
            if (utente != null) {
                autenticazioneService.logout(utente.getIdAccount());
            }
            session.invalidate();
        }

        // Redirect alla pagina di login
        response.sendRedirect(request.getContextPath() + "/utente/login");
    }

    /**
     * Gestisce la modifica del profilo
     */
    private void eseguiModificaProfilo(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        Utente utente = (session != null) ? (Utente) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/utente/login");
            return;
        }

        try {
            String nome = request.getParameter("nome");
            String cognome = request.getParameter("cognome");
            String numeroDiTelefono = request.getParameter("numeroDiTelefono");

            boolean successo = autenticazioneService.modificaProfilo(
                    utente.getIdAccount(), nome, cognome, numeroDiTelefono
            );

            if (successo) {
                // Aggiorna l'oggetto in sessione
                utente.setNome(nome);
                utente.setCognome(cognome);
                utente.setNumeroDiTelefono(numeroDiTelefono);

                // Redirect al profilo con messaggio di successo
                response.sendRedirect(request.getContextPath() + "/utente/mostra-profilo?update=success");
            } else {
                request.setAttribute("errore", "Impossibile aggiornare il profilo.");
                request.setAttribute("utente", utente);
                request.getRequestDispatcher("/WEB-INF/views/account/modifica-profilo.jsp")
                        .forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore del server. Riprova più tardi.");
        }
    }

    private void eseguiModificaCredenziali(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        Utente utente = (session != null) ? (Utente) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/utente/login");
            return;
        }

        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confermaPassword = request.getParameter("confermaPassword");

            boolean successo = autenticazioneService.modificaCredenziali(
                    utente.getIdAccount(), email, password, confermaPassword);

            if(successo) {
                // Aggiorna l'oggetto in sessione
                utente.setEmail(email);

                // Redirect al profilo con messaggio di successo
                response.sendRedirect(request.getContextPath() + "/utente/mostra-profilo?update=success");
            } else {
                request.setAttribute("errore", "Impossibile aggiornare le credenziali.");
                request.setAttribute("utente", utente);
                request.getRequestDispatcher("/WEB-INF/views/account/modifica-credenziali.jsp")
                        .forward(request, response);
            }

        } catch (PasswordDiverseException e) {
            request.setAttribute("errore", "Le password non corrispondono");
            request.getRequestDispatcher("/WEB-INF/views/account/modifica-credenziali.jsp")
                    .forward(request, response);
        } catch (SQLException | NoSuchAlgorithmException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore del server. Riprova più tardi.");
        }

    }
}