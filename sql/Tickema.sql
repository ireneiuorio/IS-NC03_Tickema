DROP DATABASE IF EXISTS Tickema;
CREATE DATABASE Tickema;
USE Tickema;

-- Disabilita check chiavi esterne per popolamento veloce
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- 1. CREAZIONE TABELLE (Esattamente come da SDD)
-- ============================================================

CREATE TABLE UTENTE(
                       idAccount INT PRIMARY KEY AUTO_INCREMENT,
                       nome VARCHAR(32) NOT NULL,
                       cognome VARCHAR(32) NOT NULL,
                       numeroDiTelefono VARCHAR(32) NOT NULL,
                       password VARCHAR(255) NOT NULL,
                       email VARCHAR(100) NOT NULL UNIQUE,
                       saldo DECIMAL(10,2) DEFAULT 0.00,
                       tipoAccount VARCHAR(32) NOT NULL -- 'Admin', 'Utente', 'Personale'
);

CREATE TABLE FILM (
                      idFilm INT PRIMARY KEY AUTO_INCREMENT,
                      trama TEXT,
                      titolo VARCHAR(150) NOT NULL,
                      anno INT NOT NULL,
                      regista VARCHAR(255) NOT NULL,
                      genere VARCHAR(150) NOT NULL,
                      durata INT NOT NULL,
                      locandina VARCHAR(255) NOT NULL,
                      UNIQUE(titolo, anno, regista)
);

CREATE TABLE SALA (
                      idSala INT PRIMARY KEY AUTO_INCREMENT,
                      nome VARCHAR(50) NOT NULL UNIQUE,
                      numeroDiFile INT NOT NULL,
                      capienza INT NOT NULL,
                      numeroPostiPerFila INT NOT NULL
);

CREATE TABLE SLOTORARI (
                           idSlot INT PRIMARY KEY AUTO_INCREMENT,
                           oraInizio TIME NOT NULL,
                           oraFine TIME NOT NULL,
                           stato VARCHAR(32) NOT NULL,
                           data DATE NOT NULL
);

CREATE TABLE TARIFFA (
                         idTariffa INT PRIMARY KEY AUTO_INCREMENT,
                         tipo VARCHAR(32) NOT NULL,
                         nome VARCHAR(32),
                         percentualeSconto DECIMAL(5,2) NOT NULL
);

CREATE TABLE PROGRAMMAZIONE (
                                idProgrammazione INT PRIMARY KEY AUTO_INCREMENT,
                                dataProgrammazione DATE NOT NULL,
                                tipo VARCHAR(22),
                                prezzoBase DECIMAL(10,2) NOT NULL,
                                stato VARCHAR(22) NOT NULL,
                                idFilm INT NOT NULL,
                                idSala INT NOT NULL,
                                idTariffa INT,
                                idSlotOrario INT NOT NULL,
                                FOREIGN KEY (idFilm) REFERENCES FILM(idFilm) ON DELETE CASCADE,
                                FOREIGN KEY (idSala) REFERENCES SALA(idSala) ON DELETE CASCADE,
                                FOREIGN KEY (idTariffa) REFERENCES TARIFFA(idTariffa) ON DELETE SET NULL,
                                FOREIGN KEY (idSlotOrario) REFERENCES SLOTORARI(idSlot) ON DELETE CASCADE
);

CREATE TABLE POSTO (
                       idPosto INT PRIMARY KEY AUTO_INCREMENT,
                       stato VARCHAR(32) NOT NULL,
                       fila INT NOT NULL,
                       numeroPosto INT NOT NULL,
                       idProgrammazione INT NOT NULL,
                       idSala INT NOT NULL,
                       FOREIGN KEY (idProgrammazione) REFERENCES PROGRAMMAZIONE(idProgrammazione) ON DELETE CASCADE,
                       FOREIGN KEY (idSala) REFERENCES SALA(idSala) ON DELETE CASCADE,
                       UNIQUE (idProgrammazione, fila, numeroPosto)
);

CREATE TABLE ACQUISTO(
                         idAcquisto INT PRIMARY KEY AUTO_INCREMENT,
                         importoTotale DECIMAL(10,2) NOT NULL,
                         dataOraAcquisto DATETIME NOT NULL,
                         stato VARCHAR(22) NOT NULL,
                         numeroBiglietti INT NOT NULL,
                         idAccount INT NOT NULL,
                         FOREIGN KEY (idAccount) REFERENCES UTENTE(idAccount) ON DELETE CASCADE
);

