package service.sga;



import entity.sga.Acquisto;
import entity.sga.Biglietto;
import entity.sga.Pagamento;
import entity.sgp.Posto;
import entity.sgp.Programmazione;

import java.util.ArrayList;
import java.util.List;

//RISULTATO ACQUISTO: non viene salvato
// Contiene tutti i dettagli dell'operazione di acquisto completata
//Viene restituito da AcquistoFacade al Controller

//Restituisce RisultatoAcquisto invece di Acquisto per fornire al Controller
//tutti i dati necessari alla View (biglietti, posti, pagamenti, messaggi)
//in un unico oggetto, evitando query aggiuntive e semplificando la presentazione.


public class RisultatoAcquisto {
    private boolean successo;
    private String messaggioFinale;
    private String messaggioPosti;

    private Programmazione programmazione;
    private Acquisto acquisto;
    private List<Posto> postiAssegnati;
    private List<Pagamento> pagamenti;
    private List<Biglietto> biglietti;

    private double importoTotale;
    private boolean vicinanzaGarantita;

    public RisultatoAcquisto() {
        this.successo = false;
        this.postiAssegnati = new ArrayList<>();
        this.pagamenti = new ArrayList<>();
        this.biglietti = new ArrayList<>();
        this.vicinanzaGarantita = false;
    }

    // GETTERS E SETTERS

    public boolean isSuccesso() {
        return successo;
    }

    public void setSuccesso(boolean successo) {
        this.successo = successo;
    }

    public String getMessaggioFinale() {
        return messaggioFinale;
    }

    public void setMessaggioFinale(String messaggioFinale) {
        this.messaggioFinale = messaggioFinale;
    }

    public String getMessaggioPosti() {
        return messaggioPosti;
    }

    public void setMessaggioPosti(String messaggioPosti) {
        this.messaggioPosti = messaggioPosti;
    }

    public Programmazione getProgrammazione() {
        return programmazione;
    }

    public void setProgrammazione(Programmazione programmazione) {
        this.programmazione = programmazione;
    }

    public Acquisto getAcquisto() {
        return acquisto;
    }

    public void setAcquisto(Acquisto acquisto) {
        this.acquisto = acquisto;
    }

    public List<Posto> getPostiAssegnati() {
        return postiAssegnati;
    }

    public void setPostiAssegnati(List<Posto> postiAssegnati) {
        this.postiAssegnati = postiAssegnati;
    }

    public List<Pagamento> getPagamenti() {
        return pagamenti;
    }

    public void setPagamenti(List<Pagamento> pagamenti) {
        this.pagamenti = pagamenti;
    }

    public List<Biglietto> getBiglietti() {
        return biglietti;
    }

    public void setBiglietti(List<Biglietto> biglietti) {
        this.biglietti = biglietti;
    }

    public double getImportoTotale() {
        return importoTotale;
    }

    public void setImportoTotale(double importoTotale) {
        this.importoTotale = importoTotale;
    }

    public boolean isVicinanzaGarantita() {
        return vicinanzaGarantita;
    }

    public void setVicinanzaGarantita(boolean vicinanzaGarantita) {
        this.vicinanzaGarantita = vicinanzaGarantita;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("=== RIEPILOGO ACQUISTO ===\n");
        sb.append("Successo: ").append(successo ? "SÌ" : "NO").append("\n");
        sb.append("Messaggio: ").append(messaggioFinale).append("\n");

        if (successo) {
            sb.append("\nDettagli:\n");
            sb.append("- Film: ").append(programmazione.getFilm().getTitolo()).append("\n");
            sb.append("- Data: ").append(programmazione.getDataProgrammazione()).append("\n");
            sb.append("- Importo: €").append(importoTotale).append("\n");
            sb.append("- Biglietti: ").append(biglietti.size()).append("\n");
            sb.append("- Posti: ").append(messaggioPosti).append("\n");
        }

        return sb.toString();
    }
}