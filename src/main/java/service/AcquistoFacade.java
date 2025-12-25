package service;

import entity.sga.Acquisto;
import entity.sga.Biglietto;
import entity.sga.Pagamento;
import entity.sgp.Posto;
import entity.sgp.Programmazione;
import entity.sgu.Utente;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

//FACADE PATTERN per il processo di ACQUISTO BIGLIETTI

public class AcquistoFacade {

    private Connection connection;
    private ProgrammazioneService programmazioneService;
    private PostoService postoService;
    private TariffaService tariffaService;
    private AcquistoService acquistoService;
    private PagamentoService pagamentoService;
    private BigliettoService bigliettoService;
    private SaldoService saldoService;

    public AcquistoFacade(Connection connection) {
        this.connection = connection;
        this.programmazioneService = new ProgrammazioneService(connection);
        this.postoService = new PostoService(connection);
        this.tariffaService = new TariffaService(connection);
        this.acquistoService = new AcquistoService(connection);
        this.pagamentoService = new PagamentoService(connection);
        this.bigliettoService = new BigliettoService(connection);
        this.saldoService = new SaldoService(connection);
    }

    //ELABORA ACQUISTO COMPLETO

    public RisultatoAcquisto elaboraAcquisto(
            Utente utente,
            int idProgrammazione,
            int numeroBiglietti,
            boolean usaSaldo
    ) throws SQLException, IllegalStateException {

        RisultatoAcquisto risultato = new RisultatoAcquisto();

        try {
            connection.setAutoCommit(false);

            // STEP 1: VERIFICA PROGRAMMAZIONE
            Programmazione programmazione = programmazioneService
                    .getProgrammazioneByKey(idProgrammazione);

            if (programmazione == null) {
                throw new IllegalStateException(
                        "Programmazione non trovata con ID: " + idProgrammazione
                );
            }

            if (!"Disponibile".equals(programmazione.getStato())) {
                throw new IllegalStateException(
                        "La programmazione non è disponibile per l'acquisto. Stato: " +
                                programmazione.getStato()
                );
            }

            risultato.setProgrammazione(programmazione);

            // STEP 2: VERIFICA DISPONIBILITÀ POSTI
            List<Posto> postiDisponibili = postoService
                    .verificaDisponibilitaPosti(idProgrammazione, numeroBiglietti);

            if (postiDisponibili.isEmpty() || postiDisponibili.size() < numeroBiglietti) {
                throw new IllegalStateException(
                        "Posti insufficienti. Richiesti: " + numeroBiglietti +
                                ", Disponibili: " + postiDisponibili.size()
                );
            }

            // STEP 3: ASSEGNA POSTI AUTOMATICAMENTE
            RisultatoAssegnazione assegnazione = postoService
                    .assegnaPostiAutomatico(postiDisponibili, numeroBiglietti);

            List<Posto> postiAssegnati = assegnazione.getPostiAssegnati();
            risultato.setPostiAssegnati(postiAssegnati);
            risultato.setVicinanzaGarantita(assegnazione.isVicinanzaGarantita());
            risultato.setMessaggioPosti(assegnazione.getMessaggio());

            // STEP 4: CALCOLA IMPORTO TOTALE
            double prezzoBase = programmazione.getPrezzoBase();
            double importoTotale = calcolaImportoConTariffa(
                    prezzoBase,
                    numeroBiglietti,
                    programmazione.getTariffa() != null ?
                            programmazione.getTariffa().getIdTariffa() : 0
            );

            risultato.setImportoTotale(importoTotale);

            // STEP 5: CREA ACQUISTO
            Acquisto acquisto = acquistoService.creaAcquisto(
                    utente,
                    numeroBiglietti,
                    importoTotale
            );

            risultato.setAcquisto(acquisto);

            // STEP 6: ELABORA PAGAMENTO (automaticamente misto se necessario)
            List<Pagamento> pagamenti = elaboraPagamento(
                    acquisto.getIdAcquisto(),
                    utente.getIdAccount(),
                    importoTotale,
                    usaSaldo
            );

            risultato.setPagamenti(pagamenti);

            // STEP 7: GENERA BIGLIETTI DIGITALI
            List<Biglietto> biglietti = new ArrayList<>();

            for (Posto posto : postiAssegnati) {
                Biglietto biglietto = bigliettoService.generaBiglietto(
                        acquisto.getIdAcquisto(),
                        programmazione.getIdProgrammazione(),
                        posto.getIdPosto(),
                        importoTotale / numeroBiglietti
                );
                biglietti.add(biglietto);
            }

            risultato.setBiglietti(biglietti);

            // STEP 8: AGGIORNA STATO POSTI
            postoService.assegnaPosti(postiAssegnati, acquisto.getIdAcquisto());

            // COMMIT TRANSAZIONE
            connection.commit();
            risultato.setSuccesso(true);
            risultato.setMessaggioFinale(
                    "Acquisto completato con successo! " +
                            "ID Acquisto: " + acquisto.getIdAcquisto()
            );

        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (SQLException rollbackEx) {
                throw new SQLException(
                        "Errore durante il rollback della transazione", rollbackEx
                );
            }

            risultato.setSuccesso(false);
            risultato.setMessaggioFinale("Errore durante l'acquisto: " + e.getMessage());
            throw new IllegalStateException("Acquisto fallito: " + e.getMessage(), e);

        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                // Log errore
            }
        }

