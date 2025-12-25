package repository.sgp;

import entity.sgc.Film;
import entity.spg.Programmazione;
import entity.spg.Sala;
import entity.spg.SlotOrari;
import entity.spg.Tariffa;
import repository.sgc.FilmDAO;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ProgrammazioneDAO {
    private Connection connection;

    private FilmDAO filmDAO;
    private SalaDAO salaDAO;
    private SlotOrariDAO slotOrariDAO;
    private TariffaDAO tariffaDAO;


    public ProgrammazioneDAO(Connection connection) {
        this.connection = connection;
        this.filmDAO = new FilmDAO(connection);
        this.salaDAO = new SalaDAO(connection);
        this.slotOrariDAO = new SlotOrariDAO(connection);
        this.tariffaDAO = new TariffaDAO(connection);
    }

    public Programmazione doSave(Programmazione p) throws SQLException {
        String sql = "INSERT INTO programmazione (dataProgrammazione, tipo, prezzoBase, stato, " +
                "idFilm, idSala, idSlotOrario, idTariffa) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(
                sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setDate(1, Date.valueOf(p.getDataProgrammazione()));
            ps.setString(2, p.getTipo());
            ps.setBigDecimal(3, p.getPrezzoBase());
            ps.setString(4, p.getStato());
            ps.setInt(5, p.getIdFilm());
            ps.setInt(6, p.getIdSala());
            ps.setInt(7, p.getIdSlotOrario());

            if (p.getIdTariffa() != null) {
                ps.setInt(8, p.getIdTariffa());
            } else {
                ps.setNull(8, Types.INTEGER);
            }

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    p.setIdProgrammazione(rs.getInt(1));
                }
            }
        }
        return p;
    }




    public Programmazione doRetrieveByKey(int id) throws SQLException {
        String sql = "SELECT * FROM programmazione WHERE idProgrammazione = ?";

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

    //Recupera una programmazione con tutti gli oggetti caricati
    public Programmazione doRetrieveByKeyWithRelations(int id) throws SQLException {
        Programmazione prog = doRetrieveByKey(id);

        if (prog != null) {
            caricaOggettiCorrelati(prog);
        }

        return prog;
    }

    //Recupera le programmazioni di un film nello specifico e li ordina per data e ora
    public List<Programmazione> doRetrieveAllByFilm(int idFilm) throws SQLException {
        String sql = "SELECT p.* FROM programmazione p " +
                "JOIN SLOTORARI s ON p.idSlotOrario = s.idSlot " +
                "WHERE p.idFilm = ? " +
                "ORDER BY p.dataProgrammazione, s.oraInizio";

        List<Programmazione> result = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idFilm);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(popolaOggetto(rs));
                }
            }
        }
        return result;
    }

    public List<Programmazione> doRetrieveByData(LocalDate data) throws SQLException {
        String sql = "SELECT p.* FROM programmazione p " +
                "JOIN SLOTORARI s ON p.idSlotOrario = s.idSlot " +
                "WHERE p.dataProgrammazione = ? " +
                "ORDER BY s.oraInizio, p.idSala";

        List<Programmazione> result = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(data));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(popolaOggetto(rs));
                }
            }
        }
        return result;
    }

    //Recupera le programmazioni di una sala in una specifica data
    public List<Programmazione> doRetrieveBySalaAndData(int idSala, LocalDate data)
            throws SQLException {
        String sql = "SELECT p.* FROM programmazione p " +
                "JOIN SLOTORARI s ON p.idSlotOrario = s.idSlot " +
                "WHERE p.idSala = ? AND p.dataProgrammazione = ? " +
                "ORDER BY s.oraInizio";

        List<Programmazione> result = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idSala);
            ps.setDate(2, Date.valueOf(data));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(popolaOggetto(rs));
                }
            }
        }
        return result;
    }

    //Recupera quelle programmazioni che non sono annullate o concluse
    public List<Programmazione> doRetrieveDisponibili() throws SQLException {
        String sql = "SELECT p.* FROM programmazione p " +
                "JOIN SLOTORARI s ON p.idSlotOrario = s.idSlot " +
                "WHERE p.stato = 'DISPONIBILE' " +
                "ORDER BY p.dataProgrammazione, s.oraInizio";

        List<Programmazione> result = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.add(popolaOggetto(rs));
            }
        }
        return result;
    }



    public boolean doUpdate(Programmazione p) throws SQLException {
        String sql = "UPDATE programmazione SET dataProgrammazione = ?, tipo = ?, " +
                "prezzoBase = ?, stato = ?, idFilm = ?, idSala = ?, " +
                "idSlotOrario = ?, idTariffa = ? " +
                "WHERE idProgrammazione = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(p.getDataProgrammazione()));
            ps.setString(2, p.getTipo());
            ps.setBigDecimal(3, p.getPrezzoBase());
            ps.setString(4, p.getStato());
            ps.setInt(5, p.getIdFilm());
            ps.setInt(6, p.getIdSala());
            ps.setInt(7, p.getIdSlotOrario());

            if (p.getIdTariffa() != null) {
                ps.setInt(8, p.getIdTariffa());
            } else {
                ps.setNull(8, Types.INTEGER);
            }

            ps.setInt(9, p.getIdProgrammazione());

            return ps.executeUpdate() > 0;
        }
    }

    //Aggiorna lo stato di una programmazione
    public boolean doUpdateStato(int idProgrammazione, String nuovoStato)
            throws SQLException {
        String sql = "UPDATE programmazione SET stato = ? WHERE idProgrammazione = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, nuovoStato);
            ps.setInt(2, idProgrammazione);

            return ps.executeUpdate() > 0;
        }
    }

    public boolean doDelete(int id) throws SQLException {
        String sql = "UPDATE programmazione SET stato = 'ANNULLATA' " +
                "WHERE idProgrammazione = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    //Verifica se esistono biglietti venduti per una certa programmazione
    public boolean doCheckBigliettiVenduti(int idProgrammazione) throws SQLException {
        String sql = "SELECT COUNT(*) FROM biglietto " +
                "WHERE idProgrammazione = ? AND stato != 'RIMBORSATO'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idProgrammazione);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    //Verifica se esiste una programmazione per uno slot e per una sala --> controllo multisala
    public boolean existsBySlotAndSala(int idSlotOrario, int idSala) throws SQLException {
        String sql = "SELECT COUNT(*) FROM programmazione " +
                "WHERE idSlotOrario = ? AND idSala = ? AND stato != 'ANNULLATA'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idSlotOrario);
            ps.setInt(2, idSala);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }


    //Verifica se uno slot è occupato (in modo indipendente dalla sala)
    public boolean doCheckBySlot(int idSlotOrario) throws SQLException {
        String sql = "SELECT COUNT(*) FROM programmazione " +
                "WHERE idSlotOrario = ? AND stato != 'ANNULLATA'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idSlotOrario);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    //Verifica disponibilità slot/sala escludendo una programmazione specifica. --> da usare in fase di modifica per non contare la programmazione stessa
    public boolean existsBySlotAndSalaExcluding(
            int idSlotOrario, int idSala, int idProgrammazioneEsclusa) throws SQLException {

        String sql = "SELECT COUNT(*) FROM programmazione " +
                "WHERE idSlotOrario = ? AND idSala = ? " +
                "AND stato != 'ANNULLATA' AND idProgrammazione != ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idSlotOrario);
            ps.setInt(2, idSala);
            ps.setInt(3, idProgrammazioneEsclusa);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    private Programmazione popolaOggetto(ResultSet rs) throws SQLException {
        Programmazione p = new Programmazione();
        p.setIdProgrammazione(rs.getInt("idProgrammazione"));

        Date d = rs.getDate("dataProgrammazione");
        if (d != null) {
            p.setDataProgrammazione(d.toLocalDate());
        }

        p.setTipo(rs.getString("tipo"));
        p.setPrezzoBase(rs.getBigDecimal("prezzoBase"));
        p.setStato(rs.getString("stato"));
        p.setIdFilm(rs.getInt("idFilm"));
        p.setIdSala(rs.getInt("idSala"));
        p.setIdSlotOrario(rs.getInt("idSlotOrario"));

        int idTariffa = rs.getInt("idTariffa");
        if (!rs.wasNull()) {
            p.setIdTariffa(idTariffa);
        }

        return p;
    }

    private void caricaOggettiCorrelati(Programmazione programmazione)
            throws SQLException {

        // Carica Film
        Film film = filmDAO.doRetrieveByKey(programmazione.getIdFilm());
        programmazione.setFilm(film);

        // Carica Sala
        Sala sala = salaDAO.doRetrieveByKey(programmazione.getIdSala());
        programmazione.setSala(sala);

        // Carica SlotOrari
        SlotOrari slot = slotOrariDAO.doRetrieveByKey(programmazione.getIdSlotOrario());
        programmazione.setSlotOrario(slot);

        // Carica Tariffa (se presente)
        if (programmazione.getIdTariffa() != null) {
            Tariffa tariffa = tariffaDAO.doRetrieveByKey(programmazione.getIdTariffa());
            programmazione.setTariffa(tariffa);
        }
    }
}
