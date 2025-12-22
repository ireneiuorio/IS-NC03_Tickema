package repository.sgp;

import entity.spg.Tariffa;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TariffaDAO {
    private Connection connection;

    public TariffaDAO(Connection connection) {
        this.connection = connection;
    }

    public Tariffa doSave(Tariffa tariffa) throws SQLException {
        String sql = "INSERT INTO Tariffa (tipo, nome, percentualeSconto) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, tariffa.getTipo());
            ps.setString(2, tariffa.getNome());
            ps.setBigDecimal(3, tariffa.getPercentualeSconto());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) tariffa.setIdTariffa(rs.getInt(1));
            }
        }
        return tariffa;
    }

    public Tariffa doRetrieveByKey(int id) throws SQLException {
        String sql = "SELECT * FROM Tariffa WHERE idTariffa = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return popolaOggetto(rs);
            }
        }
        return null;
    }

    public List<Tariffa> doRetrieveAll() throws SQLException {
        String sql = "SELECT * FROM Tariffa ORDER BY tipo, nome";
        List<Tariffa> result = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.add(popolaOggetto(rs));
            }
        }
        return result;
    }

    public boolean doUpdate(Tariffa tariffa) throws SQLException {
        String sql = "UPDATE Tariffa SET tipo = ?, nome = ?, percentualeSconto = ? WHERE idTariffa = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, tariffa.getTipo());
            ps.setString(2, tariffa.getNome());
            ps.setBigDecimal(3, tariffa.getPercentualeSconto());
            ps.setInt(4, tariffa.getIdTariffa());
            return ps.executeUpdate() > 0;
        }
    }

    private Tariffa popolaOggetto(ResultSet rs) throws SQLException {
        Tariffa t = new Tariffa();
        t.setIdTariffa(rs.getInt("idTariffa"));
        try {
            t.setTipo(rs.getString("tipo"));
            t.setNome(rs.getString("nome"));
            t.setPercentualeSconto(rs.getBigDecimal("percentualeSconto"));
        } catch (IllegalArgumentException e) {
            throw new SQLException("Dati tariffa non validi nel database: " + e.getMessage());
        }
        return t;
    }
}
