package entity.sga;

import java.time.LocalDateTime;

public class Biglietto {
    private int idBiglietto;
    private double prezzoFinale;
    private String stato;
    private String QRCode;
    private LocalDateTime dataUtilizzo;
    private Acquisto acquisto;
    private Programmazione programmazione;
    private Posto posto;
    private Utente personaleValidazione;

    public Biglietto() {
    }

    public int getIdBiglietto() {
        return idBiglietto;
    }

    public void setIdBiglietto(int idBiglietto) {
        this.idBiglietto = idBiglietto;
    }

    public double getPrezzoFinale() {
        return prezzoFinale;
    }

    public void setPrezzoFinale(double prezzoFinale) {
        this.prezzoFinale = prezzoFinale;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

    public String getQRCode() {
        return QRCode;
    }

    public void setQRCode(String QRCode) {
        this.QRCode = QRCode;
    }

    public LocalDateTime getDataUtilizzo() {
        return dataUtilizzo;
    }

    public void setDataUtilizzo(LocalDateTime dataUtilizzo) {
        this.dataUtilizzo = dataUtilizzo;
    }

    public Acquisto getAcquisto() {
        return acquisto;
    }

    public void setAcquisto(Acquisto acquisto) {
        this.acquisto = acquisto;
    }

    public Programmazione getProgrammazione() {
        return programmazione;
    }

    public void setProgrammazione(Programmazione programmazione) {
        this.programmazione = programmazione;
    }

    public Posto getPosto() {
        return posto;
    }

    public void setPosto(Posto posto) {
        this.posto = posto;
    }

    public Utente getPersonaleValidazione() {
        return personaleValidazione;
    }

    public void setPersonaleValidazione(Utente personaleValidazione) {
        this.personaleValidazione = personaleValidazione;
    }
}