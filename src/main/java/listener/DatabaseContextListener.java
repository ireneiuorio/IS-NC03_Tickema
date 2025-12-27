package listener;

import it.unisa.tickema.model.DBManager;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * DATABASE CONTEXT LISTENER
 *
 * Inizializza la connessione al database usando DBManager
 * quando l'applicazione parte.
 *
 * Esegue anche cleanup dei posti orfani (OCCUPATO senza biglietto).
 */
@WebListener
public class DatabaseContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=== Inizializzazione Database ===");

        ServletContext context = sce.getServletContext();

        try {
            // Ottiene la connessione tramite DBManager
            Connection connection = DBManager.getConnection();
            System.out.println("Connessione al database stabilita tramite DBManager");

            // Salva la connessione nel context
            context.setAttribute("dbConnection", connection);
            System.out.println("Connessione salvata nel ServletContext");

            //CLEANUP POSTI ORFANI
            // Libera posti OCCUPATO ma senza biglietti associati
            // (Rimasti bloccati da sessioni scadute/crash del server)
            cleanupPostiOrfani(connection);

        } catch (SQLException e) {
            System.err.println("ERRORE: Impossibile connettersi al database!");
            System.err.println("   Verifica il file db.properties in src/main/resources/");
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=== Chiusura Database ===");

        ServletContext context = sce.getServletContext();
        Connection connection = (Connection) context.getAttribute("dbConnection");

        if (connection != null) {
            try {
                connection.close();
                System.out.println("Connessione al database chiusa");
            } catch (SQLException e) {
                System.err.println("Errore durante la chiusura della connessione");
                e.printStackTrace();
            }
        }
    }

    /**
     * CLEANUP POSTI ORFANI
     *
     * Libera posti che sono in stato OCCUPATO ma non hanno un biglietto associato.
     * Questi posti sono rimasti bloccati da:
     * - Sessioni scadute durante il checkout
     * - Crash del server durante una transazione
     * - Errori nella servlet che non hanno liberato i posti
     */
    private void cleanupPostiOrfani(Connection connection) {
        System.out.println("🧹 Avvio cleanup posti orfani...");

        try (Statement stmt = connection.createStatement()) {

            // Query per liberare posti OCCUPATO senza biglietti
            String cleanup =
                    "UPDATE POSTO p " +
                            "SET p.stato = 'DISPONIBILE' " +
                            "WHERE p.stato = 'OCCUPATO' " +
                            "AND NOT EXISTS (" +
                            "    SELECT 1 FROM BIGLIETTO b " +
                            "    WHERE b.idPosto = p.idPosto" +
                            ")";

            int postiLiberati = stmt.executeUpdate(cleanup);

            if (postiLiberati > 0) {
                System.out.println(" Liberati " + postiLiberati + " posti orfani all'avvio");
            } else {
                System.out.println("Nessun posto orfano da liberare");
            }

        } catch (SQLException e) {
            System.err.println("Errore durante cleanup posti orfani: " + e.getMessage());
            // Non bloccare l'avvio dell'applicazione per questo errore
            e.printStackTrace();
        }
    }
}