CREATE TABLE PAGAMENTO (
                           idPagamento INT PRIMARY KEY AUTO_INCREMENT,
                           metodoPagamento VARCHAR(255) NOT NULL,
                           importo DECIMAL(10,2) NOT NULL,
                           dataOraPagamento DATETIME NOT NULL,
                           tipo VARCHAR(32) NOT NULL,
                           idAcquisto INT NOT NULL,
                           FOREIGN KEY (idAcquisto) REFERENCES ACQUISTO(idAcquisto) ON DELETE CASCADE
);

CREATE TABLE BIGLIETTO (
                           idBiglietto INT PRIMARY KEY AUTO_INCREMENT,
                           prezzoFinale DECIMAL(10,2) NOT NULL,
                           stato VARCHAR(22) NOT NULL,
                           QRCode VARCHAR(255) NOT NULL UNIQUE,
                           dataUtilizzo DATETIME,
                           idAcquisto INT NOT NULL,
                           idProgrammazione INT NOT NULL,
                           idPosto INT NOT NULL,
                           idPersonaleValidazione INT,
                           FOREIGN KEY (idAcquisto) REFERENCES ACQUISTO(idAcquisto) ON DELETE CASCADE,
                           FOREIGN KEY (idProgrammazione) REFERENCES PROGRAMMAZIONE(idProgrammazione) ON DELETE CASCADE,
                           FOREIGN KEY (idPosto) REFERENCES POSTO(idPosto) ON DELETE CASCADE,
                           FOREIGN KEY (idPersonaleValidazione) REFERENCES UTENTE(idAccount) ON DELETE SET NULL
);


-- ============================================================
-- 2. POPOLAMENTO MASSIVO (20 record per tabella)
-- ============================================================

-- 2.1 UTENTI (20 utenti diversificati)
INSERT INTO UTENTE (nome, cognome, numeroDiTelefono, password, email, saldo, tipoAccount) VALUES
                                                                                              ('Sara', 'Di Tella', '3330001111', 'admin123', 'admin@tickema.it', 0.00, 'Admin'),
                                                                                              ('Mario', 'Rossi', '3330002222', 'staff123', 'staff@tickema.it', 0.00, 'Personale'),
                                                                                              ('Giuseppe', 'Verdi', '3330003333', 'staff456', 'giuseppe.v@tickema.it', 0.00, 'Personale'),
                                                                                              ('Laura', 'Pascarella', '3331112233', 'user123', 'laura@studenti.unisa.it', 50.00, 'Utente'),
                                                                                              ('Irene', 'Iuorio', '3334445566', 'user123', 'irene@studenti.unisa.it', 12.50, 'Utente'),
                                                                                              ('Raffaella', 'Maurelli', '3337778899', 'user123', 'raffaella@studenti.unisa.it', 100.00, 'Utente'),
                                                                                              ('Alessandro', 'Magno', '3335556677', 'user123', 'alex@email.com', 5.00, 'Utente'),
                                                                                              ('Sofia', 'Loren', '3338889900', 'user123', 'sofia@email.com', 25.50, 'Utente'),
                                                                                              ('Francesco', 'Totti', '3331010101', 'user123', 'francesco@email.com', 20.00, 'Utente'),
                                                                                              ('Giulia', 'De Lellis', '3332020202', 'user123', 'giulia@email.com', 10.00, 'Utente'),
                                                                                              ('Marco', 'Bianchi', '3333030303', 'user123', 'marco.b@gmail.com', 0.00, 'Utente'),
                                                                                              ('Chiara', 'Ferragni', '3334040404', 'user123', 'chiara.f@gmail.com', 75.00, 'Utente'),
                                                                                              ('Luca', 'Argentero', '3335050505', 'user123', 'luca.a@outlook.it', 30.00, 'Utente'),
                                                                                              ('Valentina', 'Nappi', '3336060606', 'user123', 'valentina.n@libero.it', 15.00, 'Utente'),
                                                                                              ('Antonio', 'Banderas', '3337070707', 'user123', 'antonio.b@yahoo.it', 40.00, 'Utente'),
                                                                                              ('Francesca', 'Michielin', '3338080808', 'user123', 'francesca.m@gmail.com', 8.50, 'Utente'),
                                                                                              ('Davide', 'Oldani', '3339090909', 'user123', 'davide.o@hotmail.com', 60.00, 'Utente'),
                                                                                              ('Elisa', 'Toffoli', '3330101010', 'user123', 'elisa.t@studenti.unisa.it', 22.00, 'Utente'),
                                                                                              ('Roberto', 'Saviano', '3331111111', 'user123', 'roberto.s@email.it', 5.50, 'Utente'),
                                                                                              ('Paola', 'Cortellesi', '3332222222', 'user123', 'paola.c@gmail.com', 45.00, 'Utente');

