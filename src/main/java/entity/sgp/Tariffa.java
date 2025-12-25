package entity.sgp;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Objects;

/**
 * Entità Tariffa
 * Rappresenta una tariffa applicabile ai biglietti con una certa percentuale di sconto sul prezzo di base
 */
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
        if (tipo == null || tipo.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Il tipo della tariffa è un campo obbligatorio."
            );
        }
        this.tipo = tipo.trim().toUpperCase();
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


    //Calcola il prezzo scontato applicando la tariffa al prezzo base --> prezzoScontato = prezzoBase * (1 - percentualeSconto/100)
    public BigDecimal applicaSconto(BigDecimal prezzoBase) {
        if (prezzoBase == null || prezzoBase.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException(
                    "Il prezzo base deve essere maggiore o uguale a zero."
            );
        }
        //Calcolo dello sconto in valore assoluto
        BigDecimal fattoreSconto = percentualeSconto.divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP);
        BigDecimal importoSconto = prezzoBase.multiply(fattoreSconto);

        // Sottrae lo sconto dal prezzo base
        BigDecimal prezzoFinale = prezzoBase.subtract(importoSconto);

        // Arrotonda a 2 decimali
        return prezzoFinale.setScale(2, RoundingMode.HALF_UP);
    }


    public BigDecimal calcolaImportoSconto(BigDecimal prezzoBase) {
        if (prezzoBase == null || prezzoBase.compareTo(BigDecimal.ZERO) < 0) {
            return BigDecimal.ZERO;
        }

        BigDecimal prezzoScontato = applicaSconto(prezzoBase);
        return prezzoBase.subtract(prezzoScontato).setScale(2, RoundingMode.HALF_UP);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Tariffa tariffa = (Tariffa) o;
        return idTariffa == tariffa.idTariffa && Objects.equals(tipo, tariffa.tipo) && Objects.equals(nome, tariffa.nome) && Objects.equals(percentualeSconto, tariffa.percentualeSconto);
    }

    //Verifica se la tariffa prevede uno sconto
    public boolean haSconto() {
        return percentualeSconto.compareTo(BigDecimal.ZERO) > 0;
    }

    //Verifica se la tariffa in questione è intera, cioè senza nessuno sconto
    public boolean isTariffaIntera() {
        return percentualeSconto.compareTo(BigDecimal.ZERO) == 0;
    }

    //Descrive in formato leggibile la tariffa
    public String getDescrizione() {
        if (isTariffaIntera()) {
            return String.format("%s - %s (tariffa intera)", tipo, nome);
        }
        return String.format("%s - %s (%.0f%% di sconto)",
                tipo, nome, percentualeSconto);
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
