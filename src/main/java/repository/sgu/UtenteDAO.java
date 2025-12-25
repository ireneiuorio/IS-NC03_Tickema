package repository.sgu;

import entity.sgu.Utente;
import it.unisa.tickema.model.DBManager;

import java.sql.*;

public class UtenteDAO {

    //metodo utilizzato per andare a creare un account nuovo nel database, quindi aggiungerlo con tutti i suoi attributi
    public boolean doSave(Utente utente) throws SQLException{
        String sql = "INSERT INTO utente (nome, cognome, numeroDiTelefono, password, email, tipoAccount)" +
                "VALUES (?,?,?,?,?,?)";

        try (Connection conn = DBManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, utente.getNome());
            stmt.setString(2, utente.getCognome());
            stmt.setString(3, utente.getNumeroDiTelefono());
            stmt.setString(4, utente.getPassword());
            stmt.setString(5, utente.getEmail());
            stmt.setString(6, utente.getTipoAccount());

            int rowsAffected = stmt.executeUpdate();


            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        utente.setIdAccount(rs.getInt(1)); //dato che il db assegna un id automatico ai nuovi account trovati, lo ricaviamo e lo andiamo a settare effettivamente come id dell'utente
                    }
                }
            }
            return rowsAffected > 0;

        }
    }

    //metodo per trovare un utente tramite il suo id
    public Utente findUtenteById(int id) throws SQLException{
        String sql = "SELECT * FROM utente WHERE idAccount=?";
        try (Connection conn = DBManager.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractUtenteFromResultSet(rs); //con questo metodo noi possiamo andarci a prendere un utente con tutti i suoi attributi
                }
            }

        }
        return null;
    }

    //metodo per trovare un utente tramite la sua email
    public Utente findUtenteByEmail(String email) throws SQLException{
        String sql = "SELECT * FROM utente WHERE email=?";
        try (Connection conn = DBManager.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractUtenteFromResultSet(rs);
                }
            }
        }
        return null;
    }


    public boolean modificaProfilo(int idAccount, String nome, String cognome, String numeroTelefono) throws SQLException{
        String sql = "UPDATE utente SET nome = ?, cognome = ?, numeroDiTelefono = ? WHERE idAccount=?";
        try (Connection conn = DBManager.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nome);
            stmt.setString(2, cognome);
            stmt.setString(3, numeroTelefono);
            stmt.setInt(4, idAccount);

            return stmt.executeUpdate() > 0;
        }
    }

    //questo metodo modifica solo le credenziali, quindi email e password
    //gestisce solo la logica del db, tutti i controlli sulla vecchia password ed email già esistente vengono fatti nel service
    public boolean modificaCredenzialiProfilo(int idAccount, String email, String passwordHashata) throws SQLException{
        String sql = "UPDATE utente SET email = ?, password = ? WHERE idAccount=?";

        try (Connection conn = DBManager.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, passwordHashata);
            stmt.setInt(3, idAccount);

            return stmt.executeUpdate() > 0;
        }
    }

    //questo metodo è generale, poi nei service verranno differenziati i metodi eliminaAccount per l'utente e cancellaUtente per l'admin
    //ma sempre chiamando questo metodo qui, perchè fanno la stessa cosa, hanno solo un flusso di eventi diverso prima di eliminare
    public boolean deleteAccount(int idAccount) throws SQLException{
        String sql = "DELETE FROM utente WHERE idAccount=?";
        try (Connection conn = DBManager.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAccount);
            return stmt.executeUpdate() > 0;
        }
    }

    //questo metodo ci aiuta per vedere se un'email è già registrata nel sistema, in modo tale che in caso di esito positivo
    //blocca la registrazione di quell'utente per email già esistente
    public boolean esisteEmail(String email) throws SQLException{
        String sql = "SELECT COUNT(*) FROM utente WHERE email=?";
        try (Connection conn = DBManager.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; //se ritorna true allora l'email esiste già nel db, e quindi non si può registrare l'utente
                }
            }
        }
        return false; //vuol dire che non c'è l'email nel db, e quindi non risulta ad un'email già registrata. Di conseguenza l'utente può registrarsi
    }

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

        utente.setSaldo(rs.getBigDecimal("saldo"));
        return utente;
    }

}