-- 2.2 SALE (5 sale con caratteristiche diverse)
INSERT INTO SALA (nome, numeroDiFile, capienza, numeroPostiPerFila) VALUES
                                                                        ('Sala A - Grande', 10, 100, 10),
                                                                        ('Sala B - Media', 8, 64, 8),
                                                                        ('Sala C - Luxury', 5, 30, 6),
                                                                        ('Sala D - Premium', 12, 144, 12),
                                                                        ('Sala E - Piccola', 6, 36, 6);

-- 2.3 TARIFFE (6 tipologie)
INSERT INTO TARIFFA (tipo, nome, percentualeSconto) VALUES
                                                        ('Intero', 'Standard', 0.00),
                                                        ('Ridotto', 'Under 14', 20.00),
                                                        ('Ridotto', 'Over 65', 20.00),
                                                        ('Studenti', 'Sconto Unisa', 15.00),
                                                        ('Famiglia', 'Nucleo Familiare 4+', 25.00),
                                                        ('Disabili', 'Accompagnatore Gratuito', 50.00);

-- 2.4 FILM (20 film completi)
INSERT INTO FILM (trama, titolo, anno, regista, genere, durata, locandina) VALUES
                                                                               ('Paul Atreides si unisce a Chani e ai Fremen per vendicare la sua famiglia.', 'Dune - Parte Due', 2024, 'Denis Villeneuve', 'Fantascienza', 166, 'https://image.tmdb.org/t/p/w500/dune2.jpg'),
                                                                               ('La storia di J. Robert Oppenheimer e la bomba atomica.', 'Oppenheimer', 2023, 'Christopher Nolan', 'Biografico', 180, 'https://image.tmdb.org/t/p/w500/oppenheimer.jpg'),
                                                                               ('Nuove emozioni arrivano nella mente di Riley adolescente.', 'Inside Out 2', 2024, 'Kelsey Mann', 'Animazione', 96, 'https://image.tmdb.org/t/p/w500/insideout2.jpg'),
                                                                               ('Il guerriero dragone affronta una nuova minaccia spirituale.', 'Kung Fu Panda 4', 2024, 'Mike Mitchell', 'Animazione', 94, 'https://image.tmdb.org/t/p/w500/kungfupanda4.jpg'),
                                                                               ('Un film basato sul celebre videogioco Minecraft.', 'Minecraft: The Movie', 2025, 'Jared Hess', 'Avventura', 110, 'https://image.tmdb.org/t/p/w500/minecraft.jpg'),
                                                                               ('Ethan Hunt torna per una missione impossibile finale.', 'Mission: Impossible 8', 2025, 'Christopher McQuarrie', 'Azione', 160, 'https://image.tmdb.org/t/p/w500/mi8.jpg'),
                                                                               ('Il ritorno del Joker in un musical psicologico.', 'Joker: Folie à Deux', 2024, 'Todd Phillips', 'Drammatico', 138, 'https://image.tmdb.org/t/p/w500/joker2.jpg'),
                                                                               ('Lucio deve combattere nel Colosseo dopo anni.', 'Gladiator 2', 2024, 'Ridley Scott', 'Storico', 150, 'https://image.tmdb.org/t/p/w500/gladiator2.jpg'),
                                                                               ('Un clone usa la tecnologia per sopravvivere su un pianeta ghiacciato.', 'Mickey 17', 2025, 'Bong Joon-ho', 'Fantascienza', 139, 'https://image.tmdb.org/t/p/w500/mickey17.jpg'),
                                                                               ('Deadpool e Wolverine uniscono le forze nel MCU.', 'Deadpool & Wolverine', 2024, 'Shawn Levy', 'Azione', 120, 'https://image.tmdb.org/t/p/w500/deadpool3.jpg'),
                                                                               ('Il giovane leone Simba deve reclamare il suo regno.', 'Il Re Leone', 1994, 'Roger Allers, Rob Minkoff', 'Animazione', 88, 'https://image.tmdb.org/t/p/w500/lionking.jpg'),
                                                                               ('La saga della famiglia Corleone nella mafia americana.', 'Il Padrino', 1972, 'Francis Ford Coppola', 'Crime', 175, 'https://image.tmdb.org/t/p/w500/godfather.jpg'),
                                                                               ('I dinosauri tornano in vita grazie alla scienza.', 'Jurassic Park', 1993, 'Steven Spielberg', 'Avventura', 127, 'https://image.tmdb.org/t/p/w500/jurassicpark.jpg'),
                                                                               ('Un ladro entra nei sogni per rubare segreti aziendali.', 'Inception', 2010, 'Christopher Nolan', 'Fantascienza', 148, 'https://image.tmdb.org/t/p/w500/inception.jpg'),
                                                                               ('Storie intrecciate di gangster a Los Angeles.', 'Pulp Fiction', 1994, 'Quentin Tarantino', 'Crime', 154, 'https://image.tmdb.org/t/p/w500/pulpfiction.jpg'),
                                                                               ('Un marine paralizzato esplora il mondo alieno di Pandora.', 'Avatar', 2009, 'James Cameron', 'Fantascienza', 162, 'https://image.tmdb.org/t/p/w500/avatar.jpg'),
                                                                               ('Frodo deve distruggere l anello del potere a Mordor.', 'Il Signore degli Anelli: Il Ritorno del Re', 2003, 'Peter Jackson', 'Fantasy', 201, 'https://image.tmdb.org/t/p/w500/lotr.jpg'),
                                                                               ('Barbie lascia Barbieland per scoprire il mondo reale.', 'Barbie', 2023, 'Greta Gerwig', 'Commedia', 114, 'https://image.tmdb.org/t/p/w500/barbie.jpg'),
                                                                               ('Un concierge e un fattorino in un hotel leggendario.', 'Grand Budapest Hotel', 2014, 'Wes Anderson', 'Commedia', 99, 'https://image.tmdb.org/t/p/w500/budapest.jpg'),
                                                                               ('Chihiro deve salvare i suoi genitori nel mondo degli spiriti.', 'La Città Incantata', 2001, 'Hayao Miyazaki', 'Animazione', 125, 'https://image.tmdb.org/t/p/w500/spirited.jpg');

