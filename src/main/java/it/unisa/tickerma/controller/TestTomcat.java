package it.unisa.tickerma.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/test")
public class TestTomcat extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<h1>Tomcat 11 funziona correttamente!</h1>");
        out.println("<p>Versione Java: " + System.getProperty("java.version") + "</p>");
        out.println("<p>Se vedi questo, il tuo progetto Maven è configurato bene.</p>");
        out.println("</body></html>");
    }
}