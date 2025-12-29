package control.sgc;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet unica per gestire tutte le pagine informative statiche
 */
@WebServlet({
        "/chi-siamo",
        "/contatti",
        "/privacy",
        "/termini"
})
public class InfoPagesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        String jspPage;

        switch (path) {
            case "/chi-siamo":
                jspPage = "/WEB-INF/views/informazioni/chi-siamo.jsp";
                break;

            case "/contatti":
                jspPage = "/WEB-INF/views/informazioni/contatti.jsp";
                break;

            case "/privacy":
                jspPage = "/WEB-INF/views/informazioni/privacy.jsp";
                break;

            case "/termini":
                jspPage = "/WEB-INF/views/informazioni/termini.jsp";
                break;

            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
        }

        request.getRequestDispatcher(jspPage).forward(request, response);
    }
}