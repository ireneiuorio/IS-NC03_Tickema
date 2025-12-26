package repository.sgp;

import entity.sgp.Sala;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SalaDAO {
    private Connection connection;

    public SalaDAO(Connection connection) {
        this.connection = connection;
    }

    public Sala doSave(Sala sala) throws SQLException {
        String sql = "INSERT INTO sala (nome, numeroDiFile, capienza, numeroPostiPerFila) " +
                "VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(
                sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, sala.getNome());
            ps.setInt(2, sala.getNumeroDiFile());
            ps.setInt(3, sala.getCapienza());
            ps.setInt(4, sala.getNumeroPostiPerFila());

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    sala.setIdSala(rs.getInt(1));
                }
            }
        }
        return sala;
    }

    public Sala doRetrieveByKey(int id) throws SQLException {
        String sql = "SELECT * FROM sala WHERE idSala = ?";

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

    public List<Sala> doRetrieveAll() throws SQLException {
        String sql = "SELECT * FROM sala ORDER BY nome";
        List<Sala> result = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.add(popolaOggetto(rs));
            }
        }
        return result;
    }

    public Sala doRetrieveByNome(String nome) throws SQLException {
        String sql = "SELECT * FROM sala WHERE nome = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, nome);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return popolaOggetto(rs);
                }
            }
        }
        return null;
    }

    //Verifica l'esistenza di una sala utilizzando il nome di quella sala
    public boolean doCheckByNome(String nome) throws SQLException {
        String sql = "SELECT COUNT(*) FROM sala WHERE nome = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, nome);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public boolean doUpdate(Sala sala) throws SQLException {
        String sql = "UPDATE sala SET nome = ?, numeroDiFile = ?, capienza = ?, " +
                "numeroPostiPerFila = ? WHERE idSala = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, sala.getNome());
            ps.setInt(2, sala.getNumeroDiFile());
            ps.setInt(3, sala.getCapienza());
            ps.setInt(4, sala.getNumeroPostiPerFila());
            ps.setInt(5, sala.getIdSala());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean doDelete(int idSala) throws SQLException {
        String sql = "DELETE FROM sala WHERE idSala = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idSala);
            return ps.executeUpdate() > 0;
        }
    }

    private Sala popolaOggetto(ResultSet rs) throws SQLException {
        Sala s = new Sala();
        s.setIdSala(rs.getInt("idSala"));
        s.setNome(rs.getString("nome"));
        s.setConfigurazione(
                rs.getInt("numeroDiFile"),
                rs.getInt("numeroPostiPerFila")
        );
        return s;
    }

}
