package entity.sga;

import java.time.LocalDateTime;

public class Acquisto {
    private int idAcquisto;
    private double importoTotale;
    private LocalDateTime dataOraAcquisto;
    private String stato;
    private int numeroBiglietti;
    private Utente utente;

    public Acquisto() {
    }

    public int getIdAcquisto() {
        return idAcquisto;
    }

    public void setIdAcquisto(int idAcquisto) {
        this.idAcquisto = idAcquisto;
    }

    public double getImportoTotale() {
        return importoTotale;
    }

    public void setImportoTotale(double importoTotale) {
        this.importoTotale = importoTotale;
    }

    public LocalDateTime getDataOraAcquisto() {
        return dataOraAcquisto;
    }

    public void setDataOraAcquisto(LocalDateTime dataOraAcquisto) {
        this.dataOraAcquisto = dataOraAcquisto;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

    public int getNumeroBiglietti() {
        return numeroBiglietti;
    }

    public void setNumeroBiglietti(int numeroBiglietti) {
        this.numeroBiglietti = numeroBiglietti;
    }

    public Utente getUtente() {
        return utente;
    }

    public void setUtente(Utente utente) {
        this.utente = utente;
    }
}