        return risultato;
    }

    //Calcola importo con tariffa applicata
    private double calcolaImportoConTariffa(
            double prezzoBase,
            int numeroBiglietti,
            int idTariffa
    ) throws SQLException {

        double prezzoUnitario = prezzoBase;

        if (idTariffa > 0) {
            prezzoUnitario = tariffaService.applicaSconto(prezzoBase, idTariffa);
        }

        return prezzoUnitario * numeroBiglietti;
    }

    //ELABORA PAGAMENTO - LOGICA AUTOMATICA

     //Se usaSaldo = true:
     //Verifica saldo disponibile
     //Se saldo >= importo → paga tutto con saldo
    //Se saldo < importo → usa tutto il saldo + integra con carta (AUTOMATICO)
    //Se usaSaldo = false:
    // Paga tutto con carta
    private List<Pagamento> elaboraPagamento(
            int idAcquisto,
            int idAccount,
            double importoTotale,
            boolean usaSaldo
    ) throws SQLException {

        List<Pagamento> pagamenti = new ArrayList<>();

        if (usaSaldo) {
            // Recupera saldo disponibile dell'utente
            double saldoDisponibile = saldoService.getSaldoDisponibile(idAccount);

            if (saldoDisponibile >= importoTotale) {
                // CASO 1: Saldo sufficiente - paga tutto con saldo
                boolean saldoUtilizzato = saldoService.utilizzaSaldo(idAccount, importoTotale);

                if (!saldoUtilizzato) {
                    throw new IllegalStateException("Impossibile utilizzare il saldo");
                }

                Pagamento pagamentoSaldo = pagamentoService.effettuaPagamento(
                        idAcquisto,
                        "Saldo",
                        importoTotale,
                        "Saldo"
                );
                pagamenti.add(pagamentoSaldo);

            } else if (saldoDisponibile > 0) {
                // CASO 2: Saldo insufficiente - PAGAMENTO MISTO AUTOMATICO

                // 2.1 Usa tutto il saldo disponibile
                boolean saldoUtilizzato = saldoService.utilizzaSaldo(idAccount, saldoDisponibile);

                if (!saldoUtilizzato) {
                    throw new IllegalStateException("Impossibile utilizzare il saldo");
                }

                Pagamento acconto = pagamentoService.effettuaPagamento(
                        idAcquisto,
                        "Saldo",
                        saldoDisponibile,
                        "Acconto"
                );
                pagamenti.add(acconto);

                // 2.2 Calcola differenza e paga con carta
                double differenza = importoTotale - saldoDisponibile;

                Pagamento restoCarta = pagamentoService.effettuaPagamento(
                        idAcquisto,
                        "Carta",
                        differenza,
                        "Saldo"
                );
                pagamenti.add(restoCarta);

            } else {
                // CASO 3: Saldo zero o negativo - paga tutto con carta
                Pagamento pagamentoCarta = pagamentoService.effettuaPagamento(
                        idAcquisto,
                        "Carta",
                        importoTotale,
                        "Saldo"
                );
                pagamenti.add(pagamentoCarta);
            }

        } else {
            // Utente non vuole usare il saldo - paga tutto con carta
            Pagamento pagamentoCarta = pagamentoService.effettuaPagamento(
                    idAcquisto,
                    "Carta",
                    importoTotale,
                    "Saldo"
            );
            pagamenti.add(pagamentoCarta);
        }

        return pagamenti;
    }

    //VERIFICA SE UN ACQUISTO È POSSIBILE
    public boolean verificaAcquistoPossibile(
            int idProgrammazione,
            int numeroBiglietti
    ) throws SQLException {

        try {
            Programmazione prog = programmazioneService
                    .getProgrammazioneById(idProgrammazione);

            if (prog == null || !"Disponibile".equals(prog.getStato())) {
                return false;
            }

            int postiDisponibili = postoService
                    .contaPostiDisponibili(idProgrammazione);

            return postiDisponibili >= numeroBiglietti;

        } catch (SQLException e) {
            throw e;
        }
    }

    //CALCOLA ANTEPRIMA PREZZO
    public double calcolaAnteprimaPrezzo(
            int idProgrammazione,
            int numeroBiglietti
    ) throws SQLException {

        Programmazione prog = programmazioneService
                .getProgrammazioneById(idProgrammazione);

        if (prog == null) {
            throw new IllegalArgumentException("Programmazione non trovata");
        }

        return calcolaImportoConTariffa(
                prog.getPrezzoBase(),
                numeroBiglietti,
                prog.getTariffa() != null ? prog.getTariffa().getIdTariffa() : 0
        );
    }
}

