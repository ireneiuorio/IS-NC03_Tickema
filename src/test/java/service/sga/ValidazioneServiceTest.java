package service.sga;

import entity.sga.Biglietto;
import entity.sgc.Film;
import entity.sgp.Programmazione;
import entity.sgu.Utente;
import exception.sga.acquisto.biglietto.BigliettoNonTrovatoException;
import exception.sga.acquisto.biglietto.BigliettoNonValidoException;
import exception.sga.validazione.AggiornamentoBigliettoException;
import exception.sga.validazione.DataValidazioneNonValidaException;
import exception.sga.validazione.StatoBigliettoNonValidoException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import repository.sga.BigliettoDAO;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Test Validazione Biglietto - Tickema")
class ValidazioneServiceTest {

    @Mock
    private Connection mockConnection;

    @Mock
    private BigliettoDAO mockBigliettoDAO;

    @Mock
    private BigliettoService mockBigliettoService;

    private ValidazioneService validazioneService;

    private static final String QR_CODE_VALIDO = "TKT-20250102123456-abc123de";
    private static final int ID_PERSONALE = 1;

    @BeforeEach
    void setUp() throws Exception {
        validazioneService = new ValidazioneService(mockConnection);

        // USA REFLECTION per iniettare i mock
        Field bigliettoDAOField = ValidazioneService.class.getDeclaredField("bigliettoDAO");
        bigliettoDAOField.setAccessible(true);
        bigliettoDAOField.set(validazioneService, mockBigliettoDAO);

        Field bigliettoServiceField = ValidazioneService.class.getDeclaredField("bigliettoService");
        bigliettoServiceField.setAccessible(true);
        bigliettoServiceField.set(validazioneService, mockBigliettoService);
    }

    // ========== METODI HELPER ==========

    private Biglietto creaBigliettoConStato(String stato, LocalDate dataProiezione) {
        Biglietto biglietto = new Biglietto();
        biglietto.setIdBiglietto(1);
        biglietto.setQRCode(QR_CODE_VALIDO);
        biglietto.setStato(stato);
        biglietto.setDataUtilizzo(null);

        // Programmazione
        Programmazione programmazione = new Programmazione();
        programmazione.setIdProgrammazione(1);
        programmazione.setDataProgrammazione(dataProiezione);

        Film film = new Film();
        film.setTitolo("Test Film");
        programmazione.setFilm(film);

        biglietto.setProgrammazione(programmazione);

        return biglietto;
    }

    // ========== TEST CASES ==========

    @Test
    @DisplayName("TC1_PER_1: QR code non valido (null o vuoto)")
    void testQrCodeNonValido() throws Exception {
        // Arrange
        String qrCodeNullo = null;
        when(mockBigliettoService.getBigliettoByQRCode(qrCodeNullo))
                .thenThrow(new BigliettoNonValidoException("QR Code non valido"));

        // Act & Assert
        assertThrows(BigliettoNonValidoException.class, () -> {
            validazioneService.validaBiglietto(qrCodeNullo, ID_PERSONALE);
        }, "Dovrebbe lanciare BigliettoNonValidoException per QR code nullo");

        verify(mockBigliettoDAO, never()).doUpdate(any());
    }

    @Test
    @DisplayName("TC1_PER_1 (variante): QR code con formato errato")
    void testQrCodeFormatoErrato() throws Exception {
        // Arrange
        String qrCodeErrato = "INVALID@#$%";
        when(mockBigliettoService.getBigliettoByQRCode(qrCodeErrato))
                .thenThrow(new BigliettoNonValidoException("QR Code non valido"));

        // Act & Assert
        assertThrows(BigliettoNonValidoException.class, () -> {
            validazioneService.validaBiglietto(qrCodeErrato, ID_PERSONALE);
        });

        verify(mockBigliettoDAO, never()).doUpdate(any());
    }

