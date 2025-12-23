package entity.spg;

import entity.sgc.Film;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Objects;

public class Programmazione {
    private int idProgrammazione;
    private LocalDate dataProgrammazione;
    private String tipo;
    private BigDecimal prezzoBase;
    private String stato; // DISPONIBILE, ANNULLATA, IN CORSO, CONCLUSA

    private int idFilm;
    private int idSala;
    private int idSlotOrario;
    private int idTariffa;

    private Tariffa tariffa;
    private SlotOrari slotOrario;
    private Sala sala;
    private Film film;

    public Programmazione() {
        this.stato = "DISPONIBILE";
    }

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
        this.tipo = tipo.toUpperCase();
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
        this.stato = stato.toUpperCase();
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

    public boolean isDisponibile() {
        return this.stato.equals("DISPONIBILE");
    }

    public boolean isAnnullata() {
        return this.stato.equals("ANNULLATA");
    }

    public boolean isInCorso() {
        return this.stato.equals("IN CORSO");
    }

    public boolean isConclusa() {
        return this.stato.equals("CONCLUSA");
    }

    public void annulla() {
        this.stato = "ANNULLATA";
    }

    public BigDecimal calcolaPrezzoFinale() {
        if (tariffa != null && tariffa.haSconto()) {
            return tariffa.applicaSconto(prezzoBase);
        }
        return prezzoBase;
    }

    public boolean haTariffaRidotta() {
        return tariffa != null && tariffa.haSconto();
    }

    public String getDescrizione() {
        StringBuilder sb = new StringBuilder();

        if (film != null) {
            sb.append(film.getTitolo());
        } else {
            sb.append("Film ID: ").append(idFilm);
        }

        sb.append(" - ").append(dataProgrammazione);

        if (slotOrario != null) {
            sb.append(" ore ").append(slotOrario.getOraInizio());
        }

        if (sala != null) {
            sb.append(" (").append(sala.getNome()).append(")");
        }

        sb.append(" - ").append(tipo);
        sb.append(" - €").append(prezzoBase);

        if (haTariffaRidotta()) {
            sb.append(" (").append(tariffa.getNome()).append(")");
        }

        return sb.toString();
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

    public Film getFilm() {
        return film;
    }

    public void setFilm(Film film) {
        this.film = film;
        if (film != null) {
            this.idFilm = film.getIdFilm();
        }
    }

    public Sala getSala() {
        return sala;
    }

    public void setSala(Sala sala) {
        this.sala = sala;
        if (sala != null) {
            this.idSala = sala.getIdSala();
        }
    }

    public SlotOrari getSlotOrario() {
        return slotOrario;
    }

    public void setSlotOrario(SlotOrari slotOrario) {
        this.slotOrario = slotOrario;
        if (slotOrario != null) {
            this.idSlotOrario = slotOrario.getIdSlot();
        }
    }

    public Tariffa getTariffa() {
        return tariffa;
    }

    public void setTariffa(Tariffa tariffa) {
        this.tariffa = tariffa;
        if (tariffa != null) {
            this.idTariffa = tariffa.getIdTariffa();
        }
    }
}