-- 2.5 SLOT ORARI (20 slot su 5 giorni)
INSERT INTO SLOTORARI (oraInizio, oraFine, stato, data) VALUES
-- 15 Ottobre 2025
('15:00:00', '17:00:00', 'Disponibile', '2025-10-15'),
('17:30:00', '20:00:00', 'Disponibile', '2025-10-15'),
('20:30:00', '23:00:00', 'Disponibile', '2025-10-15'),
('23:30:00', '02:00:00', 'Disponibile', '2025-10-15'),
-- 16 Ottobre 2025
('14:30:00', '17:00:00', 'Disponibile', '2025-10-16'),
('17:30:00', '19:30:00', 'Disponibile', '2025-10-16'),
('20:00:00', '22:30:00', 'Disponibile', '2025-10-16'),
('23:00:00', '01:30:00', 'Disponibile', '2025-10-16'),
-- 17 Ottobre 2025
('15:00:00', '17:30:00', 'Disponibile', '2025-10-17'),
('18:00:00', '20:30:00', 'Disponibile', '2025-10-17'),
('21:00:00', '23:30:00', 'Disponibile', '2025-10-17'),
('00:00:00', '02:30:00', 'Disponibile', '2025-10-17'),
-- 18 Ottobre 2025
('16:00:00', '18:00:00', 'Disponibile', '2025-10-18'),
('18:30:00', '21:00:00', 'Disponibile', '2025-10-18'),
('21:30:00', '00:00:00', 'Disponibile', '2025-10-18'),
('00:30:00', '03:00:00', 'Disponibile', '2025-10-18'),
-- 19 Ottobre 2025
('15:30:00', '18:00:00', 'Disponibile', '2025-10-19'),
('18:30:00', '21:00:00', 'Disponibile', '2025-10-19'),
('21:30:00', '00:00:00', 'Disponibile', '2025-10-19'),
('00:30:00', '03:00:00', 'Disponibile', '2025-10-19');

