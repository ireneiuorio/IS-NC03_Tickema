package repository.SGA;

import entity.SGA.Biglietto;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class BigliettoDAO {
    private Connection connection;

    public BigliettoDAO(Connection connection) {
        this.connection = connection;
    }

    // Inserisce un nuovo biglietto
    public boolean doSave(Biglietto biglietto) throws SQLException {
        String query = "INSERT INTO BIGLIETTO (prezzoFinale, stato, QRCode, dataUtilizzo, idAcquisto, idProgrammazione, idPosto, idPersonaleValidazione) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setDouble(1, biglietto.getPrezzoFinale());
            ps.setString(2, biglietto.getStato());
            ps.setString(3, biglietto.getQRCode());

            if (biglietto.getDataUtilizzo() != null) {
                ps.setTimestamp(4, Timestamp.valueOf(biglietto.getDataUtilizzo()));
            } else {
                ps.setNull(4, Types.TIMESTAMP);
            }

            ps.setInt(5, biglietto.getAcquisto().getIdAcquisto());
            ps.setInt(6, biglietto.getProgrammazione().getIdProgrammazione());
            ps.setInt(7, biglietto.getPosto().getIdPosto());

            if (biglietto.getPersonaleValidazione() != null) {
                ps.setInt(8, biglietto.getPersonaleValidazione().getIdAccount());
            } else {
                ps.setNull(8, Types.INTEGER);
            }

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        biglietto.setIdBiglietto(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        }
    }

    //Recupera un biglietto per ID
    public Biglietto doRetrieveById(int idBiglietto) throws SQLException {
        String query = "SELECT * FROM BIGLIETTO WHERE idBiglietto = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idBiglietto);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractBigliettoFromResultSet(rs);
                }
            }
        }
        return null;
    }

    //Recupera biglietto tramite QRCode (per validazione)
    public Biglietto doRetrieveByQRCode(String qrCode) throws SQLException {
        String query = "SELECT * FROM BIGLIETTO WHERE QRCode = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, qrCode);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractBigliettoFromResultSet(rs);
                }
            }
        }
        return null;
    }

    //Recupera tutti i biglietti di un acquisto
    public List<Biglietto> doRetrieveByAcquisto(int idAcquisto) throws SQLException {
        List<Biglietto> biglietti = new ArrayList<>();
        String query = "SELECT * FROM BIGLIETTO WHERE idAcquisto = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idAcquisto);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    biglietti.add(extractBigliettoFromResultSet(rs));
                }
            }
        }
        return biglietti;
    }

    //Recupera tutti i biglietti di una programmazione
    public List<Biglietto> doRetrieveByProgrammazione(int idProgrammazione) throws SQLException {
        List<Biglietto> biglietti = new ArrayList<>();
        String query = "SELECT * FROM BIGLIETTO WHERE idProgrammazione = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idProgrammazione);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    biglietti.add(extractBigliettoFromResultSet(rs));
                }
            }
        }
        return biglietti;
    }

    //Recupera biglietti per stato
    public List<Biglietto> doRetrieveByStato(String stato) throws SQLException {
        List<Biglietto> biglietti = new ArrayList<>();
        String query = "SELECT * FROM BIGLIETTO WHERE stato = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, stato);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    biglietti.add(extractBigliettoFromResultSet(rs));
                }
            }
        }
        return biglietti;
    }

    //Recupera tutti i biglietti
    public List<Biglietto> doRetrieveAll() throws SQLException {
        List<Biglietto> biglietti = new ArrayList<>();
        String query = "SELECT * FROM BIGLIETTO";

        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                biglietti.add(extractBigliettoFromResultSet(rs));
            }
        }
        return biglietti;
    }

    //Valida un biglietto (cambia stato e registra validazione)
    public boolean doValidate(int idBiglietto, int idPersonale) throws SQLException {
        String query = "UPDATE BIGLIETTO SET stato = 'Validato', dataUtilizzo = ?, idPersonaleValidazione = ? WHERE idBiglietto = ? AND stato = 'Emesso'";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, idPersonale);
            ps.setInt(3, idBiglietto);

            return ps.executeUpdate() > 0;
        }
    }

    //Valida biglietto tramite QRCode
    public boolean doValidateByQRCode(String qrCode, int idPersonale) throws SQLException {
        String query = "UPDATE BIGLIETTO SET stato = 'Validato', dataUtilizzo = ?, idPersonaleValidazione = ? WHERE QRCode = ? AND stato = 'Emesso'";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, idPersonale);
            ps.setString(3, qrCode);

            return ps.executeUpdate() > 0;
        }
    }

    // Aggiorna lo stato di un biglietto
    public boolean doUpdateStato(int idBiglietto, String nuovoStato) throws SQLException {
        String query = "UPDATE BIGLIETTO SET stato = ? WHERE idBiglietto = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, nuovoStato);
            ps.setInt(2, idBiglietto);

            return ps.executeUpdate() > 0;
        }
    }

    // Aggiorna un biglietto completo
    public boolean doUpdate(Biglietto biglietto) throws SQLException {
        String query = "UPDATE BIGLIETTO SET prezzoFinale = ?, stato = ?, QRCode = ?, dataUtilizzo = ?, idAcquisto = ?, idProgrammazione = ?, idPosto = ?, idPersonaleValidazione = ? WHERE idBiglietto = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setDouble(1, biglietto.getPrezzoFinale());
            ps.setString(2, biglietto.getStato());
            ps.setString(3, biglietto.getQRCode());

            if (biglietto.getDataUtilizzo() != null) {
                ps.setTimestamp(4, Timestamp.valueOf(biglietto.getDataUtilizzo()));
            } else {
                ps.setNull(4, Types.TIMESTAMP);
            }

            ps.setInt(5, biglietto.getAcquisto().getIdAcquisto());
            ps.setInt(6, biglietto.getProgrammazione().getIdProgrammazione());
            ps.setInt(7, biglietto.getPosto().getIdPosto());

            if (biglietto.getPersonaleValidazione() != null) {
                ps.setInt(8, biglietto.getPersonaleValidazione().getIdAccount());
            } else {
                ps.setNull(8, Types.INTEGER);
            }

            ps.setInt(9, biglietto.getIdBiglietto());

            return ps.executeUpdate() > 0;
        }
    }

    //Elimina un biglietto
    public boolean doDelete(int idBiglietto) throws SQLException {
        String query = "DELETE FROM BIGLIETTO WHERE idBiglietto = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idBiglietto);
            return ps.executeUpdate() > 0;
        }
    }

    //Genera QRCode univoco
    public String generateQRCode() {
        return "QR_TKT_" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    //  Verifica se QRCode esiste già
    public boolean isQRCodeUnique(String qrCode) throws SQLException {
        String query = "SELECT COUNT(*) as count FROM BIGLIETTO WHERE QRCode = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, qrCode);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") == 0;
                }
            }
        }
        return false;
    }

    // Estrae oggetto Biglietto da ResultSet
    private Biglietto extractBigliettoFromResultSet(ResultSet rs) throws SQLException {
        Biglietto biglietto = new Biglietto();
        biglietto.setIdBiglietto(rs.getInt("idBiglietto"));
        biglietto.setPrezzoFinale(rs.getDouble("prezzoFinale"));
        biglietto.setStato(rs.getString("stato"));
        biglietto.setQRCode(rs.getString("QRCode"));

        Timestamp dataUtilizzo = rs.getTimestamp("dataUtilizzo");
        if (dataUtilizzo != null) {
            biglietto.setDataUtilizzo(dataUtilizzo.toLocalDateTime());
        }

        // Crea oggetti di base con solo gli ID
        Acquisto acquisto = new Acquisto();
        acquisto.setIdAcquisto(rs.getInt("idAcquisto"));
        biglietto.setAcquisto(acquisto);

        Programmazione programmazione = new Programmazione();
        programmazione.setIdProgrammazione(rs.getInt("idProgrammazione"));
        biglietto.setProgrammazione(programmazione);

        Posto posto = new Posto();
        posto.setIdPosto(rs.getInt("idPosto"));
        biglietto.setPosto(posto);

        int idPersonale = rs.getInt("idPersonaleValidazione");
        if (!rs.wasNull()) {
            Utente personale = new Utente();
            personale.setIdAccount(idPersonale);
            biglietto.setPersonaleValidazione(personale);
        }

        return biglietto;
    }

    // Conta biglietti venduti per programmazione
    public int doCountBigliettiVenduti(int idProgrammazione) throws SQLException {
        String query = "SELECT COUNT(*) as totale FROM BIGLIETTO WHERE idProgrammazione = ? AND stato IN ('Emesso', 'Validato')";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idProgrammazione);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("totale");
                }
            }
        }
        return 0;
    }

    // Conta biglietti validati per personale
    public int doCountBigliettiValidati(int idPersonale) throws SQLException {
        String query = "SELECT COUNT(*) as totale FROM BIGLIETTO WHERE idPersonaleValidazione = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idPersonale);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("totale");
                }
            }
        }
        return 0;
    }
}