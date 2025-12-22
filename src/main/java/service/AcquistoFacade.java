package service;

import entity.sga.Acquisto;
import entity.sga.Biglietto;
import entity.sga.Pagamento;
import entity.sgp.Posto;
import entity.sgp.Programmazione;
import entity.sgu.Utente;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * FACADE PATTERN per il processo di ACQUISTO BIGLIETTI
 *
 * Responsabilità:
 * - Coordinare il flusso completo di acquisto tra più sottosistemi
 * - Nascondere la complessità dell'interazione tra Service multipli
 * - Gestire la transazionalità dell'operazione
 * - Fornire un'interfaccia semplificata al Controller
 *
 * Sottosistemi coordinati:
 * 1. ProgrammazioneService - verifica programmazione valida
 * 2. PostoService - gestione e assegnazione posti
 * 3. TariffaService - calcolo prezzi con sconti
 * 4. AcquistoService - creazione acquisto
 * 5. PagamentoService - elaborazione pagamento
 * 6. BigliettoService - generazione biglietti digitali
 * 7. SaldoService - gestione saldo utente
 */
public class AcquistoFacade {

    // Dipendenze verso i Service Layer
    private Connection connection;
    private ProgrammazioneService programmazioneService;
    private PostoService postoService;
    private TariffaService tariffaService;
    private AcquistoService acquistoService;
    private PagamentoService pagamentoService;
    private BigliettoService bigliettoService;
    private SaldoService saldoService;

    /**
     * COSTRUTTORE
     * Inizializza tutti i service necessari con la stessa connessione
     * (importante per la gestione transazionale)
     */
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

    // ========================================================
    // METODO PRINCIPALE: PROCESSO COMPLETO DI ACQUISTO
    // ========================================================

