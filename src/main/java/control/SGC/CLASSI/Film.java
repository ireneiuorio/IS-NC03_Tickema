package control.SGC.CLASSI;

    public class Film {
        private int idFilm;
        private String trama;
        private String titolo;
        private int anno;
        private String regista;
        private String genere;
        private int durata; // in minuti
        private String locandina; // path/URL dell'immagine

        // Costruttore vuoto
        public Film() {
        }

        // Costruttore completo (senza ID - per insert)
        public Film(String trama, String titolo, int anno, String regista,
                    String genere, int durata, String locandina) {
            this.trama = trama;
            this.titolo = titolo;
            this.anno = anno;
            this.regista = regista;
            this.genere = genere;
            this.durata = durata;
            this.locandina = locandina;
        }

        // Costruttore completo (con ID - per select dal DB)
        public Film(int idFilm, String trama, String titolo, int anno, String regista,
                    String genere, int durata, String locandina) {
            this.idFilm = idFilm;
            this.trama = trama;
            this.titolo = titolo;
            this.anno = anno;
            this.regista = regista;
            this.genere = genere;
            this.durata = durata;
            this.locandina = locandina;
        }

        // Getter e Setter
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
            this.titolo = titolo;
        }

        public int getAnno() {
            return anno;
        }

        public void setAnno(int anno) {
            this.anno = anno;
        }

        public String getRegista() {
            return regista;
        }

        public void setRegista(String regista) {
            this.regista = regista;
        }

        public String genere() {
            return genere;
        }

        public void setGenere(String genere) {
            this.genere = genere;
        }

        public int getDurata() {
            return durata;
        }

        public void setDurata(int durata) {
            this.durata = durata;
        }

        public String getLocandina() {
            return locandina;
        }

        public void setLocandina(String locandina) {
            this.locandina = locandina;
        }

        @Override
        public String toString() {
            return getClass().getName() +
                    "idFilm=" + idFilm +
                    ", titolo='" + titolo + '\'' +
                    ", anno=" + anno +
                    ", regista='" + regista + '\'' +
                    ", genere='" + genere + '\'' +
                    ", durata=" + durata +
                    '}';
        }
    }
