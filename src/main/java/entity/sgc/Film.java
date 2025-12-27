package entity.sgc;

import java.util.Objects;

public class Film {
    private int idFilm;
    private String trama;
    private String titolo;
    private int anno;
    private String regista;
    private String genere;
    private int durata; // in minuti
    private String locandina; // path o URL dell'immagine

    public Film() {
    }

    public Film(int idFilm, String trama, String titolo, int anno, String regista,
                String genere, int durata, String locandina) {
        this.idFilm = idFilm;
        this.trama = trama;
        this.setTitolo(titolo);
        this.setAnno(anno);
        this.setRegista(regista);
        this.setGenere(genere);
        this.setDurata(durata);
        this.setLocandina(locandina);
    }

    // Getters e Setters
    public int getIdFilm() {
        return idFilm;
    }

    public void setIdFilm(int idFilm) {
        this.idFilm = idFilm;
    }

    public String getTrama() {
        return trama;
    }

    public void setTrama(String trama) {
        this.trama = trama;
    }

    public String getTitolo() {
        return titolo;
    }

    public void setTitolo(String titolo) {
        if (titolo == null || titolo.trim().isEmpty()) {
            throw new IllegalArgumentException("Il titolo del film è obbligatorio.");
        }
        this.titolo = titolo.trim();
    }

    public int getAnno() {
        return anno;
    }

    public void setAnno(int anno) {
        if (anno < 1888) { // Primo film della storia
            throw new IllegalArgumentException("L'anno del film non è valido.");
        }
        this.anno = anno;
    }

    public String getRegista() {
        return regista;
    }

    public void setRegista(String regista) {
        if (regista == null || regista.trim().isEmpty()) {
            throw new IllegalArgumentException("Il regista del film è obbligatorio.");
        }
        this.regista = regista.trim();
    }

    public String getGenere() {
        return genere;
    }

    public void setGenere(String genere) {
        if (genere == null || genere.trim().isEmpty()) {
            throw new IllegalArgumentException("Il genere del film è obbligatorio.");
        }
        this.genere = genere.trim();
    }

    public int getDurata() {
        return durata;
    }

    public void setDurata(int durata) {
        if (durata <= 0) {
            throw new IllegalArgumentException("La durata del film deve essere positiva.");
        }
        this.durata = durata;
    }

    public String getLocandina() {
        return locandina;
    }

    public void setLocandina(String locandina) {
        if (locandina == null || locandina.trim().isEmpty()) {
            throw new IllegalArgumentException("La locandina del film è obbligatoria.");
        }
        this.locandina = locandina.trim();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Film film = (Film) o;
        return idFilm == film.idFilm &&
                anno == film.anno &&
                durata == film.durata &&
                Objects.equals(titolo, film.titolo) &&
                Objects.equals(regista, film.regista);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idFilm, titolo, anno, regista, durata);
    }

    @Override
    public String toString() {
        return "Film{" +
                "idFilm=" + idFilm +
                ", titolo='" + titolo + '\'' +
                ", anno=" + anno +
                ", regista='" + regista + '\'' +
                ", genere='" + genere + '\'' +
                ", durata=" + durata +
                '}';
    }
}