-- 2.6 PROGRAMMAZIONI (20 programmazioni varie)
INSERT INTO PROGRAMMAZIONE (dataProgrammazione, tipo, prezzoBase, stato, idFilm, idSala, idTariffa, idSlotOrario) VALUES
                                                                                                                      ('2025-10-15', '2D', 10.00, 'Disponibile', 1, 1, 1, 2),
                                                                                                                      ('2025-10-15', '3D', 12.00, 'Disponibile', 3, 2, 1, 1),
                                                                                                                      ('2025-10-15', '2D', 9.00, 'Disponibile', 6, 1, 1, 3),
                                                                                                                      ('2025-10-15', '2D', 8.50, 'Disponibile', 4, 3, 1, 1),
                                                                                                                      ('2025-10-16', '2D', 10.00, 'Disponibile', 7, 1, 1, 7),
                                                                                                                      ('2025-10-16', 'IMAX', 15.00, 'Disponibile', 2, 4, 1, 5),
                                                                                                                      ('2025-10-16', '2D', 8.00, 'Disponibile', 11, 2, 1, 6),
                                                                                                                      ('2025-10-16', '2D', 10.00, 'Disponibile', 12, 3, 1, 7),
                                                                                                                      ('2025-10-16', '2D', 9.50, 'Annullata', 5, 2, 1, 8),
                                                                                                                      ('2025-10-16', '2D', 10.00, 'Conclusa', 8, 1, 1, 5),
                                                                                                                      ('2025-10-17', '3D', 13.00, 'Disponibile', 10, 1, 1, 10),
                                                                                                                      ('2025-10-17', '2D', 9.00, 'Disponibile', 13, 2, 1, 9),
                                                                                                                      ('2025-10-17', 'IMAX', 16.00, 'Disponibile', 14, 4, 1, 11),
                                                                                                                      ('2025-10-17', '2D', 8.50, 'Disponibile', 18, 5, 1, 9),
                                                                                                                      ('2025-10-18', '2D', 12.00, 'Disponibile', 9, 3, 1, 14),
                                                                                                                      ('2025-10-18', '3D', 14.00, 'Disponibile', 16, 1, 1, 15),
                                                                                                                      ('2025-10-18', '2D', 10.50, 'Disponibile', 15, 2, 1, 13),
                                                                                                                      ('2025-10-19', '2D', 11.00, 'Disponibile', 17, 4, 1, 18),
                                                                                                                      ('2025-10-19', '2D', 9.00, 'Disponibile', 19, 5, 1, 17),
                                                                                                                      ('2025-10-19', 'IMAX', 17.00, 'Disponibile', 20, 1, 1, 19);

-- 2.7 POSTI (Generazione parziale per prime 3 programmazioni come esempio)
-- PROGRAMMAZIONE 1 (Dune - Sala A, 100 posti)
INSERT INTO POSTO (stato, fila, numeroPosto, idProgrammazione, idSala) VALUES
-- Fila 1 (parzialmente occupata)
('Occupato', 1, 1, 1, 1), ('Occupato', 1, 2, 1, 1), ('Disponibile', 1, 3, 1, 1), ('Disponibile', 1, 4, 1, 1),
('Disponibile', 1, 5, 1, 1), ('Disponibile', 1, 6, 1, 1), ('Disponibile', 1, 7, 1, 1), ('Disponibile', 1, 8, 1, 1),
('Disponibile', 1, 9, 1, 1), ('Disponibile', 1, 10, 1, 1),
-- Fila 2 (tutta disponibile)
('Disponibile', 2, 1, 1, 1), ('Disponibile', 2, 2, 1, 1), ('Disponibile', 2, 3, 1, 1), ('Disponibile', 2, 4, 1, 1),
('Disponibile', 2, 5, 1, 1), ('Disponibile', 2, 6, 1, 1), ('Disponibile', 2, 7, 1, 1), ('Disponibile', 2, 8, 1, 1),
('Disponibile', 2, 9, 1, 1), ('Disponibile', 2, 10, 1, 1),
-- Fila 3 (parzialmente occupata)
('Disponibile', 3, 1, 1, 1), ('Disponibile', 3, 2, 1, 1), ('Disponibile', 3, 3, 1, 1), ('Occupato', 3, 4, 1, 1),
('Occupato', 3, 5, 1, 1), ('Occupato', 3, 6, 1, 1), ('Disponibile', 3, 7, 1, 1), ('Disponibile', 3, 8, 1, 1),
('Disponibile', 3, 9, 1, 1), ('Disponibile', 3, 10, 1, 1);

