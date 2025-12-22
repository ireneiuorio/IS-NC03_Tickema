package entity.spg;

import java.math.BigDecimal;
import java.util.Objects;

public class Tariffa {
    private int idTariffa;
    private String tipo; // "INTERO", "RIDOTTO"
    private String nome;
    private BigDecimal percentualeSconto;

    public Tariffa() { }

    public Tariffa(int idTariffa, String tipo, String nome, BigDecimal percentualeSconto) {
        this.idTariffa = idTariffa;
        this.setTipo(tipo);
        this.setNome(nome);
        this.setPercentualeSconto(percentualeSconto);
    }

    public int getIdTariffa() {
        return idTariffa;
    }

    public void setIdTariffa(int idTariffa) {
        this.idTariffa = idTariffa;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        if (tipo == null || (!tipo.equals("INTERO") && !tipo.equals("RIDOTTO"))) {
            throw new IllegalArgumentException("Il tipo deve essere INTERO oppure RIDOTTO.");
        }
        this.tipo = tipo;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        if (nome == null || nome.trim().isEmpty()) {
            throw new IllegalArgumentException("Il nome della tariffa è un campo obbligatorio.");
        }
        this.nome = nome;
    }

    public BigDecimal getPercentualeSconto() {
        return percentualeSconto;
    }

    public void setPercentualeSconto(BigDecimal percentualeSconto) {
        //Controllare che la percentuale sia compresa tra 0 e 100
        if (percentualeSconto == null ||
                percentualeSconto.compareTo(BigDecimal.ZERO) < 0 ||
                percentualeSconto.compareTo(new BigDecimal("100")) > 0) {
            throw new IllegalArgumentException("Lo sconto deve essere compreso tra 0 e 100.");
        }
        this.percentualeSconto = percentualeSconto;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Tariffa tariffa = (Tariffa) o;
        return idTariffa == tariffa.idTariffa && Objects.equals(tipo, tariffa.tipo) && Objects.equals(nome, tariffa.nome) && Objects.equals(percentualeSconto, tariffa.percentualeSconto);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idTariffa, tipo, nome, percentualeSconto);
    }

    @Override
    public String toString() {
        return "Tariffa{" +
                "idTariffa=" + idTariffa +
                ", tipo='" + tipo + '\'' +
                ", nome='" + nome + '\'' +
                ", percentualeSconto=" + percentualeSconto +
                '}';
    }
}