    /**
     * ELABORA ACQUISTO COMPLETO
     *
     * Questo è il metodo PRINCIPALE che il Controller chiama.
     * Coordina l'intero flusso di acquisto in modo transazionale.
     *
     * Flusso:
     * 1. Verifica programmazione disponibile
     * 2. Verifica disponibilità posti
     * 3. Assegna posti automaticamente (con logica intelligente)
     * 4. Calcola importo totale con tariffe
     * 5. Crea record Acquisto
     * 6. Elabora pagamento (carta/saldo/misto)
     * 7. Genera biglietti digitali con QR Code
     * 8. Aggiorna stato posti a "Occupato"
     *
     * @param utente Utente che effettua l'acquisto
     * @param idProgrammazione ID della programmazione selezionata
     * @param numeroBiglietti Numero di biglietti da acquistare
     * @param metodoPagamento "Carta", "Saldo", o "Misto"
     * @param importoCarta Importo pagato con carta (0 se solo saldo)
     * @param importoSaldo Importo pagato con saldo (0 se solo carta)
     * @return RisultatoAcquisto con tutti i dettagli
     * @throws SQLException Se si verifica un errore di database
     * @throws IllegalStateException Se l'acquisto non può essere completato
     */
    public RisultatoAcquisto elaboraAcquisto(
            Utente utente,
            int idProgrammazione,
            int numeroBiglietti,
            String metodoPagamento,
            BigDecimal importoCarta,
            BigDecimal importoSaldo
    ) throws SQLException, IllegalStateException {

        RisultatoAcquisto risultato = new RisultatoAcquisto();

        try {
            // Disabilita auto-commit per gestione transazionale
            connection.setAutoCommit(false);

            // ====================================================
            // STEP 1: VERIFICA PROGRAMMAZIONE
            // ====================================================
            Programmazione programmazione = programmazioneService
                    .getProgrammazioneById(idProgrammazione);

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

            // ====================================================
            // STEP 2: VERIFICA DISPONIBILITÀ POSTI
            // ====================================================
            List<Posto> postiDisponibili = postoService
                    .verificaDisponibilitaPosti(idProgrammazione, numeroBiglietti);

            if (postiDisponibili.isEmpty() || postiDisponibili.size() < numeroBiglietti) {
                throw new IllegalStateException(
                        "Posti insufficienti. Richiesti: " + numeroBiglietti +
                                ", Disponibili: " + postiDisponibili.size()
                );
            }

            // ====================================================
            // STEP 3: ASSEGNA POSTI AUTOMATICAMENTE
            // ====================================================
            RisultatoAssegnazione assegnazione = postoService
                    .assegnaPostiAutomatico(postiDisponibili, numeroBiglietti);

            List<Posto> postiAssegnati = assegnazione.getPostiAssegnati();
            risultato.setPostiAssegnati(postiAssegnati);
            risultato.setVicinanzaGarantita(assegnazione.isVicinanzaGarantita());
            risultato.setMessaggioPosti(assegnazione.getMessaggio());

            // ====================================================
            // STEP 4: CALCOLA IMPORTO TOTALE
            // ====================================================
            BigDecimal prezzoBase = programmazione.getPrezzoBase();
            BigDecimal importoTotale = calcolaImportoConTariffa(
                    prezzoBase,
                    numeroBiglietti,
                    programmazione.getTariffa() != null ?
                            programmazione.getTariffa().getIdTariffa() : 0
            );

            risultato.setImportoTotale(importoTotale);

            // ====================================================
            // STEP 5: CREA ACQUISTO
            // ====================================================
            Acquisto acquisto = acquistoService.creaAcquisto(
                    utente,
                    numeroBiglietti,
                    importoTotale.doubleValue()
            );

            risultato.setAcquisto(acquisto);

            // ====================================================
            // STEP 6: ELABORA PAGAMENTO
            // ====================================================
            List<Pagamento> pagamenti = elaboraPagamento(
                    acquisto.getIdAcquisto(),
                    utente.getIdAccount(),
                    metodoPagamento,
                    importoTotale,
                    importoCarta,
                    importoSaldo
            );

            risultato.setPagamenti(pagamenti);

            // ====================================================
            // STEP 7: GENERA BIGLIETTI DIGITALI
            // ====================================================
            List<Biglietto> biglietti = new ArrayList<>();

            for (Posto posto : postiAssegnati) {
                Biglietto biglietto = bigliettoService.generaBiglietto(
                        acquisto.getIdAcquisto(),
                        programmazione.getIdProgrammazione(),
                        posto.getIdPosto(),
                        importoTotale.divide(BigDecimal.valueOf(numeroBiglietti))
                );
                biglietti.add(biglietto);
            }

            risultato.setBiglietti(biglietti);

            // ====================================================
            // STEP 8: AGGIORNA STATO POSTI
            // ====================================================
            postoService.assegnaPosti(postiAssegnati, acquisto.getIdAcquisto());

            // ====================================================
            // COMMIT TRANSAZIONE
            // ====================================================
            connection.commit();
            risultato.setSuccesso(true);
            risultato.setMessaggioFinale(
                    "Acquisto completato con successo! " +
                            "ID Acquisto: " + acquisto.getIdAcquisto()
            );

        } catch (Exception e) {
            // ROLLBACK in caso di errore
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
            // Ripristina auto-commit
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                // Log errore
            }
        }

