package exception.sga.acquisto;



//Eccezione lanciata quando un acquisto non viene trovato

public class AcquistoNonTrovatoException extends Exception {

  private final int idAcquisto;

  public AcquistoNonTrovatoException(int idAcquisto) {
    super("Acquisto con ID " + idAcquisto + " non trovato");
    this.idAcquisto = idAcquisto;
  }

  public AcquistoNonTrovatoException(int idAcquisto, Throwable cause) {
    super("Acquisto con ID " + idAcquisto + " non trovato", cause);
    this.idAcquisto = idAcquisto;
  }

  public int getIdAcquisto() {
    return idAcquisto;
  }
}