-- PROGRAMMAZIONE 2 (Inside Out 2 - Sala B, 64 posti)
INSERT INTO POSTO (stato, fila, numeroPosto, idProgrammazione, idSala) VALUES
-- Fila 1
('Occupato', 1, 1, 2, 2), ('Occupato', 1, 2, 2, 2), ('Occupato', 1, 3, 2, 2), ('Disponibile', 1, 4, 2, 2),
('Disponibile', 1, 5, 2, 2), ('Disponibile', 1, 6, 2, 2), ('Disponibile', 1, 7, 2, 2), ('Disponibile', 1, 8, 2, 2),
-- Fila 2
('Disponibile', 2, 1, 2, 2), ('Disponibile', 2, 2, 2, 2), ('Disponibile', 2, 3, 2, 2), ('Disponibile', 2, 4, 2, 2),
('Disponibile', 2, 5, 2, 2), ('Disponibile', 2, 6, 2, 2), ('Disponibile', 2, 7, 2, 2), ('Disponibile', 2, 8, 2, 2);

-- PROGRAMMAZIONE 3 (Mission Impossible - Sala A)
INSERT INTO POSTO (stato, fila, numeroPosto, idProgrammazione, idSala) VALUES
-- Fila 1
('Disponibile', 1, 1, 3, 1), ('Disponibile', 1, 2, 3, 1), ('Disponibile', 1, 3, 3, 1), ('Disponibile', 1, 4, 3, 1),
('Occupato', 1, 5, 3, 1), ('Occupato', 1, 6, 3, 1), ('Disponibile', 1, 7, 3, 1), ('Disponibile', 1, 8, 3, 1),
('Disponibile', 1, 9, 3, 1), ('Disponibile', 1, 10, 3, 1);

-- 2.8 ACQUISTI (20 acquisti diversificati)
INSERT INTO ACQUISTO (importoTotale, dataOraAcquisto, stato, numeroBiglietti, idAccount) VALUES
                                                                                             (20.00, '2025-10-10 14:30:00', 'Completato', 2, 4),
                                                                                             (36.00, '2025-10-11 09:00:00', 'Completato', 3, 5),
                                                                                             (30.00, '2025-10-11 15:20:00', 'Completato', 3, 6),
                                                                                             (10.00, '2025-10-12 10:15:00', 'Completato', 1, 7),
                                                                                             (50.00, '2025-10-12 18:45:00', 'Completato', 5, 8),
                                                                                             (18.00, '2025-10-13 11:30:00', 'Completato', 2, 9),
                                                                                             (12.00, '2025-10-13 16:00:00', 'Completato', 1, 10),
                                                                                             (40.00, '2025-10-14 09:45:00', 'Completato', 4, 11),
                                                                                             (24.00, '2025-10-14 13:20:00', 'Completato', 2, 12),
                                                                                             (15.00, '2025-10-14 17:30:00', 'Completato', 1, 13),
                                                                                             (60.00, '2025-10-15 08:00:00', 'Completato', 6, 14),
                                                                                             (22.00, '2025-10-15 12:15:00', 'Completato', 2, 15),
                                                                                             (35.00, '2025-10-15 14:45:00', 'Rimborsato', 3, 16),
                                                                                             (10.00, '2025-10-16 10:30:00', 'Completato', 1, 17),
                                                                                             (48.00, '2025-10-16 15:00:00', 'Completato', 4, 18),
                                                                                             (26.00, '2025-10-16 19:20:00', 'Completato', 2, 19),
                                                                                             (12.00, '2025-10-17 11:00:00', 'Completato', 1, 20),
                                                                                             (55.00, '2025-10-17 14:30:00', 'Completato', 5, 4),
                                                                                             (30.00, '2025-10-17 18:45:00', 'Annullato', 3, 5),
                                                                                             (20.00, '2025-10-18 09:15:00', 'Completato', 2, 6);

