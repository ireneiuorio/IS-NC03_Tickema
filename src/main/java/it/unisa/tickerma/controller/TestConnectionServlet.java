package it.unisa.tickerma.controller;

import it.unisa.tickema.model.DBManager;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/check-db")
public class TestConnectionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (Connection c = DBManager.getConnection()) {
            if (c != null) {
                response.getWriter().println("GRANDE! Connessione al database riuscita.");
            }
        } catch (Exception e) {
            response.getWriter().println("ERRORE: " + e.getMessage());
            e.printStackTrace(response.getWriter());
        }
    }
}