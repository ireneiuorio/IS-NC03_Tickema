package filter;


import entity.sgu.Utente;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);

        // Verifica se l'utente è loggato
        if (session == null || session.getAttribute("utenteLoggato") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/utente/login");
            return;
        }

        Utente utente = (Utente) session.getAttribute("utenteLoggato");

        // Verifica se è admin
        if (!"Admin".equalsIgnoreCase(utente.getTipoAccount())) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Accesso negato: permessi amministratore richiesti");
            return;
        }

        // Utente autorizzato, continua
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inizializzazione del filtro (opzionale)
    }

    @Override
    public void destroy() {
        // Pulizia risorse (opzionale)
    }
}