-- 2.9 PAGAMENTI (20 pagamenti con modalità diverse)
INSERT INTO PAGAMENTO (metodoPagamento, importo, dataOraPagamento, tipo, idAcquisto) VALUES
                                                                                         ('Saldo Utente', 10.00, '2025-10-10 14:30:00', 'SALDO', 1),
                                                                                         ('Visa **** 8024', 35.00, '2025-10-15 14:45:00', 'CARTA', 13),
                                                                                         ('American Express **** 6420', 10.00, '2025-10-16 10:30:00', 'CARTA', 14),
                                                                                         ('Saldo Utente', 20.00, '2025-10-16 15:00:00', 'SALDO', 15),
                                                                                         ('Mastercard **** 9753', 28.00, '2025-10-16 15:00:00', 'CARTA', 15),
                                                                                         ('PayPal', 26.00, '2025-10-16 19:20:00', 'CARTA', 16),
                                                                                         ('Saldo Utente', 12.00, '2025-10-17 11:00:00', 'SALDO', 17),
                                                                                         ('Visa **** 1122', 55.00, '2025-10-17 14:30:00', 'CARTA', 18);

-- 2.10 BIGLIETTI (20 biglietti con stati diversi)
INSERT INTO BIGLIETTO (prezzoFinale, stato, QRCode, dataUtilizzo, idAcquisto, idProgrammazione, idPosto, idPersonaleValidazione) VALUES
                                                                                                                                     (10.00, 'Emesso', 'QR_TKT_001', NULL, 1, 1, 1, NULL),
                                                                                                                                     (10.00, 'Emesso', 'QR_TKT_002', NULL, 1, 1, 2, NULL),
                                                                                                                                     (12.00, 'Validato', 'QR_TKT_003', '2025-10-15 15:05:00', 2, 2, 31, 2),
                                                                                                                                     (12.00, 'Validato', 'QR_TKT_004', '2025-10-15 15:05:05', 2, 2, 32, 2),
                                                                                                                                     (12.00, 'Validato', 'QR_TKT_005', '2025-10-15 15:05:10', 2, 2, 33, 2),
                                                                                                                                     (10.00, 'Validato', 'QR_TKT_006', '2025-10-16 20:10:00', 3, 1, 23, 3),
                                                                                                                                     (10.00, 'Validato', 'QR_TKT_007', '2025-10-16 20:10:05', 3, 1, 24, 3),
                                                                                                                                     (10.00, 'Validato', 'QR_TKT_008', '2025-10-16 20:10:10', 3, 1, 25, 3),
                                                                                                                                     (10.00, 'Emesso', 'QR_TKT_009', NULL, 4, 3, 55, NULL),
                                                                                                                                     (10.00, 'Emesso', 'QR_TKT_010', NULL, 5, 11, 1, NULL),
                                                                                                                                     (10.00, 'Emesso', 'QR_TKT_011', NULL, 5, 11, 2, NULL),
                                                                                                                                     (10.00, 'Emesso', 'QR_TKT_012', NULL, 5, 11, 3, NULL),
                                                                                                                                     (10.00, 'Emesso', 'QR_TKT_013', NULL, 5, 11, 4, NULL),
                                                                                                                                     (10.00, 'Emesso', 'QR_TKT_014', NULL, 5, 11, 5, NULL),
                                                                                                                                     (9.00, 'Validato', 'QR_TKT_015', '2025-10-17 18:15:00', 6, 12, 1, 2),
                                                                                                                                     (9.00, 'Validato', 'QR_TKT_016', '2025-10-17 18:15:05', 6, 12, 2, 2),
                                                                                                                                     (12.00, 'Emesso', 'QR_TKT_017', NULL, 7, 2, 40, NULL),
                                                                                                                                     (10.00, 'Emesso', 'QR_TKT_018', NULL, 8, 7, 1, NULL),
                                                                                                                                     (10.00, 'Emesso', 'QR_TKT_019', NULL, 8, 7, 2, NULL),
                                                                                                                                     (10.00, 'Emesso', 'QR_TKT_020', NULL, 8, 7, 3, NULL);

-- Riattiva check chiavi esterne
SET FOREIGN_KEY_CHECKS = 1;