        return risultato;
    }

    // ========================================================
    // METODI PRIVATI DI SUPPORTO
    // ========================================================

    /**
     * CALCOLA IMPORTO CON TARIFFA APPLICATA
     */
    private BigDecimal calcolaImportoConTariffa(
            BigDecimal prezzoBase,
            int numeroBiglietti,
            int idTariffa
    ) throws SQLException {

        BigDecimal prezzoUnitario = prezzoBase;

        // Applica sconto se c'è una tariffa
        if (idTariffa > 0) {
            prezzoUnitario = tariffaService.applicaSconto(prezzoBase, idTariffa);
        }

        return prezzoUnitario.multiply(BigDecimal.valueOf(numeroBiglietti));
    }

    /**
     * ELABORA PAGAMENTO (gestisce Carta, Saldo, Misto)
     *
     * Delega al PagamentoService la logica specifica del metodo scelto
     */
    private List<Pagamento> elaboraPagamento(
            int idAcquisto,
            int idAccount,
            String metodoPagamento,
            BigDecimal importoTotale,
            BigDecimal importoCarta,
            BigDecimal importoSaldo
    ) throws SQLException {

        List<Pagamento> pagamenti = new ArrayList<>();

        switch (metodoPagamento.toLowerCase()) {
            case "carta":
                // Solo carta
                Pagamento pagamentoCarta = pagamentoService.effettuaPagamento(
                        idAcquisto,
                        "Carta",
                        importoTotale,
                        "Saldo"
                );
                pagamenti.add(pagamentoCarta);
                break;

            case "saldo":
                // Solo saldo
                boolean saldoSufficiente = saldoService.utilizzaSaldo(
                        idAccount,
                        importoTotale
                );

                if (!saldoSufficiente) {
                    throw new IllegalStateException("Saldo insufficiente");
                }

                Pagamento pagamentoSaldo = pagamentoService.effettuaPagamento(
                        idAcquisto,
                        "Saldo",
                        importoTotale,
                        "Saldo"
                );
                pagamenti.add(pagamentoSaldo);
                break;

            case "misto":
                // Pagamento misto: usa tutto il saldo + differenza con carta

                // 1. Usa saldo disponibile
                if (importoSaldo.compareTo(BigDecimal.ZERO) > 0) {
                    boolean saldoUtilizzato = saldoService.utilizzaSaldo(
                            idAccount,
                            importoSaldo
                    );

                    if (!saldoUtilizzato) {
                        throw new IllegalStateException(
                                "Impossibile utilizzare il saldo"
                        );
                    }

                    Pagamento acconto = pagamentoService.effettuaPagamento(
                            idAcquisto,
                            "Saldo",
                            importoSaldo,
                            "Acconto"
                    );
                    pagamenti.add(acconto);
                }

                // 2. Paga differenza con carta
                if (importoCarta.compareTo(BigDecimal.ZERO) > 0) {
                    Pagamento restoCarta = pagamentoService.effettuaPagamento(
                            idAcquisto,
                            "Carta",
                            importoCarta,
                            "Saldo"
                    );
                    pagamenti.add(restoCarta);
                }
                break;

            default:
                throw new IllegalArgumentException(
                        "Metodo di pagamento non valido: " + metodoPagamento
                );
        }

        return pagamenti;
    }

    // ========================================================
    // METODI PUBBLICI AGGIUNTIVI
    // ========================================================

    /**
     * VERIFICA SE UN ACQUISTO È POSSIBILE
     * (utile per validazione pre-checkout)
     */
    public boolean verificaAcquistoPossibile(
            int idProgrammazione,
            int numeroBiglietti
    ) throws SQLException {

        try {
            // Verifica programmazione
            Programmazione prog = programmazioneService
                    .getProgrammazioneById(idProgrammazione);

            if (prog == null || !"Disponibile".equals(prog.getStato())) {
                return false;
            }

            // Verifica posti disponibili
            int postiDisponibili = postoService
                    .contaPostiDisponibili(idProgrammazione);

            return postiDisponibili >= numeroBiglietti;

        } catch (SQLException e) {
            throw e;
        }
    }

    /**
     * CALCOLA ANTEPRIMA PREZZO
     * (mostra all'utente il prezzo finale prima del checkout)
     */
    public BigDecimal calcolaAnteprimaPrezzo(
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


// ========================================================
// CLASSE DI RISULTATO
// ========================================================

/**
 * RISULTATO ACQUISTO
 *
 * Contiene tutti i dettagli dell'operazione di acquisto completata
 * Viene restituito al Controller per mostrare all'utente il riepilogo
 */
class RisultatoAcquisto {
    private boolean successo;
    private String messaggioFinale;
    private String messaggioPosti;

    private Programmazione programmazione;
    private Acquisto acquisto;
    private List<Posto> postiAssegnati;
    private List<Pagamento> pagamenti;
    private List<Biglietto> biglietti;

    private BigDecimal importoTotale;
    private boolean vicinanzaGarantita;

    public RisultatoAcquisto() {
        this.successo = false;
        this.postiAssegnati = new ArrayList<>();
        this.pagamenti = new ArrayList<>();
        this.biglietti = new ArrayList<>();
        this.vicinanzaGarantita = false;
    }

    // ========================================================
    // GETTERS E SETTERS
    // ========================================================

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

    public BigDecimal getImportoTotale() {
        return importoTotale;
    }

    public void setImportoTotale(BigDecimal importoTotale) {
        this.importoTotale = importoTotale;
    }

    public boolean isVicinanzaGarantita() {
        return vicinanzaGarantita;
    }

    public void setVicinanzaGarantita(boolean vicinanzaGarantita) {
        this.vicinanzaGarantita = vicinanzaGarantita;
    }

    /**
     * Genera un riepilogo testuale dell'acquisto
     */
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