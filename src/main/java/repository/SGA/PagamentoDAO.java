package repository.SGA;

import entity.SGA.Acquisto;
import entity.SGA.Pagamento;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PagamentoDAO {
    private Connection connection;

    public PagamentoDAO(Connection connection) {
        this.connection = connection;
    }

    //Inserisce un nuovo pagamento
    public boolean doSave(Pagamento pagamento) throws SQLException {
        String query = "INSERT INTO PAGAMENTO (metodoPagamento, importo, dataOraPagamento, tipo, idAcquisto) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, pagamento.getMetodoPagamento());
            ps.setDouble(2, pagamento.getImporto());
            ps.setTimestamp(3, Timestamp.valueOf(pagamento.getDataOraPagamento()));
            ps.setString(4, pagamento.getTipo());
            ps.setInt(5, pagamento.getAcquisto().getIdAcquisto());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        pagamento.setIdPagamento(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        }
    }

    // Recupera un pagamento per ID
    public Pagamento doRetrieveById(int idPagamento) throws SQLException {
        String query = "SELECT * FROM PAGAMENTO WHERE idPagamento = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idPagamento);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractPagamentoFromResultSet(rs);
                }
            }
        }
        return null;
    }

    // Recupera tutti i pagamenti di un acquisto
    public List<Pagamento> doRetrieveByAcquisto(int idAcquisto) throws SQLException {
        List<Pagamento> pagamenti = new ArrayList<>();
        String query = "SELECT * FROM PAGAMENTO WHERE idAcquisto = ? ORDER BY dataOraPagamento";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idAcquisto);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    pagamenti.add(extractPagamentoFromResultSet(rs));
                }
            }
        }
        return pagamenti;
    }

    //Recupera tutti i pagamenti
    public List<Pagamento> doRetrieveAll() throws SQLException {
        List<Pagamento> pagamenti = new ArrayList<>();
        String query = "SELECT * FROM PAGAMENTO ORDER BY dataOraPagamento DESC";

        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                pagamenti.add(extractPagamentoFromResultSet(rs));
            }
        }
        return pagamenti;
    }

    // Recupera pagamenti per tipo
    public List<Pagamento> doRetrieveByTipo(String tipo) throws SQLException {
        List<Pagamento> pagamenti = new ArrayList<>();
        String query = "SELECT * FROM PAGAMENTO WHERE tipo = ? ORDER BY dataOraPagamento DESC";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, tipo);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    pagamenti.add(extractPagamentoFromResultSet(rs));
                }
            }
        }
        return pagamenti;
    }

    // Recupera pagamenti per metodo
    public List<Pagamento> doRetrieveByMetodo(String metodoPagamento) throws SQLException {
        List<Pagamento> pagamenti = new ArrayList<>();
        String query = "SELECT * FROM PAGAMENTO WHERE metodoPagamento LIKE ? ORDER BY dataOraPagamento DESC";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, "%" + metodoPagamento + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    pagamenti.add(extractPagamentoFromResultSet(rs));
                }
            }
        }
        return pagamenti;
    }

    //Recupera pagamenti per range di date
    public List<Pagamento> doRetrieveByDataRange(LocalDateTime dataInizio, LocalDateTime dataFine) throws SQLException {
        List<Pagamento> pagamenti = new ArrayList<>();
        String query = "SELECT * FROM PAGAMENTO WHERE dataOraPagamento BETWEEN ? AND ? ORDER BY dataOraPagamento DESC";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setTimestamp(1, Timestamp.valueOf(dataInizio));
            ps.setTimestamp(2, Timestamp.valueOf(dataFine));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    pagamenti.add(extractPagamentoFromResultSet(rs));
                }
            }
        }
        return pagamenti;
    }

    //Aggiorna un pagamento completo
    public boolean doUpdate(Pagamento pagamento) throws SQLException {
        String query = "UPDATE PAGAMENTO SET metodoPagamento = ?, importo = ?, dataOraPagamento = ?, tipo = ?, idAcquisto = ? WHERE idPagamento = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, pagamento.getMetodoPagamento());
            ps.setDouble(2, pagamento.getImporto());
            ps.setTimestamp(3, Timestamp.valueOf(pagamento.getDataOraPagamento()));
            ps.setString(4, pagamento.getTipo());
            ps.setInt(5, pagamento.getAcquisto().getIdAcquisto());
            ps.setInt(6, pagamento.getIdPagamento());

            return ps.executeUpdate() > 0;
        }
    }

    // Elimina un pagamento
    public boolean doDelete(int idPagamento) throws SQLException {
        String query = "DELETE FROM PAGAMENTO WHERE idPagamento = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idPagamento);
            return ps.executeUpdate() > 0;
        }
    }

    //  Estrae oggetto Pagamento da ResultSet
    private Pagamento extractPagamentoFromResultSet(ResultSet rs) throws SQLException {
        Pagamento pagamento = new Pagamento();
        pagamento.setIdPagamento(rs.getInt("idPagamento"));
        pagamento.setMetodoPagamento(rs.getString("metodoPagamento"));
        pagamento.setImporto(rs.getDouble("importo"));
        pagamento.setDataOraPagamento(rs.getTimestamp("dataOraPagamento").toLocalDateTime());
        pagamento.setTipo(rs.getString("tipo"));

        // Crea un oggetto Acquisto di base con solo l'ID
        Acquisto acquisto = new Acquisto();
        acquisto.setIdAcquisto(rs.getInt("idAcquisto"));
        pagamento.setAcquisto(acquisto);

        return pagamento;
    }

    // Verifica se un acquisto è stato pagato completamente
    public boolean isAcquistoFullyPaid(int idAcquisto) throws SQLException {
        String query = "SELECT a.importoTotale, COALESCE(SUM(p.importo), 0) as totalePagato " +
                "FROM ACQUISTO a " +
                "LEFT JOIN PAGAMENTO p ON a.idAcquisto = p.idAcquisto " +
                "WHERE a.idAcquisto = ? " +
                "GROUP BY a.importoTotale";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idAcquisto);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double importoTotale = rs.getDouble("importoTotale");
                    double totalePagato = rs.getDouble("totalePagato");
                    return totalePagato >= importoTotale;
                }
            }
        }
        return false;
    }

    // Calcola totale pagato per un acquisto
    public double doCalcolaTotalePagato(int idAcquisto) throws SQLException {
        String query = "SELECT COALESCE(SUM(importo), 0) as totale FROM PAGAMENTO WHERE idAcquisto = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idAcquisto);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("totale");
                }
            }
        }
        return 0.0;
    }

    //Calcola importo rimanente da pagare
    public double doCalcolaImportoRimanente(int idAcquisto) throws SQLException {
        String query = "SELECT a.importoTotale - COALESCE(SUM(p.importo), 0) as rimanente " +
                "FROM ACQUISTO a " +
                "LEFT JOIN PAGAMENTO p ON a.idAcquisto = p.idAcquisto " +
                "WHERE a.idAcquisto = ? " +
                "GROUP BY a.importoTotale";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, idAcquisto);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("rimanente");
                }
            }
        }
        return 0.0;
    }




}