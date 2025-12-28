package SGC.CLASSI;

import SGC.CLASSI.Film;
import SGC.CLASSI.FilmNonTrovatoException;
import SGC.DAO.FilmDAO;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Service Layer per la gestione del catalogo film.
 * Implementa il Facade Pattern, coordinando la logica business
 * e astraendo la complessità del layer di persistenza.
 */
public class FilmService {

    private FilmDAO filmDAO;

    /**
     * Costruttore che inietta le dipendenze necessarie.
     * @param filmDAO Data Access Object per i film
     */
    public FilmService(FilmDAO filmDAO) {
        this.filmDAO = filmDAO;
    }

    /**
     * Recupera l'intero catalogo di film disponibili.
     * @return Lista di tutti i film nel catalogo
     */
    public List<Film> visualizzaCatalogoFilm() {
        return filmDAO.findAll();
    }

    /**
     * Recupera i dettagli di un film specifico.
     * @param idFilm ID del film da visualizzare
     * @return Film richiesto
     * @throws FilmNonTrovatoException se il film non esiste
     */
    public Film visualizzaDettagliFilm(int idFilm) throws FilmNonTrovatoException {
        Film film = filmDAO.findById(idFilm);

        if (film == null) {
            throw new FilmNonTrovatoException(idFilm);
        }

        return film;
    }

    /**
     * Cerca film nel catalogo applicando filtri multipli.
     * Tutti i parametri sono opzionali (null = nessun filtro su quel campo).
     *
     * @param titolo Titolo o parte del titolo da cercare
     * @param genere Genere del film
     * @param anno Anno di uscita
     * @param durataMinuti Durata in minuti (non implementato in questa versione)
     * @param dataProiezione Data proiezione (non implementato - richiede ProgrammazioneService)
     * @param soloInProgrammazione Filtra solo film in programmazione (non implementato)
     * @return Lista di film che corrispondono ai criteri di ricerca
     */
    public List<Film> cercaFilm(String titolo, String genere, Integer anno,
                                Integer durataMinuti, LocalDate dataProiezione,
                                Boolean soloInProgrammazione) {

        // Inizia con tutti i film
        List<Film> risultati = filmDAO.findAll();

        // Applica filtro titolo
        if (titolo != null && !titolo.trim().isEmpty()) {
            risultati = filmDAO.searchByTitle(titolo);
        }

        // Applica filtro genere
        if (genere != null && !genere.trim().isEmpty()) {
            risultati = risultati.stream()
                    .filter(f -> f.genere().equalsIgnoreCase(genere))
                    .collect(Collectors.toList());
        }

        // Applica filtro anno
        if (anno != null) {
            risultati = risultati.stream()
                    .filter(f -> f.getAnno() == anno)
                    .collect(Collectors.toList());
        }

        // Applica filtro durata (opzionale)
        if (durataMinuti != null) {
            risultati = risultati.stream()
                    .filter(f -> f.getDurata() <= durataMinuti)
                    .collect(Collectors.toList());
        }

        // NOTA: I filtri dataProiezione e soloInProgrammazione richiedono
        // l'integrazione con ProgrammazioneService (gestito da SGP)
        // e verranno implementati quando i due sottosistemi saranno integrati.

        return risultati;
    }

    /**
     * Aggiunge un nuovo film al catalogo.
     * Metodo riservato agli amministratori.
     *
     * @param titolo Titolo del film
     * @param regista Nome del regista
     * @param genere Genere cinematografico
     * @param durataMinuti Durata in minuti
     * @param anno Anno di uscita
     * @param trama Sinossi del film
     * @param locandina Path o URL della locandina
     * @return Film creato con ID generato
     * @throws IllegalArgumentException se i parametri obbligatori sono vuoti
     */
    public Film aggiungiFilm(String titolo, String regista, String genere,
                             int durataMinuti, int anno, String trama,
                             String locandina) {

        // Validazione input
        validaParametriFilm(titolo, regista, genere, durataMinuti, anno);

        // Crea nuovo film
        Film nuovoFilm = new Film(trama, titolo, anno, regista, genere,
                durataMinuti, locandina);

        // Salva nel database
        boolean salvato = filmDAO.save(nuovoFilm);

        if (!salvato) {
            throw new RuntimeException("Errore durante il salvataggio del film");
        }

        return nuovoFilm;
    }

    /**
     * Modifica un film esistente nel catalogo.
     * Metodo riservato agli amministratori.
     *
     * @param idFilm ID del film da modificare
     * @param titolo Nuovo titolo
     * @param regista Nuovo regista
     * @param genere Nuovo genere
     * @param durataMinuti Nuova durata
     * @param anno Nuovo anno
     * @param trama Nuova trama
     * @param locandina Nuova locandina
     * @return true se la modifica è avvenuta con successo
     * @throws FilmNonTrovatoException se il film non esiste
     */
    public boolean modificaFilm(int idFilm, String titolo, String regista,
                                String genere, int durataMinuti, int anno,
                                String trama, String locandina)
            throws FilmNonTrovatoException {

        // Verifica esistenza film
        Film filmEsistente = visualizzaDettagliFilm(idFilm);

        // Validazione input
        validaParametriFilm(titolo, regista, genere, durataMinuti, anno);

        // Aggiorna campi
        filmEsistente.setTitolo(titolo);
        filmEsistente.setRegista(regista);
        filmEsistente.setGenere(genere);
        filmEsistente.setDurata(durataMinuti);
        filmEsistente.setAnno(anno);
        filmEsistente.setTrama(trama);
        filmEsistente.setLocandina(locandina);

        // Salva modifiche
        return filmDAO.update(filmEsistente);
    }

    /**
     * Elimina un film dal catalogo.
     * Metodo riservato agli amministratori.
     * ATTENZIONE: Verificare che non ci siano programmazioni associate.
     *
     * @param idFilm ID del film da eliminare
     * @return true se l'eliminazione è avvenuta con successo
     * @throws FilmNonTrovatoException se il film non esiste
     */
    public boolean eliminaFilm(int idFilm) throws FilmNonTrovatoException {

        // Verifica esistenza
        visualizzaDettagliFilm(idFilm);

        // NOTA: In un sistema completo, qui dovremmo verificare
        // che non esistano programmazioni attive per questo film
        // (richiede integrazione con ProgrammazioneService)

        return filmDAO.delete(idFilm);
    }

    /**
     * Metodo helper privato per validare i parametri comuni dei film.
     * @throws IllegalArgumentException se i parametri non sono validi
     */
    private void validaParametriFilm(String titolo, String regista, String genere,
                                     int durataMinuti, int anno) {

        if (titolo == null || titolo.trim().isEmpty()) {
            throw new IllegalArgumentException("Il titolo del film è obbligatorio");
        }

        if (regista == null || regista.trim().isEmpty()) {
            throw new IllegalArgumentException("Il regista è obbligatorio");
        }

        if (genere == null || genere.trim().isEmpty()) {
            throw new IllegalArgumentException("Il genere è obbligatorio");
        }

        if (durataMinuti <= 0) {
            throw new IllegalArgumentException("La durata deve essere maggiore di zero");
        }

        if (anno < 1895 || anno > LocalDate.now().getYear() + 2) {
            throw new IllegalArgumentException("Anno non valido");
        }
    }
}