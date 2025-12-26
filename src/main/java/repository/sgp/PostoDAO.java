package repository.sgp;

import entity.sgp.Posto;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostoDAO {
    private Connection connection;

    public PostoDAO(Connection connection) {
        this.connection = connection;
    }

    public Posto doSave(Posto posto) throws SQLException {
        String sql = "INSERT INTO posto (stato, fila, numeroPosto, idProgrammazione, idSala) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(
                sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, posto.getStato());
            ps.setInt(2, posto.getFila());
            ps.setInt(3, posto.getNumeroPosto());
            ps.setInt(4, posto.getIdProgrammazione());
            ps.setInt(5, posto.getIdSala());

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    posto.setIdPosto(rs.getInt(1));
                }
            }
        }
        return posto;
    }

    public void doSaveBatch(List<Posto> posti) throws SQLException {
        String sql = "INSERT INTO posto (stato, fila, numeroPosto, idProgrammazione, idSala) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (Posto p : posti) {
                ps.setString(1, p.getStato());
                ps.setInt(2, p.getFila());
                ps.setInt(3, p.getNumeroPosto());
                ps.setInt(4, p.getIdProgrammazione());
                ps.setInt(5, p.getIdSala());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    public Posto doRetrieveByKey(int id) throws SQLException {
        String sql = "SELECT * FROM posto WHERE idPosto = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return popolaOggetto(rs);
                }
            }
        }
        return null;
    }

    public List<Posto> doRetrieveBySala(int idSala) throws SQLException {
        String sql = "SELECT * FROM posto WHERE idSala = ? ORDER BY fila, numeroPosto";

        List<Posto> result = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idSala);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(popolaOggetto(rs));
                }
            }
        }
        return result;
    }

    public List<Posto> doRetrieveBySalaAndProgrammazione(int idSala, int idProgrammazione)
            throws SQLException {
        String sql = "SELECT * FROM posto " +
                "WHERE idSala = ? AND idProgrammazione = ? " +
                "ORDER BY fila, numeroPosto";

        List<Posto> result = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idSala);
            ps.setInt(2, idProgrammazione);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(popolaOggetto(rs));
                }
            }
        }
        return result;
    }

    public List<Posto> doRetrieveDisponibili(int idProgrammazione) throws SQLException {
        String sql = "SELECT * FROM posto " +
                "WHERE idProgrammazione = ? AND stato = 'DISPONIBILE' " +
                "ORDER BY fila, numeroPosto";

        List<Posto> result = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idProgrammazione);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(popolaOggetto(rs));
                }
            }
        }
        return result;
    }

    public int doCountDisponibili(int idProgrammazione) throws SQLException {
        String sql = "SELECT COUNT(*) FROM posto " +
                "WHERE idProgrammazione = ? AND stato = 'DISPONIBILE'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idProgrammazione);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }


    public boolean deleteBySala(int idSala) throws SQLException {
        String sql = "DELETE FROM posto WHERE idSala = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idSala);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean doUpdate(Posto posto) throws SQLException {
        String sql = "UPDATE posto SET stato = ?, fila = ?, numeroPosto = ?, " +
                "idProgrammazione = ?, idSala = ? WHERE idPosto = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, posto.getStato());
            ps.setInt(2, posto.getFila());
            ps.setInt(3, posto.getNumeroPosto());
            ps.setInt(4, posto.getIdProgrammazione());
            ps.setInt(5, posto.getIdSala());
            ps.setInt(6, posto.getIdPosto());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean doUpdateStato(int idPosto, String nuovoStato) throws SQLException {
        String sql = "UPDATE posto SET stato = ? WHERE idPosto = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, nuovoStato);
            ps.setInt(2, idPosto);

            return ps.executeUpdate() > 0;
        }
    }

    public int doUpdateStatoBatch(List<Integer> idPosti, String nuovoStato)
            throws SQLException {
        String sql = "UPDATE posto SET stato = ? WHERE idPosto = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (Integer idPosto : idPosti) {
                ps.setString(1, nuovoStato);
                ps.setInt(2, idPosto);
                ps.addBatch();
            }

            int[] results = ps.executeBatch();
            int count = 0;
            for (int result : results) {
                if (result > 0) count++;
            }
            return count;
        }
    }

    public boolean doDelete(int idPosto) throws SQLException {
        String sql = "DELETE FROM posto WHERE idPosto = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idPosto);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean doDeleteBySala(int idSala) throws SQLException {
        String sql = "DELETE FROM posto WHERE idSala = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idSala);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean doDeleteByProgrammazione(int idProgrammazione) throws SQLException {
        String sql = "DELETE FROM posto WHERE idProgrammazione = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idProgrammazione);
            return ps.executeUpdate() > 0;
        }
    }

    private Posto popolaOggetto(ResultSet rs) throws SQLException {
        Posto p = new Posto();
        p.setIdPosto(rs.getInt("idPosto"));
        p.setFila(rs.getInt("fila"));
        p.setNumeroPosto(rs.getInt("numeroPosto"));
        p.setStato(rs.getString("stato"));
        p.setIdSala(rs.getInt("idSala"));
        p.setIdProgrammazione(rs.getInt("idProgrammazione"));
        return p;
    }
}
