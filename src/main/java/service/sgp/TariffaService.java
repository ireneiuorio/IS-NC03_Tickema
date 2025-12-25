package service.sgp;

import entity.spg.Tariffa;
import exception.sgp.tariffa.*;
import repository.sgp.TariffaDAO;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

/**
 * Service che gestisce le tariffe
 * Si occupa di creare e gestire tariffe con sconti
 * Validare vincoli
 * calcolare prezzi su cui sono applicati tariffe
 */
public class TariffaService {
    private Connection connection;
    private TariffaDAO tariffaDAO;

    public TariffaService(Connection connection) {
        this.connection = connection;
        this.tariffaDAO = new TariffaDAO(connection);
    }

    public Tariffa creaTariffa(String tipo, String nome, int percentualeSconto) {

        try {
            // Validazione range percentuale
            if (percentualeSconto < 0 || percentualeSconto > 100) {
                throw new PercentualeScontoNonValidaException();
            }

            Tariffa tariffa = new Tariffa();
            tariffa.setTipo(tipo);
            tariffa.setNome(nome);
            tariffa.setPercentualeSconto(new BigDecimal(percentualeSconto));

            return tariffaDAO.doSave(tariffa);

        } catch (SQLException | IllegalArgumentException e) {
            throw new CreazioneTariffaException(e);
        }
    }

    public boolean modificaTariffa(int idTariffa, String tipo, String nome, int percentualeSconto) {
        try {
            Tariffa tariffa = tariffaDAO.doRetrieveByKey(idTariffa);
            if (tariffa == null) {
                throw new TariffaNonTrovataException(idTariffa);
            }

            // Validazione
            if (percentualeSconto < 0 || percentualeSconto > 100) {
                throw new PercentualeScontoNonValidaException();
            }

            tariffa.setTipo(tipo);
            tariffa.setNome(nome);
            tariffa.setPercentualeSconto(new BigDecimal(percentualeSconto));

            return tariffaDAO.doUpdate(tariffa);

        } catch (SQLException | IllegalArgumentException e) {
            throw new ModificaTariffaException(e);
        }
    }

    public List<Tariffa> visualizzaTariffe() {
        try {
            return tariffaDAO.doRetrieveAll();
        } catch (SQLException e) {
            throw new RecuperoTariffeException(e);
        }
    }

    public Tariffa getTariffaById(int idTariffa){
        try {
            return tariffaDAO.doRetrieveByKey(idTariffa);
        } catch (SQLException e) {
            throw new RecuperoTariffeException(e);
        }
    }

    public BigDecimal applicaSconto(BigDecimal prezzoBase, int idTariffa) {
        try {
            Tariffa tariffa = tariffaDAO.doRetrieveByKey(idTariffa);

            if (tariffa == null) {
                return prezzoBase; // Nessuna tariffa = prezzo pieno
            }

            return tariffa.applicaSconto(prezzoBase);

        } catch (SQLException e) {
            throw new CalcoloPrezzoScontatoException(e);
        }
    }
}
