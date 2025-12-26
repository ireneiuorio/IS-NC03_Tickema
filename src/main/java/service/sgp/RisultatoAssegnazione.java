package service.sgp;


import entity.sgp.Posto;
import java.util.List;

/**
 * RISULTATO ASSEGNAZIONE POSTI
 * DTO che contiene il risultato dell'assegnazione automatica dei posti.
 * Include i posti assegnati, se sono vicini, e un messaggio descrittivo.
 */
public class RisultatoAssegnazione {

    private List<Posto> postiAssegnati;
    private boolean vicinanzaGarantita;
    private String messaggio;

    public RisultatoAssegnazione(
            List<Posto> postiAssegnati,
            boolean vicinanzaGarantita,
            String messaggio
    ) {
        this.postiAssegnati = postiAssegnati;
        this.vicinanzaGarantita = vicinanzaGarantita;
        this.messaggio = messaggio;
    }

    // Getters

    public List<Posto> getPostiAssegnati() {
        return postiAssegnati;
    }

    public boolean isVicinanzaGarantita() {
        return vicinanzaGarantita;
    }

    public String getMessaggio() {
        return messaggio;
    }

    @Override
    public String toString() {
        return "RisultatoAssegnazione{" +
                "postiAssegnati=" + postiAssegnati.size() +
                ", vicinanzaGarantita=" + vicinanzaGarantita +
                ", messaggio='" + messaggio + '\'' +
                '}';
    }
}