package entity.SGA;

import java.time.LocalDateTime;

public class Pagamento {
    private int idPagamento;
    private String metodoPagamento;
    private double importo;
    private LocalDateTime dataOraPagamento;
    private String tipo;
    private Acquisto acquisto;

    public Pagamento() {
    }

    public int getIdPagamento() {
        return idPagamento;
    }

    public void setIdPagamento(int idPagamento) {
        this.idPagamento = idPagamento;
    }

    public String getMetodoPagamento() {
        return metodoPagamento;
    }

    public void setMetodoPagamento(String metodoPagamento) {
        this.metodoPagamento = metodoPagamento;
    }

    public double getImporto() {
        return importo;
    }

    public void setImporto(double importo) {
        this.importo = importo;
    }

    public LocalDateTime getDataOraPagamento() {
        return dataOraPagamento;
    }

    public void setDataOraPagamento(LocalDateTime dataOraPagamento) {
        this.dataOraPagamento = dataOraPagamento;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public Acquisto getAcquisto() {
        return acquisto;
    }

    public void setAcquisto(Acquisto acquisto) {
        this.acquisto = acquisto;
    }
}