package entity.spg;

import java.util.Objects;

public class Sala {
    private int idSala;
    private String nome;
    private int numeroDiFile;
    private int capienza;
    private int numeroPostiPerFila;

    public Sala() { }

    public Sala(int idSala, String nome, int numeroDiFile, int numeroPostiPerFila) {
        this.idSala = idSala;
        this.setNome(nome);
        this.setConfigurazione(numeroDiFile, numeroPostiPerFila);
    }

    /**
     * Metodo di sostegno per il calcolo della configurazione dei posti
     */
    public void setConfigurazione(int numeroDiFile, int numeroPostiPerFila) {
        if (numeroDiFile <= 0 || numeroPostiPerFila <= 0) {
            throw new IllegalArgumentException("Le dimensioni della sala devono essere espresse con numeri positivi.");
        }
        this.numeroDiFile = numeroDiFile;
        this.numeroPostiPerFila = numeroPostiPerFila;
        this.capienza = numeroDiFile * numeroPostiPerFila;
    }

    public int getIdSala() {
        return idSala;
    }

    public void setIdSala(int idSala) {
        this.idSala = idSala;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        if (nome == null || nome.trim().isEmpty()) {
            throw new IllegalArgumentException("Il nome della sala è un campo obbligatorio.");
        }
        this.nome = nome;
    }

    public int getNumeroDiFile() {
        return numeroDiFile;
    }
    public int getCapienza() {
        return capienza;
    }
    public int getNumeroPostiPerFila() {
        return numeroPostiPerFila;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Sala sala = (Sala) o;
        return idSala == sala.idSala && numeroDiFile == sala.numeroDiFile && capienza == sala.capienza && numeroPostiPerFila == sala.numeroPostiPerFila && Objects.equals(nome, sala.nome);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idSala, nome, numeroDiFile, capienza, numeroPostiPerFila);
    }

    @Override
    public String toString() {
        return "Sala{" +
                "idSala=" + idSala +
                ", nome='" + nome + '\'' +
                ", numeroDiFile=" + numeroDiFile +
                ", capienza=" + capienza +
                ", numeroPostiPerFila=" + numeroPostiPerFila +
                '}';
    }
}
