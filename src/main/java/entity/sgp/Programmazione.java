package entity.sgp;

import entity.sgc.Film;

import java.time.LocalDate;
import java.util.Objects;

/**
 * Entità Programmazione
 * Rappresenta la programmazione di un film in una sala specifica con un certo orario e una tariffa da poter applicare
 */
public class Programmazione {
    private int idProgrammazione;
    private LocalDate dataProgrammazione;
    private String tipo;
    private double prezzoBase;
    private String stato; // DISPONIBILE, ANNULLATA, IN CORSO, CONCLUSA

    private int idFilm;
    private int idSala;
    private int idSlotOrari;
    private int idTariffa;

    private Tariffa tariffa;
    private SlotOrari slotOrari;
    private Sala sala;
    private Film film;

    public Programmazione() {
        this.stato = "DISPONIBILE";
    }

    public Programmazione(int idProgrammazione, LocalDate dataProgrammazione, String tipo, double prezzoBase, String stato, int idFilm, int idSala, int idSlotOrari, int idTariffa) {
        this.idProgrammazione = idProgrammazione;
        this.setDataProgrammazione(dataProgrammazione);
        this.setTipo(tipo);
        this.setPrezzoBase(prezzoBase);
        this.setStato(stato);

        this.idFilm = idFilm;
        this.idSala = idSala;
        this.idSlotOrari = idSlotOrari;
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

    public double getPrezzoBase() {
        return prezzoBase;
    }

    public void setPrezzoBase(double prezzoBase) {
        if (prezzoBase < 0) {
            throw new IllegalArgumentException("Il prezzo base non può essere negativo.");
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

    public int getIdSlotOrari() {
        return idSlotOrari;
    }

    public void setIdSlotOrari(int idSlotOrari) {
        this.idSlotOrari = idSlotOrari;
    }

    public Integer getIdTariffa() {
        return idTariffa;
    }

    public void setIdTariffa(Integer idTariffa) {
        this.idTariffa = idTariffa;
    }


    //Verifica se la programmazione può essere acquistata
    public boolean isDisponibile() {
        return this.stato.equals("DISPONIBILE");
    }

    //Verifica se la programmazione è stata annullata
    public boolean isAnnullata() {
        return this.stato.equals("ANNULLATA");
    }


    //Verifica se la programmazione è in corso
    public boolean isInCorso() {
        return this.stato.equals("IN CORSO");
    }

    //Verifica se la programmazioe si è conclusa
    public boolean isConclusa() {
        return this.stato.equals("CONCLUSA");
    }

    public void annulla() {
        this.stato = "ANNULLATA";
    }

    //Calcola il prezzo finale applicando la tariffa
    public double calcolaPrezzoFinale() {
        if (tariffa != null && tariffa.haSconto()) {
            return tariffa.applicaSconto(prezzoBase);
        }
        return prezzoBase;
    }

    //Verifica se ha una tariffa ridotta applicata
    public boolean haTariffaRidotta() {
        return tariffa != null && tariffa.haSconto();
    }

    //Descrive una programmazione in formato leggibile
    public String getDescrizione() {
        StringBuilder sb = new StringBuilder();

        if (film != null) {
            sb.append(film.getTitolo());
        } else {
            sb.append("Film ID: ").append(idFilm);
        }

        sb.append(" - ").append(dataProgrammazione);

        if (slotOrari != null) {
            sb.append(" ore ").append(slotOrari.getOraInizio());
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
        return idProgrammazione == that.idProgrammazione && idFilm == that.idFilm && idSala == that.idSala && idSlotOrari == that.idSlotOrari && Objects.equals(dataProgrammazione, that.dataProgrammazione) && Objects.equals(tipo, that.tipo) && Objects.equals(prezzoBase, that.prezzoBase) && Objects.equals(stato, that.stato) && Objects.equals(idTariffa, that.idTariffa);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idProgrammazione, dataProgrammazione, tipo, prezzoBase, stato, idFilm, idSala, idSlotOrari, idTariffa);
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
                ", idSlotOrari=" + idSlotOrari +
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

    public SlotOrari getSlotOrari() {
        return slotOrari;
    }

    public void setSlotOrari(SlotOrari slotOrari) {
        this.slotOrari = slotOrari;
        if (slotOrari != null) {
            this.idSlotOrari = slotOrari.getIdSlotOrario();
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
