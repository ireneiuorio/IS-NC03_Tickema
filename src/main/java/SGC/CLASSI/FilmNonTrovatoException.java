package SGC.CLASSI;
/**
     * Eccezione sollevata quando un film richiesto non viene trovato nel sistema.
     * Questa è un'eccezione checked che deve essere gestita esplicitamente.
     */
    public class FilmNonTrovatoException extends Exception {

        private int idFilm;

        /**
         * Costruttore con messaggio personalizzato.
         * @param messaggio Descrizione dell'errore
         */
        public FilmNonTrovatoException(String messaggio) {
            super(messaggio);
        }

        /**
         * Costruttore con ID del film non trovato.
         * @param idFilm ID del film che non è stato trovato
         */
        public FilmNonTrovatoException(int idFilm) {
            super("Film con ID " + idFilm + " non trovato nel catalogo");
            this.idFilm = idFilm;
        }

        /**
         * Costruttore con messaggio e causa.
         * @param messaggio Descrizione dell'errore
         * @param causa Eccezione che ha causato questo errore
         */
        public FilmNonTrovatoException(String messaggio, Throwable causa) {
            super(messaggio, causa);
        }

        /**
         * Ritorna l'ID del film non trovato.
         * @return ID del film o -1 se non specificato
         */
        public int getIdFilm() {
            return idFilm;
        }
    }