    @Test
    @DisplayName("TC2_PER_1: Biglietto non presente nel database")
    void testBigliettoNonTrovato() throws Exception {
        // Arrange
        String qrCodeInesistente = "TKT-99999999999999-notfound";
        when(mockBigliettoService.getBigliettoByQRCode(qrCodeInesistente))
                .thenThrow(new BigliettoNonTrovatoException(qrCodeInesistente));

        // Act & Assert
        BigliettoNonTrovatoException exception = assertThrows(
                BigliettoNonTrovatoException.class,
                () -> validazioneService.validaBiglietto(qrCodeInesistente, ID_PERSONALE),
                "Dovrebbe lanciare BigliettoNonTrovatoException"
        );

        assertTrue(exception.getMessage().contains(qrCodeInesistente));
        verify(mockBigliettoDAO, never()).doUpdate(any());
    }

    @Test
    @DisplayName("TC3_PER_1: Biglietto già validato")
    void testBigliettoGiaValidato() throws Exception {
        // Arrange
        Biglietto bigliettoValidato = creaBigliettoConStato("Validato", LocalDate.now());

        Utente personaleValidazione = new Utente();
        personaleValidazione.setNome("Mario");
        personaleValidazione.setCognome("Rossi");
        bigliettoValidato.setPersonaleValidazione(personaleValidazione);
        bigliettoValidato.setDataUtilizzo(LocalDateTime.now().minusHours(2));

        when(mockBigliettoService.getBigliettoByQRCode(QR_CODE_VALIDO))
                .thenReturn(bigliettoValidato);

        // Act & Assert
        StatoBigliettoNonValidoException exception = assertThrows(
                StatoBigliettoNonValidoException.class,
                () -> validazioneService.validaBiglietto(QR_CODE_VALIDO, ID_PERSONALE),
                "Accesso negato: biglietto già utilizzato"
        );

        assertTrue(exception.getMessage().contains("Validato") ||
                exception.getMessage().contains("già utilizzato"));
        verify(mockBigliettoDAO, never()).doUpdate(any());
    }

    @Test
    @DisplayName("TC4_PER_1: Biglietto rimborsato")
    void testBigliettoRimborsato() throws Exception {
        // Arrange
        Biglietto bigliettoRimborsato = creaBigliettoConStato("Rimborsato", LocalDate.now());

        when(mockBigliettoService.getBigliettoByQRCode(QR_CODE_VALIDO))
                .thenReturn(bigliettoRimborsato);

        // Act & Assert
        StatoBigliettoNonValidoException exception = assertThrows(
                StatoBigliettoNonValidoException.class,
                () -> validazioneService.validaBiglietto(QR_CODE_VALIDO, ID_PERSONALE),
                "Accesso negato: biglietto rimborsato"
        );

        assertTrue(exception.getMessage().contains("Rimborsato") ||
                exception.getMessage().contains("rimborsato"));
        verify(mockBigliettoDAO, never()).doUpdate(any());
    }

    @Test
    @DisplayName("TC5_PER_1: Biglietto scaduto")
    void testBigliettoScaduto() throws Exception {
        // Arrange
        Biglietto bigliettoScaduto = creaBigliettoConStato("Scaduto", LocalDate.now());

        when(mockBigliettoService.getBigliettoByQRCode(QR_CODE_VALIDO))
                .thenReturn(bigliettoScaduto);

        // Act & Assert
        StatoBigliettoNonValidoException exception = assertThrows(
                StatoBigliettoNonValidoException.class,
                () -> validazioneService.validaBiglietto(QR_CODE_VALIDO, ID_PERSONALE),
                "Accesso negato: biglietto scaduto"
        );

        assertTrue(exception.getMessage().contains("Scaduto") ||
                exception.getMessage().contains("scaduto"));
        verify(mockBigliettoDAO, never()).doUpdate(any());
    }