// RISULTATO ACQUISTO
class RisultatoAcquisto {
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

    public boolean isSuccesso() { return successo; }
    public void setSuccesso(boolean successo) { this.successo = successo; }

    public String getMessaggioFinale() { return messaggioFinale; }
    public void setMessaggioFinale(String messaggioFinale) { this.messaggioFinale = messaggioFinale; }

    public String getMessaggioPosti() { return messaggioPosti; }
    public void setMessaggioPosti(String messaggioPosti) { this.messaggioPosti = messaggioPosti; }

    public Programmazione getProgrammazione() { return programmazione; }
    public void setProgrammazione(Programmazione programmazione) { this.programmazione = programmazione; }

    public Acquisto getAcquisto() { return acquisto; }
    public void setAcquisto(Acquisto acquisto) { this.acquisto = acquisto; }

    public List<Posto> getPostiAssegnati() { return postiAssegnati; }
    public void setPostiAssegnati(List<Posto> postiAssegnati) { this.postiAssegnati = postiAssegnati; }

    public List<Pagamento> getPagamenti() { return pagamenti; }
    public void setPagamenti(List<Pagamento> pagamenti) { this.pagamenti = pagamenti; }

    public List<Biglietto> getBiglietti() { return biglietti; }
    public void setBiglietti(List<Biglietto> biglietti) { this.biglietti = biglietti; }

    public double getImportoTotale() { return importoTotale; }
    public void setImportoTotale(double importoTotale) { this.importoTotale = importoTotale; }

    public boolean isVicinanzaGarantita() { return vicinanzaGarantita; }
    public void setVicinanzaGarantita(boolean vicinanzaGarantita) { this.vicinanzaGarantita = vicinanzaGarantita; }

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