package exception.sga.pagamento;

//Eccezione lanciata quando un pagamento non viene trovato

public class PagamentoNonTrovatoException extends Exception {

    private final int idPagamento;

    public PagamentoNonTrovatoException(int idPagamento) {
        super("Pagamento con ID " + idPagamento + " non trovato");
        this.idPagamento = idPagamento;
    }

    public int getIdPagamento() {
        return idPagamento;
    }
}