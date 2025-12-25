package service.sga;

import entity.sga.Acquisto;
import entity.sga.Pagamento;
import exception.pagamento.PagamentoNonValidoException;
import exception.pagamento.SalvataggioPagamentoException;
import repository.sga.PagamentoDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class PagamentoService {

    private Connection connection;
    private PagamentoDAO pagamentoDAO;

    public PagamentoService(Connection connection) {
        this.connection = connection;
        this.pagamentoDAO = new PagamentoDAO(connection);
    }

    /**
     * EFFETTUA PAGAMENTO (SIMULATO - sempre successo)
     */
    public Pagamento effettuaPagamento(
            int idAcquisto,
            String metodoPagamento,
            double importo,
            String tipo
    ) throws PagamentoNonValidoException, SalvataggioPagamentoException, SQLException {

        // Validazioni base
        if (importo <= 0) {
            throw new PagamentoNonValidoException("Importo non valido");
        }

        // Crea pagamento
        Pagamento pagamento = new Pagamento();

        // Crea e associa l'acquisto
        Acquisto acquisto = new Acquisto();
        acquisto.setIdAcquisto(idAcquisto);
        pagamento.setAcquisto(acquisto);

        pagamento.setMetodoPagamento(metodoPagamento);
        pagamento.setImporto(importo);
        pagamento.setTipo(tipo);
        pagamento.setDataOraPagamento(LocalDateTime.now());

        // Salva nel database
        boolean salvato = pagamentoDAO.doSave(pagamento);

        if (!salvato) {
            throw new SalvataggioPagamentoException("Errore nel salvataggio del pagamento");
        }

        return pagamento;
    }

    //RECUPERA PAGAMENTI DI UN ACQUISTO
    public List<Pagamento> getPagamentiPerAcquisto(int idAcquisto) throws SQLException {
        return pagamentoDAO.doRetrieveByAcquisto(idAcquisto);
    }

    //VERIFICA PAGAMENTO
    public boolean verificaPagamento(int idPagamento) throws SQLException {
        Pagamento pagamento = pagamentoDAO.doRetrieveById(idPagamento);
        return pagamento != null;
    }

    //CALCOLA TOTALE PAGATO
    public double calcolaTotalePagato(int idAcquisto) throws SQLException {
        List<Pagamento> pagamenti = getPagamentiPerAcquisto(idAcquisto);

        return pagamenti.stream()
                .mapToDouble(Pagamento::getImporto)
                .sum();
    }
}