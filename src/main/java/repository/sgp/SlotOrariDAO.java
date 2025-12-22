package repository.sgp;

import entity.spg.SlotOrari;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class SlotOrariDAO {
    private Connection connection;

    public SlotOrariDAO(Connection connection) {
        this.connection = connection;
    }

    //Inserimento del record nella tabella
    public SlotOrari doSave(SlotOrari slot) throws SQLException {
        String sql = "INSERT INTO SlotOrari (oraInizio, oraFine, stato, data) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setTime(1, Time.valueOf(slot.getOraInizio()));
            ps.setTime(2, Time.valueOf(slot.getOraFine()));
            ps.setString(3, slot.getStato());
            ps.setDate(4, Date.valueOf(slot.getData()));
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    slot.setIdSlot(rs.getInt(1));
                }
            }
        }
        return slot;
    }

    //Ricerca lo slot in base alla chiave primaria
    public SlotOrari doRetrieveByKey(int id) throws SQLException {
        String sql = "SELECT * FROM SlotOrari WHERE IdSlot = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return popolaOggetto(rs);
            }
        }
        return null;
    }

    //Ricerca degli slot che possono essere utilizzati per creare una nuova programmazione in una data sala in una data particolare
    public List<SlotOrari> doRetrieveAvailableBySalaAndData(int idSala, LocalDate data) throws SQLException {
        String sql = "SELECT s.* FROM SlotOrari s " +
                "WHERE s.data = ? AND s.stato = 'DISPONIBILE' " +
                "AND s.IdSlot NOT IN (" +
                "    SELECT p.idSlotOrario FROM Programmazione p " +
                "    WHERE p.idSala = ? AND p.stato != 'ANNULLATA'" +
                ") ORDER BY s.oraInizio";
        List<SlotOrari> result = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(data));
            ps.setInt(2, idSala);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(popolaOggetto(rs));
                }
            }
        }
        return result;
    }

    //Ricerca il record mediante id e restituisce true se l'operazione ha successo e quindi viene trovata e modificata una riga
    public boolean doUpdate(SlotOrari slot) throws SQLException {
        String sql = "UPDATE SlotOrari SET oraInizio = ?, oraFine = ?, stato = ?, data = ? WHERE IdSlot = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTime(1, Time.valueOf(slot.getOraInizio()));
            ps.setTime(2, Time.valueOf(slot.getOraFine()));
            ps.setString(3, slot.getStato());
            ps.setDate(4, Date.valueOf(slot.getData()));
            ps.setInt(5, slot.getIdSlot());
            return ps.executeUpdate() > 0;
        }
    }

    //Permette di trasformare una tupla in un oggetto
    private SlotOrari popolaOggetto(ResultSet rs) throws SQLException {
        SlotOrari s = new SlotOrari();
        s.setIdSlot(rs.getInt("IdSlot"));

        Time inizio = rs.getTime("oraInizio");
        if (inizio != null) s.setOraInizio(inizio.toLocalTime());

        Time fine = rs.getTime("oraFine");
        if (fine != null) s.setOraFine(fine.toLocalTime());

        s.setStato(rs.getString("stato"));

        Date d = rs.getDate("data");
        if (d != null) s.setData(d.toLocalDate());

        return s;
    }
}
