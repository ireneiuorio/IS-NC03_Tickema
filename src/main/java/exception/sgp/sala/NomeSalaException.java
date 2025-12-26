package exception.sgp.sala;

public class NomeSalaException extends RuntimeException {
    public NomeSalaException(String nome) {
        super("Esiste già una sala con nome: " + nome);
    }
}
