package entity.sgp;

import java.util.Objects;

/**
 * Entità posto
 * Rappresenta un posto all'interno di una sala per una specifica programmazione
 */
public class Posto {
    private int idPosto;
    private int fila;
    private int numeroPosto;
    private String stato; //DISPONIBILE, OCCUPATO

    private int idSala;
    private int idProgrammazione;

    public Posto() {
        this.stato = "DISPONIBILE";
    }

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
        if (stato == null || stato.trim().isEmpty()) {
            throw new IllegalArgumentException("Lo stato del posto è un campo obbligatorio.");
        }

        //Validazione degli stati in modo tale da non inserire stati diversi da quelli definiti
        String statoUpper = stato.toUpperCase();
        if (!statoUpper.equals("DISPONIBILE") &&
                !statoUpper.equals("OCCUPATO")) {
            throw new IllegalArgumentException(
                    "Stato non valido. Stati ammessi: DISPONIBILE, OCCUPATO."
            );
        }

        this.stato = statoUpper;
    }

    //Verifica del posto a sedere
    public boolean isDisponibile() {
        return this.stato.equals("DISPONIBILE");
    }

    public boolean isOccupato() {
        return this.stato.equals("OCCUPATO");
    }

    public void occupa() {
        this.stato = "OCCUPATO";
    }

    public void libera() {
        this.stato = "DISPONIBILE";
    }

    //Identifica in modo leggibile il posto
    public String getIdentificatore() {
        return String.format("Fila %d, Posto %d", fila, numeroPosto);
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
