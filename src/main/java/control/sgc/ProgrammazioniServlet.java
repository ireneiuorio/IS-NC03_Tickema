package control.sgc;

import entity.sgp.Programmazione;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.sgp.ProgrammazioneService;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * PROGRAMMAZIONI SERVLET
 * Mostra tutte le programmazioni disponibili
 */
@WebServlet("/programmazioni")
public class ProgrammazioniServlet extends HttpServlet {

    private ProgrammazioneService programmazioneService;

    @Override
    public void init() throws ServletException {
        Connection connection = (Connection) getServletContext().getAttribute("dbConnection");
        this.programmazioneService = new ProgrammazioneService(connection);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            System.out.println("=== PROGRAMMAZIONI SERVLET ===");

            // ===== RECUPERA TUTTE LE PROGRAMMAZIONI DISPONIBILI =====
            List<Programmazione> programmazioni = getAllProgrammazioniDisponibili();

            System.out.println("Programmazioni disponibili: " + programmazioni.size());

            // ===== ORDINA PER DATA E ORA =====
            programmazioni.sort((p1, p2) -> {
                int compareData = p1.getDataProgrammazione().compareTo(p2.getDataProgrammazione());
                if (compareData != 0) {
                    return compareData;
                }
                if (p1.getSlotOrari() != null && p2.getSlotOrari() != null) {
                    return p1.getSlotOrari().getOraInizio().compareTo(p2.getSlotOrari().getOraInizio());
                }
                return 0;
            });

            // ===== PASSA DATI ALLA JSP =====
            request.setAttribute("programmazioni", programmazioni);

            System.out.println("Forward a programmazioni.jsp");

            // Forward alla JSP
            request.getRequestDispatcher("/WEB-INF/views/catalogo/programmazioni.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Errore imprevisto: " + e.getMessage());
            e.printStackTrace();

            request.setAttribute("errore", "Errore nel caricamento delle programmazioni");
            request.getRequestDispatcher("/WEB-INF/views/errore.jsp").forward(request, response);
        }
    }

    /**
     * Recupera tutte le programmazioni disponibili con relazioni caricate
     */
    private List<Programmazione> getAllProgrammazioniDisponibili() {
        List<Programmazione> tutte = new ArrayList<>();

        // Recupera programmazioni per ogni film (così carica le relazioni)
        for (int idFilm = 1; idFilm <= 20; idFilm++) {
            try {
                List<Programmazione> progFilm = programmazioneService.visualizzaProgrammazioniFilm(idFilm);

                // Filtra solo quelle disponibili
                for (Programmazione prog : progFilm) {
                    if ("Disponibile".equals(prog.getStato())) {
                        tutte.add(prog);
                    }
                }
            } catch (Exception e) {
                // Salta il film se non ha programmazioni
                System.out.println("Nessuna programmazione per film " + idFilm);
            }
        }

        return tutte;
    }
}