    @Test
    @DisplayName("TC6_PER_1: Data proiezione non corrisponde (data futura)")
    void testDataProiezioneNonValida() throws Exception {
        // Arrange
        LocalDate dataFutura = LocalDate.of(2025, 8, 15);
        Biglietto bigliettoDataFutura = creaBigliettoConStato("Emesso", dataFutura);

        when(mockBigliettoService.getBigliettoByQRCode(QR_CODE_VALIDO))
                .thenReturn(bigliettoDataFutura);

        // Act & Assert
        DataValidazioneNonValidaException exception = assertThrows(
                DataValidazioneNonValidaException.class,
                () -> validazioneService.validaBiglietto(QR_CODE_VALIDO, ID_PERSONALE),
                "Accesso negato: data proiezione non corrisponde"
        );

        assertTrue(exception.getMessage().contains("2025-08-15") ||
                exception.getMessage().contains("non ancora valido"));
        verify(mockBigliettoDAO, never()).doUpdate(any());
    }

    @Test
    @DisplayName("TC6_PER_1 (variante): Data proiezione passata")
    void testDataProiezionePassata() throws Exception {
        // Arrange
        LocalDate dataPassata = LocalDate.now().minusDays(5);
        Biglietto bigliettoDataPassata = creaBigliettoConStato("Emesso", dataPassata);

        when(mockBigliettoService.getBigliettoByQRCode(QR_CODE_VALIDO))
                .thenReturn(bigliettoDataPassata);

        // Act & Assert
        DataValidazioneNonValidaException exception = assertThrows(
                DataValidazioneNonValidaException.class,
                () -> validazioneService.validaBiglietto(QR_CODE_VALIDO, ID_PERSONALE),
                "Biglietto scaduto per data passata"
        );

        assertTrue(exception.getMessage().contains("scaduto") ||
                exception.getMessage().contains("Era valido"));
        verify(mockBigliettoDAO, never()).doUpdate(any());
    }

    @Test
    @DisplayName("TC7_PER_1: Validazione con successo")
    void testValidazioneConSuccesso() throws Exception {
        // Arrange
        Biglietto bigliettoValido = creaBigliettoConStato("Emesso", LocalDate.now());

        when(mockBigliettoService.getBigliettoByQRCode(QR_CODE_VALIDO))
                .thenReturn(bigliettoValido);

        when(mockBigliettoDAO.doUpdate(any(Biglietto.class)))
                .thenReturn(true);

        // Act
        boolean risultato = validazioneService.validaBiglietto(QR_CODE_VALIDO, ID_PERSONALE);

        // Assert
        assertTrue(risultato, "La validazione dovrebbe avere successo");

        assertEquals("Validato", bigliettoValido.getStato(),
                "Lo stato dovrebbe essere aggiornato a 'Validato'");

        assertNotNull(bigliettoValido.getDataUtilizzo(),
                "La data di utilizzo dovrebbe essere impostata");

        assertNotNull(bigliettoValido.getPersonaleValidazione(),
                "Il personale di validazione dovrebbe essere registrato");
        assertEquals(ID_PERSONALE, bigliettoValido.getPersonaleValidazione().getIdAccount());

        verify(mockBigliettoDAO, times(1)).doUpdate(bigliettoValido);
    }

    @Test
    @DisplayName("Test aggiuntivo: Errore durante aggiornamento database")
    void testErroreAggiornamentoDatabase() throws Exception {
        // Arrange
        Biglietto bigliettoValido = creaBigliettoConStato("Emesso", LocalDate.now());

        when(mockBigliettoService.getBigliettoByQRCode(QR_CODE_VALIDO))
                .thenReturn(bigliettoValido);

        when(mockBigliettoDAO.doUpdate(any(Biglietto.class)))
                .thenReturn(false);

        // Act & Assert
        AggiornamentoBigliettoException exception = assertThrows(
                AggiornamentoBigliettoException.class,
                () -> validazioneService.validaBiglietto(QR_CODE_VALIDO, ID_PERSONALE),
                "Dovrebbe lanciare AggiornamentoBigliettoException"
        );

        assertTrue(exception.getMessage().contains("aggiornamento") ||
                exception.getMessage().contains("Errore"));
    }
}