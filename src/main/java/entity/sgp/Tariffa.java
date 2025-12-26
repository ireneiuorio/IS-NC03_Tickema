package entity.sgp;

import java.util.Objects;

/**
 * Entità Tariffa
 * Rappresenta una tariffa applicabile ai biglietti con una certa percentuale di sconto sul prezzo di base
 */
public class Tariffa {
    private Integer idTariffa;
    private String tipo; // "INTERO", "RIDOTTO"
    private String nome;
    private double percentualeSconto;

    public Tariffa() { }

    public Tariffa(int idTariffa, String tipo, String nome, double percentualeSconto) {
        this.idTariffa = idTariffa;
        this.setTipo(tipo);
        this.setNome(nome);
        this.setPercentualeSconto(percentualeSconto);
    }

    public Integer getIdTariffa() {
        return idTariffa;
    }

    public void setIdTariffa(Integer idTariffa) {
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

    public double getPercentualeSconto() {
        return percentualeSconto;
    }

    public void setPercentualeSconto(double percentualeSconto) {
        //Controllare che la percentuale sia compresa tra 0 e 100
        if (percentualeSconto < 0 || percentualeSconto > 100) {
            throw new IllegalArgumentException("Lo sconto deve essere compreso tra 0 e 100.");
        }
        this.percentualeSconto = percentualeSconto;
    }


    //Calcola il prezzo scontato applicando la tariffa al prezzo base --> prezzoScontato = prezzoBase * (1 - percentualeSconto/100)
    public double applicaSconto(double prezzoBase) {
        if (prezzoBase < 0) {
            throw new IllegalArgumentException(
                    "Il prezzo base deve essere maggiore o uguale a zero."
            );
        }
        // Calcola lo sconto (es. 20% diventa 0.20)
        double fattoreSconto = percentualeSconto / 100.0;
        double importoSconto = prezzoBase * fattoreSconto;

// Sottrae lo sconto dal prezzo base
        double prezzoFinale = prezzoBase - importoSconto;

// Arrotonda a 2 decimali (es. 9.8765 -> 9.88)
        return Math.round(prezzoFinale * 100.0) / 100.0;
    }


    public double calcolaImportoSconto(double prezzoBase) {
        if (prezzoBase < 0) {
            return 0.0;
        }

        double prezzoScontato = applicaSconto(prezzoBase);
        double importoSconto = prezzoBase - prezzoScontato;

        // Arrotonda a 2 decimali per coerenza con i centesimi
        return Math.round(importoSconto * 100.0) / 100.0;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Tariffa tariffa = (Tariffa) o;
        return idTariffa == tariffa.idTariffa && Objects.equals(tipo, tariffa.tipo) && Objects.equals(nome, tariffa.nome) && Objects.equals(percentualeSconto, tariffa.percentualeSconto);
    }

    // Verifica se la tariffa prevede uno sconto
    public boolean haSconto() {
        return percentualeSconto > 0;
    }

    // Verifica se la tariffa è intera (nessuno sconto)
    public boolean isTariffaIntera() {
        return percentualeSconto == 0;
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
