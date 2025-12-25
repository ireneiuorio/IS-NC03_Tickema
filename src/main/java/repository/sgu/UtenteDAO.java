package repository.sgu;

import entity.sgu.Utente;

import java.sql.*;

public class UtenteDAO {

    private Connection connection;

    public UtenteDAO(Connection connection) {
        this.connection = connection;
    }

    /**
     * SALVA NUOVO UTENTE
     */
    public boolean doSave(Utente utente) throws SQLException {
        String sql = "INSERT INTO utente (nome, cognome, numeroDiTelefono, password, email, saldo, tipoAccount) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, utente.getNome());
            stmt.setString(2, utente.getCognome());
            stmt.setString(3, utente.getNumeroDiTelefono());
            stmt.setString(4, utente.getPassword());
            stmt.setString(5, utente.getEmail());
            stmt.setDouble(6, 0.0); // Saldo iniziale a 0
            stmt.setString(7, utente.getTipoAccount());

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        utente.setIdAccount(rs.getInt(1));
                    }
                }
            }

            return rowsAffected > 0;
        }
    }

    /**
     * TROVA UTENTE PER ID
     */
    public Utente doRetrieveById(int id) throws SQLException {
        String sql = "SELECT * FROM utente WHERE idAccount = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractUtenteFromResultSet(rs);
                }
            }
        }

        return null;
    }

    /**
     * TROVA UTENTE PER EMAIL
     */
    public Utente doRetrieveByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM utente WHERE email = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractUtenteFromResultSet(rs);
                }
            }
        }

        return null;
    }

    /**
     * MODIFICA PROFILO UTENTE
     */
    public boolean doUpdateProfilo(int idAccount, String nome, String cognome, String numeroTelefono)
            throws SQLException {
        String sql = "UPDATE utente SET nome = ?, cognome = ?, numeroDiTelefono = ? WHERE idAccount = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, nome);
            stmt.setString(2, cognome);
            stmt.setString(3, numeroTelefono);
            stmt.setInt(4, idAccount);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * MODIFICA CREDENZIALI (email e password)
     */
    public boolean doUpdateCredenziali(int idAccount, String email, String passwordHashata)
            throws SQLException {
        String sql = "UPDATE utente SET email = ?, password = ? WHERE idAccount = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, passwordHashata);
            stmt.setInt(3, idAccount);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * AGGIORNA SALDO UTENTE
     */
    public boolean doUpdateSaldo(int idAccount, double nuovoSaldo) throws SQLException {
        String sql = "UPDATE utente SET saldo = ? WHERE idAccount = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDouble(1, nuovoSaldo);
            stmt.setInt(2, idAccount);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * ELIMINA ACCOUNT
     */
    public boolean doDelete(int idAccount) throws SQLException {
        String sql = "DELETE FROM utente WHERE idAccount = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, idAccount);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * VERIFICA SE EMAIL ESISTE GIÀ
     */
    public boolean esisteEmail(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM utente WHERE email = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }

        return false;
    }

    /**
     * ESTRAE UTENTE DA RESULTSET
     */
    private Utente extractUtenteFromResultSet(ResultSet rs) throws SQLException {
        Utente utente = new Utente(
                rs.getInt("idAccount"),
                rs.getString("nome"),
                rs.getString("cognome"),
                rs.getString("numeroDiTelefono"),
                rs.getString("password"),
                rs.getString("email"),
                rs.getString("tipoAccount")
        );

        utente.setSaldo(rs.getDouble("saldo"));

        return utente;
    }
}