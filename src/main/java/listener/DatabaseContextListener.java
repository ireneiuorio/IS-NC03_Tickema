package listener;


import it.unisa.tickema.model.DBManager;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * DATABASE CONTEXT LISTENER
 *
 * Inizializza la connessione al database usando DBManager
 * quando l'applicazione parte.
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
            System.out.println("✅ Connessione al database stabilita tramite DBManager");

            // Salva la connessione nel context
            context.setAttribute("dbConnection", connection);
            System.out.println("✅ Connessione salvata nel ServletContext");

        } catch (SQLException e) {
            System.err.println("❌ ERRORE: Impossibile connettersi al database!");
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
                System.out.println("✅ Connessione al database chiusa");
            } catch (SQLException e) {
                System.err.println("❌ Errore durante la chiusura della connessione");
                e.printStackTrace();
            }
        }
    }
}
