package service.sga;

import entity.sga.Acquisto;
import entity.sga.Biglietto;
import entity.sga.Pagamento;
import entity.sgp.Posto;
import entity.sgp.Programmazione;
import entity.sgu.Utente;
import exception.sga.pagamento.PagamentoNonValidoException;
import exception.sga.pagamento.SalvataggioPagamentoException;
import exception.sga.saldo.AggiornamentoSaldoException;
import exception.sga.saldo.OperazioneSaldoNonValidaException;
import exception.sga.saldo.TipoAccountNonValidoException;
import exception.sga.saldo.UtenteNonTrovatoException;
import service.sgp.PostoService;
import service.sgp.ProgrammazioneService;
import service.sgp.RisultatoAssegnazione;
import service.sgp.TariffaService;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * FACADE PATTERN per il processo di ACQUISTO BIGLIETTI
 *
 * IMPORTANTE: Questa facade viene chiamata DOPO che i posti sono già stati
 * occupati temporaneamente dal checkout (via PostoService.occupaTemporaneamente).
 * Quindi i posti sono GIÀ OCCUPATO quando arriviamo qui.
 */
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

    /**
     * ELABORA ACQUISTO COMPLETO
     *
     * NOTA: I posti passati in input (tramite session) sono GIÀ OCCUPATO.
     * Questo metodo NON deve occuparli di nuovo, ma solo confermare l'acquisto.
     */
    public RisultatoAcquisto elaboraAcquisto(
            Utente utente,
            int idProgrammazione,
            int numeroBiglietti,
            boolean usaSaldo,
            List<Posto> postiPrenotati  // ← NUOVO PARAMETRO
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

            // STEP 2: USA I POSTI GIÀ PRENOTATI dalla sessione
            // (Non serve più verificare disponibilità - erano già occupati al checkout)
            List<Posto> postiAssegnati = postiPrenotati;

            risultato.setPostiAssegnati(postiAssegnati);
            risultato.setVicinanzaGarantita(true); // Già calcolato al checkout
            risultato.setMessaggioPosti("Posti confermati dal checkout");

            // STEP 3: CALCOLA IMPORTO TOTALE
            double prezzoBase = programmazione.getPrezzoBase();
            double importoTotale = calcolaImportoConTariffa(
                    prezzoBase,
                    numeroBiglietti,
                    programmazione.getTariffa() != null ?
                            programmazione.getTariffa().getIdTariffa() : 0
            );

            risultato.setImportoTotale(importoTotale);

            // STEP 4: CREA ACQUISTO
            Acquisto acquisto = acquistoService.creaAcquisto(
                    utente,
                    numeroBiglietti,
                    importoTotale
            );

            risultato.setAcquisto(acquisto);

            // STEP 5: ELABORA PAGAMENTO (automaticamente misto se necessario)
            List<Pagamento> pagamenti = elaboraPagamento(
                    acquisto.getIdAcquisto(),
                    utente.getIdAccount(),
                    importoTotale,
                    usaSaldo
            );

            risultato.setPagamenti(pagamenti);

            // STEP 6: GENERA BIGLIETTI DIGITALI
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

            // STEP 7: I POSTI SONO GIÀ OCCUPATO dal checkout
            // Non serve fare nulla - restano OCCUPATO definitivamente
            // (Rimosso: postoService.assegnaPosti(...))

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

    /**
     * Calcola importo con tariffa applicata
     */
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

    /**
     * ELABORA PAGAMENTO - LOGICA AUTOMATICA
     *
     * Se usaSaldo = true:
     *   - Verifica saldo disponibile
     *   - Se saldo >= importo → paga tutto con saldo
     *   - Se saldo < importo → usa tutto il saldo + integra con carta (AUTOMATICO)
     *
     * Se usaSaldo = false:
     *   - Paga tutto con carta
     */
    private List<Pagamento> elaboraPagamento(
            int idAcquisto,
            int idAccount,
            double importoTotale,
            boolean usaSaldo
    ) throws SQLException, PagamentoNonValidoException, SalvataggioPagamentoException,
            TipoAccountNonValidoException, AggiornamentoSaldoException,
            OperazioneSaldoNonValidaException, UtenteNonTrovatoException {

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

    /**
     * VERIFICA SE UN ACQUISTO È POSSIBILE
     */
    public boolean verificaAcquistoPossibile(
            int idProgrammazione,
            int numeroBiglietti
    ) throws SQLException {

        Programmazione prog = programmazioneService
                .getProgrammazioneById(idProgrammazione);

        if (prog == null || !"Disponibile".equals(prog.getStato())) {
            return false;
        }

        int postiDisponibili = postoService
                .contaPostiDisponibili(idProgrammazione);

        return postiDisponibili >= numeroBiglietti;
    }

    /**
     * CALCOLA ANTEPRIMA PREZZO
     */
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