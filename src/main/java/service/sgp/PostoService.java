package service.sgp;

import entity.sgp.Posto;
import entity.sgp.Programmazione;
import entity.sgp.Sala;
import exception.sgp.posto.*;
import exception.sgp.programmazione.ProgrammazioneNonTrovataException;
import exception.sgp.sala.SalaNonTrovataException;
import repository.sgp.PostoDAO;
import repository.sgp.ProgrammazioneDAO;
import repository.sgp.SalaDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

public class PostoService {
    private Connection connection;
    private PostoDAO postoDAO;
    private ProgrammazioneDAO programmazioneDAO;
    private SalaDAO salaDAO;

    public PostoService(Connection connection) {
        this.connection = connection;
        this.postoDAO = new PostoDAO(connection);
        this.programmazioneDAO = new ProgrammazioneDAO(connection);
        this.salaDAO = new SalaDAO(connection);
    }

    public List<Posto> getPostiDisponibili(int idProgrammazione) {
        try {
            return postoDAO.doRetrieveDisponibili(idProgrammazione);
        } catch (SQLException e) {
            throw new RecuperoPostiDisponibiliException(e);
        }
    }

    public int contaPostiDisponibili(int idProgrammazione) {
        try {
            return postoDAO.doCountDisponibili(idProgrammazione);
        } catch (SQLException e) {
            throw new ConteggioPostiException(e);
        }
    }

    public List<Posto> getPostiPerSala(int idSala, int idProgrammazione) {
        try {
            return postoDAO.doRetrieveBySalaAndProgrammazione(idSala, idProgrammazione);
        } catch (SQLException e) {
            throw new RecuperoPostiSalaException(e);
        }
    }

    public List<Posto> verificaDisponibilitaPosti(
            int idProgrammazione,
            int numeroBiglietti
    ) throws SQLException, IllegalStateException {

        // Validazione input
        if (numeroBiglietti <= 0) {
            throw new IllegalArgumentException(
                    "Il numero di biglietti deve essere maggiore di zero"
            );
        }

        // Verifica esistenza programmazione
        Programmazione prog = programmazioneDAO.doRetrieveByKey(idProgrammazione);
        if (prog == null) {
            throw new IllegalStateException(
                    "Programmazione non trovata con ID: " + idProgrammazione
            );
        }

        // Verifica stato programmazione
        if (!"Disponibile".equals(prog.getStato())) {
            throw new IllegalStateException(
                    "La programmazione non è disponibile per l'acquisto. Stato: " +
                            prog.getStato()
            );
        }

        // Recupera posti disponibili
        List<Posto> postiDisponibili = postoDAO.doRetrieveDisponibili(idProgrammazione);

        // Verifica se ci sono abbastanza posti
        if (postiDisponibili.size() < numeroBiglietti) {
            return new ArrayList<>(); // Posti insufficienti
        }

        return postiDisponibili;
    }

    public boolean verificaDisponibilitaPosto(int idPosto, int idProgrammazione)
            throws SQLException {
        Posto posto = postoDAO.doRetrieveByKey(idPosto);

        if (posto == null) {
            return false;
        }

        return posto.getIdProgrammazione() == idProgrammazione &&
                posto.isDisponibile();
    }

    public RisultatoAssegnazione assegnaPostiAutomatico(
            List<Posto> postiDisponibili,
            int numeroPostiDaAssegnare
    ) throws IllegalStateException {

        // Validazione input
        if (postiDisponibili == null || postiDisponibili.isEmpty()) {
            throw new IllegalStateException("Nessun posto disponibile");
        }

        if (numeroPostiDaAssegnare <= 0) {
            throw new IllegalArgumentException(
                    "Il numero di posti da assegnare deve essere positivo"
            );
        }

        if (postiDisponibili.size() < numeroPostiDaAssegnare) {
            throw new IllegalStateException(
                    String.format(
                            "Posti insufficienti. Richiesti: %d, Disponibili: %d",
                            numeroPostiDaAssegnare, postiDisponibili.size()
                    )
            );
        }

        // Caso speciale: un solo posto
        if (numeroPostiDaAssegnare == 1) {
            List<Posto> postoSingolo = new ArrayList<>();
            postoSingolo.add(postiDisponibili.get(0));

            return new RisultatoAssegnazione(
                    postoSingolo,
                    true, // Adiacenza N/A per singolo posto
                    "Assegnato posto singolo: " + postiDisponibili.get(0).getIdentificatore()
            );
        }

        // Ordina i posti per fila e numero
        List<Posto> postiOrdinati = postiDisponibili.stream()
                .sorted(Comparator.comparingInt(Posto::getFila)
                        .thenComparingInt(Posto::getNumeroPosto))
                .collect(Collectors.toList());

        // Cerca gruppo di posti adiacenti
        List<Posto> gruppoAdiacente = cercaGruppoAdiacente(
                postiOrdinati,
                numeroPostiDaAssegnare
        );

        if (gruppoAdiacente != null && gruppoAdiacente.size() == numeroPostiDaAssegnare) {
            // Trovato gruppo completamente adiacente!
            return new RisultatoAssegnazione(
                    gruppoAdiacente,
                    true,
                    String.format(
                            "Assegnati %d posti adiacenti: %s",
                            numeroPostiDaAssegnare,
                            formatListaPosti(gruppoAdiacente)
                    )
            );
        }

        // STEP 2: Cerca più gruppi parziali
        List<Posto> postiAssegnati = cercaGruppiParziali(
                postiOrdinati,
                numeroPostiDaAssegnare
        );

        boolean vicinanzaGarantita = calcolaPercentualeAdiacenza(postiAssegnati) >= 0.8;

        return new RisultatoAssegnazione(
                postiAssegnati,
                vicinanzaGarantita,
                String.format(
                        "Assegnati %d posti con vicinanza parziale: %s",
                        numeroPostiDaAssegnare,
                        formatListaPosti(postiAssegnati)
                )
        );
    }

