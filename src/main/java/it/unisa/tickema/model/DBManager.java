package it.unisa.tickema.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.io.InputStream;
import java.io.IOException;

public class DBManager {
    private static Connection conn = null;

    public static Connection getConnection() throws SQLException {
        if (conn == null || conn.isClosed()) {
            try (InputStream input = DBManager.class.getClassLoader().getResourceAsStream("db.properties")) {
                Properties prop = new Properties();

                if (input == null) {
                    throw new RuntimeException("Impossibile trovare db.properties in resources");
                }

                prop.load(input);

                // Carica il driver (Maven lo ha scaricato per te grazie al pom.xml)
                Class.forName(prop.getProperty("db.driver"));

                // Crea la connessione usando i dati del file properties
                conn = DriverManager.getConnection(
                        prop.getProperty("db.url"),
                        prop.getProperty("db.user"),
                        prop.getProperty("db.password")
                );
            } catch (IOException | ClassNotFoundException e) {
                e.printStackTrace();
                throw new SQLException("Errore di configurazione del Database.");
            }
        }
        return conn;
    }
}