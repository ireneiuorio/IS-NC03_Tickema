package entity.spg;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Objects;

public class Programmazione {
    private int idProgrammazione;
    private LocalDate dataProgrammazione;
    private String tipo;
    private BigDecimal prezzoBase;
    private String stato; // DISPONIBILE, ANNULLATA, IN_CORSO, CONCLUSA

    // Foreign keys
    private int idFilm;
    private int idSala;
    private int idSlotOrario;
    private int idTariffa;

    public Programmazione() { }

    public Programmazione(int idProgrammazione, LocalDate dataProgrammazione, String tipo, BigDecimal prezzoBase, String stato, int idFilm, int idSala, int idSlotOrario, int idTariffa) {
        this.idProgrammazione = idProgrammazione;
        this.setDataProgrammazione(dataProgrammazione);
        this.setTipo(tipo);
        this.setPrezzoBase(prezzoBase);
        this.setStato(stato);
        this.idFilm = idFilm;
        this.idSala = idSala;
        this.idSlotOrario = idSlotOrario;
        this.idTariffa = idTariffa;
    }

    public int getIdProgrammazione() {
        return idProgrammazione;
    }

    public void setIdProgrammazione(int idProgrammazione) {
        this.idProgrammazione = idProgrammazione;
    }

    public LocalDate getDataProgrammazione() {
        return dataProgrammazione;
    }

    public void setDataProgrammazione(LocalDate dataProgrammazione) {
        if (dataProgrammazione == null) {
            throw new IllegalArgumentException("La data della programmazione non può essere null.");
        }
        this.dataProgrammazione = dataProgrammazione;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public BigDecimal getPrezzoBase() {
        return prezzoBase;
    }

    public void setPrezzoBase(BigDecimal prezzoBase) {
        if (prezzoBase == null || prezzoBase.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Il prezzo base non può essere negativo-");
        }
        this.prezzoBase = prezzoBase;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        if (stato == null || stato.trim().isEmpty()) {
            throw new IllegalArgumentException("Lo stato della programmazione è un campo obbligatorio.");
        }
        this.stato = stato;
    }

    public int getIdFilm() {
        return idFilm;
    }

    public void setIdFilm(int idFilm) {
        this.idFilm = idFilm;
    }

    public int getIdSala() {
        return idSala;
    }

    public void setIdSala(int idSala) {
        this.idSala = idSala;
    }

    public int getIdSlotOrario() {
        return idSlotOrario;
    }

    public void setIdSlotOrario(int idSlotOrario) {
        this.idSlotOrario = idSlotOrario;
    }

    public Integer getIdTariffa() {
        return idTariffa;
    }

    public void setIdTariffa(Integer idTariffa) {
        this.idTariffa = idTariffa;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Programmazione that = (Programmazione) o;
        return idProgrammazione == that.idProgrammazione && idFilm == that.idFilm && idSala == that.idSala && idSlotOrario == that.idSlotOrario && Objects.equals(dataProgrammazione, that.dataProgrammazione) && Objects.equals(tipo, that.tipo) && Objects.equals(prezzoBase, that.prezzoBase) && Objects.equals(stato, that.stato) && Objects.equals(idTariffa, that.idTariffa);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idProgrammazione, dataProgrammazione, tipo, prezzoBase, stato, idFilm, idSala, idSlotOrario, idTariffa);
    }

    @Override
    public String toString() {
        return "Programmazione{" +
                "idProgrammazione=" + idProgrammazione +
                ", dataProgrammazione=" + dataProgrammazione +
                ", tipo='" + tipo + '\'' +
                ", prezzoBase=" + prezzoBase +
                ", stato='" + stato + '\'' +
                ", idFilm=" + idFilm +
                ", idSala=" + idSala +
                ", idSlotOrario=" + idSlotOrario +
                ", idTariffa=" + idTariffa +
                '}';
    }
}