    //Cerca un gruppo di posti completamente adiacenti
    private List<Posto> cercaGruppoAdiacente(List<Posto> posti, int dimensione) {

        for (int i = 0; i <= posti.size() - dimensione; i++) {
            List<Posto> candidati = new ArrayList<>();
            candidati.add(posti.get(i));

            // Verifica se i posti successivi sono adiacenti
            for (int j = 1; j < dimensione; j++) {
                Posto precedente = candidati.get(j - 1);
                Posto corrente = posti.get(i + j);

                // Sono adiacenti se: stessa fila E numeri consecutivi
                if (precedente.getFila() == corrente.getFila() &&
                        corrente.getNumeroPosto() == precedente.getNumeroPosto() + 1) {
                    candidati.add(corrente);
                } else {
                    break; // Catena spezzata
                }
            }

            // Se ho trovato tutti i posti adiacenti, ritorna il gruppo
            if (candidati.size() == dimensione) {
                return candidati;
            }
        }

        return null; // Nessun gruppo completamente adiacente
    }

    private List<Posto> cercaGruppiParziali(List<Posto> posti, int totale) {

        List<Posto> risultato = new ArrayList<>();
        List<Posto> rimanenti = new ArrayList<>(posti);

        while (risultato.size() < totale && !rimanenti.isEmpty()) {

            // Cerca il gruppo più grande possibile
            List<Posto> gruppoMigliore = null;
            int dimensioneMigliore = 0;

            for (int start = 0; start < rimanenti.size(); start++) {
                List<Posto> gruppo = new ArrayList<>();
                gruppo.add(rimanenti.get(start));

                // Espandi il gruppo finché possibile
                for (int i = start + 1; i < rimanenti.size(); i++) {
                    Posto ultimo = gruppo.get(gruppo.size() - 1);
                    Posto corrente = rimanenti.get(i);

                    if (ultimo.getFila() == corrente.getFila() &&
                            corrente.getNumeroPosto() == ultimo.getNumeroPosto() + 1) {
                        gruppo.add(corrente);
                    } else {
                        break;
                    }
                }

                // Se questo gruppo è il migliore finora, salvalo
                if (gruppo.size() > dimensioneMigliore) {
                    gruppoMigliore = gruppo;
                    dimensioneMigliore = gruppo.size();
                }
            }

            // Aggiungi il gruppo migliore trovato
            if (gruppoMigliore != null) {
                int daAggiungere = Math.min(
                        gruppoMigliore.size(),
                        totale - risultato.size()
                );

                for (int i = 0; i < daAggiungere; i++) {
                    risultato.add(gruppoMigliore.get(i));
                    rimanenti.remove(gruppoMigliore.get(i));
                }
            } else {
                // Nessun gruppo trovato, prendi il primo disponibile
                risultato.add(rimanenti.remove(0));
            }
        }

        return risultato;
    }

    //Calcola la percentuale di posti adiacenti in un gruppo
    private double calcolaPercentualeAdiacenza(List<Posto> posti) {
        if (posti.size() <= 1) {
            return 1.0;
        }

        int coppieAdiacenti = 0;
        int totaliCoppie = posti.size() - 1;

        List<Posto> ordinati = posti.stream()
                .sorted(Comparator.comparingInt(Posto::getFila)
                        .thenComparingInt(Posto::getNumeroPosto))
                .collect(Collectors.toList());

        for (int i = 0; i < ordinati.size() - 1; i++) {
            Posto p1 = ordinati.get(i);
            Posto p2 = ordinati.get(i + 1);

            if (p1.getFila() == p2.getFila() &&
                    p2.getNumeroPosto() == p1.getNumeroPosto() + 1) {
                coppieAdiacenti++;
            }
        }

        return (double) coppieAdiacenti / totaliCoppie;
    }

