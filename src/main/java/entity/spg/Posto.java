package entity.spg;

import java.util.Objects;

public class Posto {
    private int idPosto;
    private int fila;
    private int numeroPosto;
    private int idSala;
    private int idProgrammazione;
    private String stato;

    public Posto() { }

    public Posto(int idPosto, int fila, int numeroPosto, int idSala, int idProgrammazione, String stato) {
        this.idPosto = idPosto;
        this.setFila(fila);
        this.setNumeroPosto(numeroPosto);
        this.idSala = idSala;
        this.idProgrammazione = idProgrammazione;
        this.stato = stato;
    }

    public int getIdPosto() {
        return idPosto;
    }

    public void setIdPosto(int idPosto) {
        this.idPosto = idPosto;
    }

    public int getFila() {
        return fila;
    }

    public void setFila(int fila) {
        if (fila <= 0) {
            throw new IllegalArgumentException("La fila deve essere indicata con un numero positivo.");
        }
        this.fila = fila;
    }

    public int getNumeroPosto() {
        return numeroPosto;
    }

    public void setNumeroPosto(int numeroPosto) {
        if (numeroPosto <= 0) {
            throw new IllegalArgumentException("Il numero del posto deve essere un numero positivo.");
        }
        this.numeroPosto = numeroPosto;
    }

    public int getIdSala() {
        return idSala;
    }

    public void setIdSala(int idSala) {
        this.idSala = idSala;
    }

    public int getIdProgrammazione() {
        return idProgrammazione;
    }

    public void setIdProgrammazione(int idProgrammazione) {
        this.idProgrammazione = idProgrammazione;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Posto posto = (Posto) o;
        return idPosto == posto.idPosto && fila == posto.fila && numeroPosto == posto.numeroPosto && idSala == posto.idSala && idProgrammazione == posto.idProgrammazione && Objects.equals(stato, posto.stato);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idPosto, fila, numeroPosto, idSala, idProgrammazione, stato);
    }

    @Override
    public String toString() {
        return "Posto{" +
                "idPosto=" + idPosto +
                ", fila=" + fila +
                ", numeroPosto=" + numeroPosto +
                ", idSala=" + idSala +
                ", idProgrammazione=" + idProgrammazione +
                ", stato='" + stato + '\'' +
                '}';
    }
}
