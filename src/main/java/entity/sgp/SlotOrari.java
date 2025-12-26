package entity.sgp;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Objects;

public class SlotOrari {
    private int idSlot;
    private LocalTime oraInizio;
    private LocalTime oraFine;
    private String stato; // DISPONIBILE, OCCUPATO
    private LocalDate data;

    public SlotOrari() { }

    public SlotOrari(int idSlot, LocalTime oraInizio, LocalTime oraFine, String stato, LocalDate data) {
        this.idSlot = idSlot;
        this.setOraInizio(oraInizio);
        this.setOraFine(oraFine);
        this.setStato(stato);
        this.setData(data);
    }

    public int getIdSlot() {
        return idSlot;
    }

    public void setIdSlot(int idSlot) {
        this.idSlot = idSlot;
    }

    public LocalTime getOraInizio() {
        return oraInizio;
    }

    public void setOraInizio(LocalTime oraInizio) {
        if (oraInizio == null) {
            throw new IllegalArgumentException("L'ora di inizio non può essere nulla");
        }
        this.oraInizio = oraInizio;
    }

    public LocalTime getOraFine() {
        return oraFine;
    }

    public void setOraFine(LocalTime oraFine) {
        if (oraFine == null) {
            throw new IllegalArgumentException("L'ora di fine non può essere nulla");
        }
        if (this.oraInizio != null && (oraFine.isBefore(this.oraInizio) || oraFine.equals(this.oraInizio))) {
            throw new IllegalArgumentException("L'ora di fine deve essere successiva all'ora di inizio");
        }
        this.oraFine = oraFine;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        if (stato == null || stato.trim().isEmpty()) {
            throw new IllegalArgumentException("Lo stato dello slot è obbligatorio");
        }
        this.stato = stato.toUpperCase();
    }

    public LocalDate getData() {
        return data;
    }
    public void setData(LocalDate data) {
        if (data == null) {
            throw new IllegalArgumentException("La data dello slot è obbligatoria");
        }
        this.data = data;
    }



    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SlotOrari slotOrari = (SlotOrari) o;
        return idSlot == slotOrari.idSlot && Objects.equals(oraInizio, slotOrari.oraInizio) && Objects.equals(oraFine, slotOrari.oraFine) && Objects.equals(stato, slotOrari.stato) && Objects.equals(data, slotOrari.data);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idSlot, oraInizio, oraFine, stato, data);
    }

    @Override
    public String toString() {
        return "SlotOrario{" +
                "idSlot=" + idSlot +
                ", data=" + data +
                ", dalle=" + oraInizio +
                ", alle=" + oraFine +
                ", stato='" + stato + '\'' +
                '}';
    }

    public boolean puoContenereFilm(int durataMinuti) {
        if (oraInizio == null || oraFine == null) return false;
        long minutiDisponibili = Duration.between(oraInizio, oraFine).toMinutes();
        return minutiDisponibili >= durataMinuti;
    }

    public boolean isDisponibile() {
        return "DISPONIBILE".equals(this.stato);
    }


    public void occupa() {
        this.stato = "OCCUPATO";
    }

    public void libera() {
        this.stato = "DISPONIBILE";
    }
}