    //Formatta una lista di posti in stringa leggibile
    private String formatListaPosti(List<Posto> posti) {
        return posti.stream()
                .map(Posto::getIdentificatore)
                .collect(Collectors.joining(", "));
    }

    public void assegnaPosti(List<Posto> posti, int idAcquisto) {

        try {
            connection.setAutoCommit(false);

            for (Posto posto : posti) {
                // Verifica che il posto sia ancora disponibile
                Posto postoAttuale = postoDAO.doRetrieveByKey(posto.getIdPosto());

                if (postoAttuale == null || !postoAttuale.isDisponibile()) {
                    throw new NessunPostoDisponibileException();
                }

                // Marca come occupato
                postoAttuale.occupa();
                postoDAO.doUpdate(postoAttuale);
            }

            connection.commit();

        } catch (SQLException e) {
            rollback();
            throw new AssegnazionePostiException(e);
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                // Log error
            }
        }
    }

    //Libera i posti (annullamento acquisto o timeout prenotazione)

    public void liberaPosti(List<Integer> idPosti, int idProgrammazione) {

        try {
            connection.setAutoCommit(false);

            // Aggiorna stati in batch
            int aggiornati = postoDAO.doUpdateStatoBatch(idPosti, "DISPONIBILE");

            if (aggiornati != idPosti.size()) {
                throw new LiberazionePostiException();
            }

            connection.commit();

        } catch (SQLException e) {
            rollback();
            throw new LiberazionePostiException();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                // Log error
            }
        }
    }

    public void generaPostiPerProgrammazione(int idProgrammazione) {

        try {
            connection.setAutoCommit(false);

            // Recupera programmazione
            Programmazione prog = programmazioneDAO.doRetrieveByKey(idProgrammazione);
            if (prog == null) {
                throw new ProgrammazioneNonTrovataException(idProgrammazione);
            }

            // Recupera sala
            Sala sala = salaDAO.doRetrieveByKey(prog.getIdSala());
            if (sala == null) {
                throw new SalaNonTrovataException(prog.getIdSala());
            }

            // Genera tutti i posti della sala
            List<Posto> posti = new ArrayList<>();

            for (int fila = 1; fila <= sala.getNumeroDiFile(); fila++) {
                for (int numeroPosto = 1; numeroPosto <= sala.getNumeroPostiPerFila(); numeroPosto++) {

                    Posto posto = new Posto();
                    posto.setFila(fila);
                    posto.setNumeroPosto(numeroPosto);
                    posto.setStato("DISPONIBILE");
                    posto.setIdSala(prog.getIdSala());
                    posto.setIdProgrammazione(idProgrammazione);

                    posti.add(posto);
                }
            }

            // Salva in batch per performance
            postoDAO.doSaveBatch(posti);

            connection.commit();

        } catch (SQLException e) {
            rollback();
            throw new GenerazionePostiException(e);
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                // Log error
            }
        }
    }

    private void rollback() {
        try {
            connection.rollback();
        } catch (SQLException e) {
            System.err.println("ERRORE ROLLBACK: " + e.getMessage());
        }
    }

    //OCCUPA TEMPORANEAMENTE I POSTI per il checkout
    //Setta i posti OCCUPATO ma li salva in sessione per poterli liberare dopo

    public boolean occupaTemporaneamente(List<Posto> posti) {
        try {
            connection.setAutoCommit(false);

            for (Posto posto : posti) {
                // Verifica che sia ancora disponibile
                Posto postoAttuale = postoDAO.doRetrieveByKey(posto.getIdPosto());

                if (postoAttuale == null || !postoAttuale.isDisponibile()) {
                    connection.rollback();
                    return false; // Posto non più disponibile
                }

                // Occupa il posto
                postoAttuale.occupa();
                postoDAO.doUpdate(postoAttuale);
            }

            connection.commit();
            return true;

        } catch (SQLException e) {
            rollback();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                // Log error
            }
        }
    }

    //LIBERA I POSTI se l'utente non completa l'acquisto
    public void liberaPostiDaCheckout(List<Posto> posti) {
        try {
            connection.setAutoCommit(false);

            List<Integer> idPosti = posti.stream()
                    .map(Posto::getIdPosto)
                    .collect(Collectors.toList());

            // Riporta a DISPONIBILE usando il metodo esistente
            int aggiornati = postoDAO.doUpdateStatoBatch(idPosti, "DISPONIBILE");

            if (aggiornati != idPosti.size()) {
                throw new LiberazionePostiException();
            }

            connection.commit();

        } catch (SQLException e) {
            rollback();
            throw new LiberazionePostiException();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                // Log error
            }
        }
    }





}
