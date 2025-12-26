package service.sgp;

import entity.sga.Acquisto;
import entity.sga.Biglietto;
import entity.sgc.Film;
import entity.sgp.Programmazione;
import entity.sgp.Sala;
import entity.sgp.SlotOrari;
import entity.sgp.Tariffa;
import exception.sgp.programmazione.*;
import exception.sgp.sala.SalaNonTrovataException;
import exception.sgp.slot.SlotNonTrovatoException;
import exception.sgp.tariffa.TariffaNonTrovataException;
import repository.sga.AcquistoDAO;
import repository.sga.BigliettoDAO;
import repository.sgc.FilmDAO;
import repository.sgp.ProgrammazioneDAO;
import repository.sgp.SalaDAO;
import repository.sgp.SlotOrariDAO;
import repository.sgp.TariffaDAO;
import repository.sgu.UtenteDAO;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class ProgrammazioneService {
    private Connection connection;

    private ProgrammazioneDAO programmazioneDAO;
    private FilmDAO filmDAO;
    private SalaDAO salaDAO;
    private SlotOrariDAO slotOrariDAO;
    private TariffaDAO tariffaDAO;
    private BigliettoDAO bigliettoDAO;
    private AcquistoDAO acquistoDAO;
    private UtenteDAO utenteDAO;

    public ProgrammazioneService(Connection connection) {
        this.connection = connection;
        this.programmazioneDAO = new ProgrammazioneDAO(connection);
        this.filmDAO = new FilmDAO(connection);
        this.salaDAO = new SalaDAO(connection);
        this.slotOrariDAO = new SlotOrariDAO(connection);
        this.tariffaDAO = new TariffaDAO(connection);
        this.bigliettoDAO = new BigliettoDAO(connection);
        this.acquistoDAO = new AcquistoDAO(connection);
        this.utenteDAO = new UtenteDAO(connection);
    }

    public List<Programmazione> visualizzaProgrammazioniFilm(int idFilm)  {
        try {
            return programmazioneDAO.doRetrieveAllByFilm(idFilm);
        } catch (SQLException e) {
            throw new RecuperoProgrammazioniException(e);
        }
    }

    public List<Programmazione> getProgrammazioniPerData(LocalDate data) {
        try {
            return programmazioneDAO.doRetrieveByData(data);
        } catch (SQLException e) {
            throw new RecuperoProgrammazioniException(e);
        }
    }

    public List<Programmazione> getProgrammazioniPerSala(int idSala, LocalDate data) {
        try {
            return programmazioneDAO.doRetrieveBySalaAndData(idSala, data);
        } catch (SQLException e) {
            throw new RecuperoProgrammazioniException(e);
        }
    }

    public Programmazione creaProgrammazioneSingola(LocalDate date, String tipo, double prezzoBase, LocalTime oraInizio, int idFilm, int idSala, int idSlotOrario, Integer idTariffa) {

        try {
            // Inizio transazione atomica
            connection.setAutoCommit(false);


            // 1. Verifica esistenza film
            Film film = filmDAO.doRetrieveByKey(idFilm);
            if (film == null) {
                throw new FilmNonTrovatoException(idFilm);
            }

            // 2. Verifica esistenza sala
            Sala sala = salaDAO.doRetrieveByKey(idSala);
            if (sala == null) {
                throw new SalaNonTrovataException(idSala);
            }

            // 3. Verifica esistenza e disponibilità slotOrario
            SlotOrari slot = slotOrariDAO.doRetrieveByKey(idSlotOrario);
            if (slot == null) {
                throw new SlotNonTrovatoException(idSlotOrario);
            }

            if (!slot.isDisponibile()) {
                throw new SlotNonDisponibileException(slot.getStato());
            }

            // 4. Verifica che lo slot sia libero per quella sala
            if (programmazioneDAO.existsBySlotAndSala(idSlotOrario, idSala)) {
                throw new SlotOccupatoException();
            }

            // 5. Verifica coerenza data con slot
            if (!date.equals(slot.getData())) {
                throw new DataException();
            }

            // 6. Verifica che il film possa stare nello slot
            if (!slot.puoContenereFilm(film.getDurata())) {
                throw new DurataFilmException();
            }

            // 7. Verifica validità tariffa (se specificata)
            if (idTariffa != null) {
                Tariffa tariffa = tariffaDAO.doRetrieveByKey(idTariffa);
                if (tariffa == null) {
                    throw new TariffaNonTrovataException(idTariffa);
                }
            }


            Programmazione programmazione = new Programmazione();
            programmazione.setDataProgrammazione(date);
            programmazione.setTipo(tipo);
            programmazione.setPrezzoBase(prezzoBase);
            programmazione.setStato("DISPONIBILE");
            programmazione.setIdFilm(idFilm);
            programmazione.setIdSala(idSala);
            programmazione.setIdSlotOrario(idSlotOrario);
            programmazione.setIdTariffa(idTariffa);

            Programmazione result = programmazioneDAO.doSave(programmazione);

            // AGGIORNAMENTO SLOT ORARIO
            slot.occupa(); // Cambia stato a OCCUPATO
            slotOrariDAO.doUpdate(slot);

            connection.commit();
            return result;

        } catch (SQLException e) {
            rollback();
            throw new CreazioneProgrammazioneException(e);
        } catch (IllegalArgumentException e) {
            rollback();
            throw new DatiProgrammazioneNonValidiException(e);
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) { //
            }
        }
    }

    public List<Programmazione> creaProgrammazioneMultipla(List<LocalDate> date, String tipo, double prezzoBase, List<LocalTime> oraInizio, int idFilm, List<Integer> idSala, List<Integer> idSlotOrario, List<Integer> idTariffa) {

        // Validazione input: tutte le liste devono avere la stessa lunghezza
        if (date.size() != idSala.size() ||
                date.size() != idSlotOrario.size() ||
                date.size() != oraInizio.size()) {
            throw new ParametriException();
        }

        List<Programmazione> programmazioni = new ArrayList<>();

        try {
            connection.setAutoCommit(false);

            // Crea ogni programmazione
            for (int i = 0; i < date.size(); i++) {
                Integer tariffa = (idTariffa != null && i < idTariffa.size())
                        ? idTariffa.get(i)
                        : null;

                Programmazione prog = creaProgrammazioneSingolaInternal(date.get(i), tipo, prezzoBase, oraInizio.get(i), idFilm, idSala.get(i), idSlotOrario.get(i), tariffa);

                programmazioni.add(prog);
            }

            connection.commit();
            return programmazioni;

        } catch (SQLException e) {
            rollback();
            throw new CreazioneProgrammazioneMultiplaException(e);
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                // Log error
            }
        }
    }

    private Programmazione creaProgrammazioneSingolaInternal(LocalDate date, String tipo, double prezzoBase, LocalTime oraInizio, int idFilm, int idSala, int idSlotOrario, Integer idTariffa
    ) throws SQLException{

        // Validazioni
        SlotOrari slot = slotOrariDAO.doRetrieveByKey(idSlotOrario);
        if (slot == null || !slot.isDisponibile()) {
            throw new SlotNonDisponibileException(slot.getStato());
        }

        if (programmazioneDAO.existsBySlotAndSala(idSlotOrario, idSala)) {
            throw new SlotOccupatoException(idSala);
        }

        // Creazione
        Programmazione p = new Programmazione();
        p.setDataProgrammazione(date);
        p.setTipo(tipo);
        p.setPrezzoBase(prezzoBase);
        p.setStato("DISPONIBILE");
        p.setIdFilm(idFilm);
        p.setIdSala(idSala);
        p.setIdSlotOrario(idSlotOrario);
        p.setIdTariffa(idTariffa);

        Programmazione result = programmazioneDAO.doSave(p);

        // Aggiorna slot
        slot.occupa();
        slotOrariDAO.doUpdate(slot);

        return result;
    }

    public boolean modificaProgrammazione(int idProgrammazione, LocalDate date, String tipo, double prezzoBase, String stato, LocalTime oraInizio, int idFilm, int idSala, int idSlotOrario, Integer idTariffa) {

        try {
            connection.setAutoCommit(false);

            // Recupera programmazione esistente
            Programmazione prog = programmazioneDAO.doRetrieveByKey(idProgrammazione);
            if (prog == null) {
                throw new ProgrammazioneNonTrovataException(idProgrammazione);
            }

            // Verifica se sta cambiando slot/sala
            boolean cambioSlot = (prog.getIdSlotOrario() != idSlotOrario);
            boolean cambioSala = (prog.getIdSala() != idSala);

            if (cambioSlot || cambioSala) {
                // Verifica disponibilità nuovo slot/sala
                if (programmazioneDAO.existsBySlotAndSalaExcluding(
                        idSlotOrario, idSala, idProgrammazione)) {
                    throw new SlotNonDisponibileException("");
                }

                // Libera vecchio slot
                SlotOrari vecchioSlot = slotOrariDAO.doRetrieveByKey(
                        prog.getIdSlotOrario()
                );
                if (vecchioSlot != null) {
                    vecchioSlot.libera();
                    slotOrariDAO.doUpdate(vecchioSlot);
                }

                // Occupa nuovo slot
                SlotOrari nuovoSlot = slotOrariDAO.doRetrieveByKey(idSlotOrario);
                if (nuovoSlot != null) {
                    nuovoSlot.occupa();
                    slotOrariDAO.doUpdate(nuovoSlot);
                }
            }

            // Aggiorna programmazione
            prog.setDataProgrammazione(date);
            prog.setTipo(tipo);
            prog.setPrezzoBase(prezzoBase);
            prog.setStato(stato);
            prog.setIdFilm(idFilm);
            prog.setIdSala(idSala);
            prog.setIdSlotOrario(idSlotOrario);
            prog.setIdTariffa(idTariffa);

            boolean result = programmazioneDAO.doUpdate(prog);

            connection.commit();
            return result;

        } catch (SQLException e) {
            rollback();
            throw new ModificaProgrammazioneException(e);
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                // Log error
            }
        }
    }

    public boolean eliminaProgrammazione(int idProgrammazione) {
        try {
            connection.setAutoCommit(false);


            //VERIFICA ESISTENZA PROGRAMMAZIONE
            Programmazione prog = programmazioneDAO.doRetrieveByKey(idProgrammazione);
            if (prog == null) {
                throw new ProgrammazioneNonTrovataException(idProgrammazione);
            }

            //GESTIONE RIMBORSI AUTOMATICI
            processaRimborsiAutomatici(idProgrammazione);

            // STEP 3: INVALIDAZIONE BIGLIETTI
            bigliettoDAO.doUpdateStatoByProgrammazione(idProgrammazione, "RIMBORSATO"); //bisogna avere un metodo per cambiare lo stato dei biglietti

            // STEP 4: LIBERAZIONE SLOT ORARIO
            SlotOrari slot = slotOrariDAO.doRetrieveByKey(prog.getIdSlotOrario());
            if (slot != null) {
                slot.libera(); // Cambia stato a DISPONIBILE
                slotOrariDAO.doUpdate(slot);
            }

            // SOFT DELETE PROGRAMMAZIONE
            boolean deleted = programmazioneDAO.doDelete(idProgrammazione);

            connection.commit();
            return deleted;

        } catch (SQLException e) {
            rollback();
            throw new EliminazioneProgrammazioneException(e);
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                // Log error
            }
        }
    }

    private void processaRimborsiAutomatici(int idProgrammazione)
            throws SQLException{

        // Recupera tutti i biglietti non ancora rimborsati
        List<Biglietto> biglietti = bigliettoDAO.doRetrieveByProgrammazione(
                idProgrammazione
        );

        for (Biglietto biglietto : biglietti) {
            // Salta biglietti già rimborsati
            if ("RIMBORSATO".equals(biglietto.getStato())) {
                continue;
            }

            // Recupera acquisto correlato
            Acquisto acquisto = acquistoDAO.doRetrieveById(
                    biglietto.getIdAcquisto(); //opp non lo so, si può pensare di mettere in Acquisto l'istanza Utente e fare qui acquisto.getUtente().getIdAccount()
            );

            if (acquisto != null) {
                // Incrementa saldo utente -- bisogna inserire un metodo che incrementi il saldo di un certo biglietto in base al biglietto considerato
                utenteDAO.doIncrementSaldo(acquisto.getIdAccount(), biglietto.getPrezzoFinale());

                // Aggiorna stato acquisto
                acquisto.setStato("RIMBORSATO");
                acquistoDAO.doUpdate(acquisto);
            }
        }
    }

    private double calcolaPrezzoTariffato(double prezzoBase, int idTariffa) {
        try {
            Tariffa tariffa = tariffaDAO.doRetrieveByKey(idTariffa);

            if (tariffa == null) {
                return prezzoBase; // Nessuna tariffa = prezzo pieno
            }

            return tariffa.applicaSconto(prezzoBase);

        } catch (SQLException e) {
            throw new CalcoloPrezzoTariffatoException(e);
        }
    }

    public Programmazione getProgrammazioneById(int id) {
        try {
            return programmazioneDAO.doRetrieveByKeyWithRelations(id);
        } catch (SQLException e) {
            throw new RecuperoProgrammazioniException(e);
        }
    }

    private void rollback() {
        try {
            connection.rollback();
        } catch (SQLException e) {
            // Log dell'errore di rollback
            System.err.println("ERRORE CRITICO: Rollback fallito - " + e.getMessage());
        }
    }
}
