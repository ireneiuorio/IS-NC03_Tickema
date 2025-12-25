package service.sgp;

import entity.spg.SlotOrari;
import exception.sgp.slot.*;
import exception.sgp.tariffa.ModificaTariffaException;
import repository.sgp.ProgrammazioneDAO;
import repository.sgp.SlotOrariDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

/**
 * Service per la gestione degli slot orari
 * Questo service ha la responsabilità di creare e gestire gli orari, calcolare le disponibilità
 */
public class SlotOrariService {
    private Connection connection;
    private SlotOrariDAO slotOrariDAO;
    private ProgrammazioneDAO programmazioneDAO;

    public SlotOrariService(Connection connection) {
        this.connection = connection;
        this.slotOrariDAO = new SlotOrariDAO(connection);
        this.programmazioneDAO = new ProgrammazioneDAO(connection);
    }

    public SlotOrari creaSlotOrario(LocalTime oraInizio, LocalTime oraFine, String stato, LocalDate data) {
        try {
            // Validazione invariante: l'ora di fine deve essere dopo l'inizio
            if (oraFine.isBefore(oraInizio) || oraFine.equals(oraInizio)) {
                throw new OraFineViolataException();
            }

            SlotOrari slot = new SlotOrari();
            slot.setOraInizio(oraInizio);
            slot.setOraFine(oraFine);
            slot.setStato(stato);
            slot.setData(data);

            return slotOrariDAO.doSave(slot);

        } catch (SQLException | IllegalArgumentException e) {
            throw new CreazioneSlotException(e);
        }
    }

    public boolean modificaSlotOrario(int idSlot, LocalTime oraInizio, LocalTime oraFine, String stato, LocalDate data){
        try {
            SlotOrari slot = slotOrariDAO.doRetrieveByKey(idSlot);
            if (slot == null) {
                throw new SlotNonTrovatoException(idSlot);
            }

            // Validazione invariante
            if (oraFine.isBefore(oraInizio) || oraFine.equals(oraInizio)) {
                throw new OraFineViolataException();
            }

            slot.setOraInizio(oraInizio);
            slot.setOraFine(oraFine);
            slot.setStato(stato);
            slot.setData(data);

            return slotOrariDAO.doUpdate(slot);

        } catch (SQLException | IllegalArgumentException e) {
            throw new ModificaTariffaException(e);
        }
    }

    public boolean eliminaSlotOrario(int idSlot) {
        try {
            // Verifica che lo slot non sia occupato
            if (programmazioneDAO.doCheckBySlot(idSlot)) {
                throw new EliminazioneSlotException();
            }

            return slotOrariDAO.doDelete(idSlot);

        } catch (SQLException e) {
            throw new EliminazioneSlotException();
        }
    }

    public List<SlotOrari> visualizzaSlotDisponibili(int idSala, LocalDate data) {
        try {
            return slotOrariDAO.doRetrieveDisponibiliBySalaAndData(idSala, data);
        } catch (SQLException e) {
            throw new CalcoloSlotDisponibiliException(e);
        }
    }

/*
    public List<SlotOrari> getSlotDisponibili(int idSala, LocalDate data, int durataFilm){
        try {
            return slotOrariDAO.doRetrieveDisponibiliPerDurata(
                    idSala, data, durataFilm
            );
        } catch (SQLException e) {
            throw new RecuperoSlotCompatibiliException(e);
        }
    }
*/
    public SlotOrari getSlotOrarioById(int idSlot) {
        try {
            return slotOrariDAO.doRetrieveByKey(idSlot);
        } catch (SQLException e) {
            throw new RecuperoSlotCompatibiliException(e);
        }
    }
}


