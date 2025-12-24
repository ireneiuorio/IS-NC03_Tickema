package repository.sga;

import entity.sga.Acquisto;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AcquistoDAO {
    private Connection connection;

    public AcquistoDAO(Connection connection) {
        this.connection = connection;
    }

    //Inserisce un nuovo acquisto
    public boolean doSave(Acquisto acquisto) throws SQLException {
        String query = "INSERT INTO ACQUISTO (importoTotale, dataOraAcquisto, stato, numeroBiglietti, idAccount) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setDouble(1, acquisto.getImportoTotale());
            ps.setTimestamp(2, Timestamp.valueOf(acquisto.getDataOraAcquisto()));
            ps.setString(3, acquisto.getStato());
            ps.setInt(4, acquisto.getNumeroBiglietti());
            ps.setInt(5, acquisto.getUtente().getIdAccount());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        acquisto.setIdAcquisto(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        }
    }

    //Recupera un acquisto per ID
    public Acquisto doRetrieveById(int idAcquisto) throws SQLException {
        String query = "SELECT * FROM ACQUISTO WHERE idAcquisto = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idAcquisto);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractAcquistoFromResultSet(rs);
                }
            }
        }
        return null;
    }

    // Recupera tutti gli acquisti di un utente
    public List<Acquisto> doRetrieveByUtente(int idAccount) throws SQLException {
        List<Acquisto> acquisti = new ArrayList<>();
        String query = "SELECT * FROM ACQUISTO WHERE idAccount = ? ORDER BY dataOraAcquisto DESC";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idAccount);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    acquisti.add(extractAcquistoFromResultSet(rs));
                }
            }
        }
        return acquisti;
    }

    // Recupera tutti gli acquisti
    public List<Acquisto> doRetrieveAll() throws SQLException {
        List<Acquisto> acquisti = new ArrayList<>();
        String query = "SELECT * FROM ACQUISTO ORDER BY dataOraAcquisto DESC";

        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                acquisti.add(extractAcquistoFromResultSet(rs));
            }
        }
        return acquisti;
    }

    //Recupera acquisti per stato
    public List<Acquisto> doRetrieveByStato(String stato) throws SQLException {
        List<Acquisto> acquisti = new ArrayList<>();
        String query = "SELECT * FROM ACQUISTO WHERE stato = ? ORDER BY dataOraAcquisto DESC";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, stato);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    acquisti.add(extractAcquistoFromResultSet(rs));
                }
            }
        }
        return acquisti;
    }

    //Recupera acquisti per data
    public List<Acquisto> doRetrieveByDataRange(LocalDateTime dataInizio, LocalDateTime dataFine) throws SQLException {
        List<Acquisto> acquisti = new ArrayList<>();
        String query = "SELECT * FROM ACQUISTO WHERE dataOraAcquisto BETWEEN ? AND ? ORDER BY dataOraAcquisto DESC";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setTimestamp(1, Timestamp.valueOf(dataInizio));
            ps.setTimestamp(2, Timestamp.valueOf(dataFine));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    acquisti.add(extractAcquistoFromResultSet(rs));
                }
            }
        }
        return acquisti;
    }

    //Aggiorna lo stato di un acquisto
    public boolean doUpdateStato(int idAcquisto, String nuovoStato) throws SQLException {
        String query = "UPDATE ACQUISTO SET stato = ? WHERE idAcquisto = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, nuovoStato);
            ps.setInt(2, idAcquisto);

            return ps.executeUpdate() > 0;
        }
    }

    // Aggiorna un acquisto completo
    public boolean doUpdate(Acquisto acquisto) throws SQLException {
        String query = "UPDATE ACQUISTO SET importoTotale = ?, dataOraAcquisto = ?, stato = ?, numeroBiglietti = ?, idAccount = ? WHERE idAcquisto = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setDouble(1, acquisto.getImportoTotale());
            ps.setTimestamp(2, Timestamp.valueOf(acquisto.getDataOraAcquisto()));
            ps.setString(3, acquisto.getStato());
            ps.setInt(4, acquisto.getNumeroBiglietti());
            ps.setInt(5, acquisto.getUtente().getIdAccount());
            ps.setInt(6, acquisto.getIdAcquisto());

            return ps.executeUpdate() > 0;
        }
    }

    //Elimina un acquisto (CASCADE eliminerà anche biglietti e pagamenti)
    public boolean doDelete(int idAcquisto) throws SQLException {
        String query = "DELETE FROM ACQUISTO WHERE idAcquisto = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idAcquisto);
            return ps.executeUpdate() > 0;
        }
    }

    // Estrae oggetto Acquisto da ResultSet
    private Acquisto extractAcquistoFromResultSet(ResultSet rs) throws SQLException {
        Acquisto acquisto = new Acquisto();
        acquisto.setIdAcquisto(rs.getInt("idAcquisto"));
        acquisto.setImportoTotale(rs.getDouble("importoTotale"));
        acquisto.setDataOraAcquisto(rs.getTimestamp("dataOraAcquisto").toLocalDateTime());
        acquisto.setStato(rs.getString("stato"));
        acquisto.setNumeroBiglietti(rs.getInt("numeroBiglietti"));

        // Crea un oggetto Utente di base con solo l'ID
        Utente utente = new Utente();
        utente.setIdAccount(rs.getInt("idAccount"));
        acquisto.setUtente(utente);

        return acquisto;
    }


    //Conta acquisti per utente
    public int doCountAcquistiByUtente(int idAccount) throws SQLException {
        String query = "SELECT COUNT(*) as totale FROM ACQUISTO WHERE idAccount = ? AND stato = 'Completato'";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idAccount);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("totale");
                }
            }
        }
        return 0;
    }
}