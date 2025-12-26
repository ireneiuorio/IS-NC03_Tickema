package service.sgp;

import entity.sgp.Posto;
import entity.sgp.Sala;
import exception.sgp.sala.*;
import repository.sgp.PostoDAO;
import repository.sgp.ProgrammazioneDAO;
import repository.sgp.SalaDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class SalaService {
    private Connection connection;
    private SalaDAO salaDAO;
    private PostoDAO postoDAO;
    private ProgrammazioneDAO programmazioneDAO;

    public SalaService(Connection connection) {
        this.connection = connection;
        this.salaDAO = new SalaDAO(connection);
        this.postoDAO = new PostoDAO(connection);
        this.programmazioneDAO = new ProgrammazioneDAO(connection);
    }

    public Sala creaSala(String nome, int numeroDiFile, int capienza, int numeroPostiPerFila) {

        try {
            // Inizio transazione atomica
            connection.setAutoCommit(false);

            // 1. Verifica unicità nome
            if (salaDAO.doCheckByNome(nome)) {
                throw new NomeSalaException(nome);
            }

            // 2. Verifica coerenza capienza
            int capienzaCalcolata = numeroDiFile * numeroPostiPerFila;
            if (capienza != capienzaCalcolata) {
                throw new CapienzaIncoerenteException();
            }


            Sala sala = new Sala();
            sala.setNome(nome);
            sala.setConfigurazione(numeroDiFile, numeroPostiPerFila);

            Sala result = salaDAO.doSave(sala);


            // GENERAZIONE POSTI AUTOMATICA
            List<Posto> posti = new ArrayList<>();

            for (int fila = 1; fila <= numeroDiFile; fila++) {
                for (int numeroPosto = 1; numeroPosto <= numeroPostiPerFila; numeroPosto++) {
                    Posto posto = new Posto();
                    posto.setFila(fila);
                    posto.setNumeroPosto(numeroPosto);
                    posto.setStato("DISPONIBILE");
                    posto.setIdSala(result.getIdSala());
                    // Nota: idProgrammazione sarà settato quando si crea una programmazione

                    posti.add(posto);
                }
            }

            // Batch insert per performance
            postoDAO.doSaveBatch(posti);

            connection.commit();
            return result;

        } catch (IllegalArgumentException | SQLException e) {
            rollback();
            throw new CreazioneSalaException(e);
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
            }
        }
    }


    public boolean modificaSala(int idSala, String nome, int numeroDiFile, int capienza, int numeroPostiPerFila
    ) {

        try {
            connection.setAutoCommit(false);

            // Recupera sala esistente
            Sala sala = salaDAO.doRetrieveByKey(idSala);
            if (sala == null) {
                throw new SalaNonTrovataException(idSala);
            }

            // Verifica coerenza capienza
            int capienzaCalcolata = numeroDiFile * numeroPostiPerFila;
            if (capienza != capienzaCalcolata) {
                throw new CapienzaIncoerenteException();
            }

            // Se cambia la configurazione, ricrea i posti
            boolean cambioConfigurazione =
                    (sala.getNumeroDiFile() != numeroDiFile) ||
                            (sala.getNumeroPostiPerFila() != numeroPostiPerFila);

            if (cambioConfigurazione) {
                // Verifica che non ci siano programmazioni attive
                // (questa è una semplificazione; in produzione serve logica più complessa)

                // Elimina vecchi posti
                postoDAO.doDeleteBySala(idSala);

                // Ricrea posti con nuova configurazione
                List<Posto> nuoviPosti = new ArrayList<>();
                for (int f = 1; f <= numeroDiFile; f++) {
                    for (int p = 1; p <= numeroPostiPerFila; p++) {
                        Posto posto = new Posto();
                        posto.setFila(f);
                        posto.setNumeroPosto(p);
                        posto.setStato("DISPONIBILE");
                        posto.setIdSala(idSala);
                        nuoviPosti.add(posto);
                    }
                }
                postoDAO.doSaveBatch(nuoviPosti);
            }

            // Aggiorna sala
            sala.setNome(nome);
            sala.setConfigurazione(numeroDiFile, numeroPostiPerFila);

            boolean result = salaDAO.doUpdate(sala);

            connection.commit();
            return result;

        } catch (SQLException | IllegalArgumentException e) {
            rollback();
            throw new ModificaSalaException(e);
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                // Log error
            }
        }
    }

    public Sala visualizzaDettagliSala(int idSala){
        try {
            return salaDAO.doRetrieveByKey(idSala);
        } catch (SQLException e) {
            throw new RecuperoDettagliException(e);
        }
    }

    public List<Sala> visualizzaTutteLeSale() {
        try {
            return salaDAO.doRetrieveAll();
        } catch (SQLException e) {
            throw new RecuperoSaleException(e);
        }
    }

    public List<Sala> getSaleDisponibili(LocalDate data, LocalTime oraInizio, int durataMinuti) {
        try {
            // Query complessa che verifica disponibilità slot per ogni sala
            // Per semplicità, restituiamo tutte le sale
            // In produzione, serve query che verifichi slot liberi
            return salaDAO.doRetrieveAll();
        } catch (SQLException e) {
            throw new CalcoloSaleDisponibiliException(e);
        }
    }

    private void rollback() {
        try {
            connection.rollback();
        } catch (SQLException e) {
            System.err.println("ERRORE ROLLBACK: " + e.getMessage());
        }
    }
}
