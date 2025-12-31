DROP DATABASE IF EXISTS Tickema;
CREATE DATABASE Tickema;
USE Tickema;

-- Disabilita check chiavi esterne per popolamento veloce
SET FOREIGN_KEY_CHECKS = 0;
--
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
-- 2. POPOLAMENTO MASSIVO (20 record per tabella) PASSWORD DI TUTTI: Tickema12%
-- ============================================================

INSERT INTO UTENTE (nome, cognome, numeroDiTelefono, password, email, saldo, tipoAccount) VALUES
                                                                                              ('Sara', 'Di Tella', '3330001111', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'admin@tickema.it', 0.00, 'Admin'),
                                                                                              ('Mario', 'Rossi', '3330002222', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'staff@tickema.it', 0.00, 'Personale'),
                                                                                              ('Giuseppe', 'Verdi', '3330003333', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'giuseppe.v@tickema.it', 0.00, 'Personale'),
                                                                                              ('Laura', 'Pascarella', '3331112233', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'laura@studenti.unisa.it', 50.00, 'Utente'),
                                                                                              ('Irene', 'Iuorio', '3334445566', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'irene@studenti.unisa.it', 12.50, 'Utente'),
                                                                                              ('Raffaella', 'Maurelli', '3337778899', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'raffaella@studenti.unisa.it', 100.00, 'Utente'),
                                                                                              ('Alessandro', 'Magno', '3335556677', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'alex@email.com', 5.00, 'Utente'),
                                                                                              ('Sofia', 'Loren', '3338889900', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'sofia@email.com', 25.50, 'Utente'),
                                                                                              ('Francesco', 'Totti', '3331010101', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'francesco@email.com', 20.00, 'Utente'),
                                                                                              ('Giulia', 'De Lellis', '3332020202', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'giulia@email.com', 10.00, 'Utente'),
                                                                                              ('Marco', 'Bianchi', '3333030303', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'marco.b@gmail.com', 0.00, 'Utente'),
                                                                                              ('Chiara', 'Ferragni', '3334040404', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'chiara.f@gmail.com', 75.00, 'Utente'),
                                                                                              ('Luca', 'Argentero', '3335050505', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'luca.a@outlook.it', 30.00, 'Utente'),
                                                                                              ('Valentina', 'Nappi', '3336060606', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'valentina.n@libero.it', 15.00, 'Utente'),
                                                                                              ('Antonio', 'Banderas', '3337070707', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'antonio.b@yahoo.it', 40.00, 'Utente'),
                                                                                              ('Francesca', 'Michielin', '3338080808', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'francesca.m@gmail.com', 8.50, 'Utente'),
                                                                                              ('Davide', 'Oldani', '3339090909', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'davide.o@hotmail.com', 60.00, 'Utente'),
                                                                                              ('Elisa', 'Toffoli', '3330101010', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'elisa.t@studenti.unisa.it', 22.00, 'Utente'),
                                                                                              ('Roberto', 'Saviano', '3331111111', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'roberto.s@email.it', 5.50, 'Utente'),
                                                                                              ('Paola', 'Cortellesi', '3332222222', '7e0bde6073589c2ecfe14afd73624edf2f8fe07e2bc66173fa18a50d13df3dafb5026f27f6424ae12c1988b9adc0a18ff3d5e6bfcec7dee91c94b770169c6a60', 'paola.c@gmail.com', 45.00, 'Utente');
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
                                                                               ('Paul Atreides si unisce a Chani e ai Fremen per vendicare la sua famiglia.', 'Dune - Parte Due', 2024, 'Denis Villeneuve', 'Fantascienza', 166, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008082/dune-part-two-_ffwset.jpg'),
                                                                               ('La storia di J. Robert Oppenheimer e la bomba atomica.', 'Oppenheimer', 2023, 'Christopher Nolan', 'Biografico', 180, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008218/oppenheimer_lgmrzk.jpg'),
                                                                               ('Nuove emozioni arrivano nella mente di Riley adolescente.', 'Inside Out 2', 2024, 'Kelsey Mann', 'Animazione', 96, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008124/inside_out_2_egyufd.jpg'),
                                                                               ('Il guerriero dragone affronta una nuova minaccia spirituale.', 'Kung Fu Panda 4', 2024, 'Mike Mitchell', 'Animazione', 94, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008210/kung_fu_panda_4__cqpaet.jpg'),
                                                                               ('Un film basato sul celebre videogioco Minecraft.', 'Minecraft: The Movie', 2025, 'Jared Hess', 'Avventura', 110, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008153/minecraftjpg_exwk8s.jpg'),
                                                                               ('Ethan Hunt torna per una missione impossibile finale.', 'Mission: Impossible 8', 2025, 'Christopher McQuarrie', 'Azione', 160, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008191/mission_impossible_8_pg_veqfde.jpg'),
                                                                               ('Il ritorno del Joker in un musical psicologico.', 'Joker: Folie à Deux', 2024, 'Todd Phillips', 'Drammatico', 138, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008144/joker_folie_a_deux_jpg_v6ucep.jpg'),
                                                                               ('Lucio deve combattere nel Colosseo dopo anni.', 'Gladiator 2', 2024, 'Ridley Scott', 'Storico', 150, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008091/Gladiator_2__xmu5nk.jpg'),
                                                                               ('Un clone usa la tecnologia per sopravvivere su un pianeta ghiacciato.', 'Mickey 17', 2025, 'Bong Joon-ho', 'Fantascienza', 139, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008133/Mickey_17__idfayo.jpg'),
                                                                               ('Deadpool e Wolverine uniscono le forze nel MCU.', 'Deadpool & Wolverine', 2024, 'Shawn Levy', 'Azione', 120, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008063/deadpool_wolverine__uioivc.jpg'),
                                                                               ('Il giovane leone Simba deve reclamare il suo regno.', 'Il Re Leone', 1994, 'Roger Allers, Rob Minkoff', 'Animazione', 88, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008173/IL_RE_LEONE_1994_jpg_ty1j8u.jpg'),
                                                                               ('La saga della famiglia Corleone nella mafia americana.', 'Il Padrino', 1972, 'Francis Ford Coppola', 'Crime', 175, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008115/Il_padrino_1972_omhixt.jpg'),
                                                                               ('I dinosauri tornano in vita grazie alla scienza.', 'Jurassic Park', 1993, 'Steven Spielberg', 'Avventura', 127, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008183/Jurassic_park_1993_lbvuta.jpg'),
                                                                               ('Un ladro entra nei sogni per rubare segreti aziendali.', 'Inception', 2010, 'Christopher Nolan', 'Fantascienza', 148, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008228/inception_w1w5gz.jpg'),
                                                                               ('Storie intrecciate di gangster a Los Angeles.', 'Pulp Fiction', 1994, 'Quentin Tarantino', 'Crime', 154, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008244/pulp_fiction_l53mez.jpg'),
                                                                               ('Un marine paralizzato esplora il mondo alieno di Pandora.', 'Avatar', 2009, 'James Cameron', 'Fantascienza', 162, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008018/Avatar_c766gb.jpg'),
                                                                               ('Frodo deve distruggere l anello del potere a Mordor.', 'Il Signore degli Anelli: Il Ritorno del Re', 2003, 'Peter Jackson', 'Fantasy', 201, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008202/il-signore_degli_anelli_il_ritorno_del_re_jwxs6q.jpg'),
                                                                               ('Barbie lascia Barbieland per scoprire il mondo reale.', 'Barbie', 2023, 'Greta Gerwig', 'Commedia', 114, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008055/Barbie_2023_agmvlk.jpg'),
                                                                               ('Un concierge e un fattorino in un hotel leggendario.', 'Grand Budapest Hotel', 2014, 'Wes Anderson', 'Commedia', 99, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008105/Grand_Budapest_Hotel__u0hp3o.jpg'),
                                                                               ('Chihiro deve salvare i suoi genitori nel mondo degli spiriti.', 'La Città Incantata', 2001, 'Hayao Miyazaki', 'Animazione', 125, 'https://res.cloudinary.com/dj8a3noqe/image/upload/v1767008236/la_citt%C3%A0_incantata_jpg_iukwf1.jpg');

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


-- Slot per i primi 10 giorni di Febbraio 2026
-- 4 slot al giorno = 40 slot totali

-- 1 Febbraio 2026
INSERT INTO SLOTORARI (oraInizio, oraFine, stato, data) VALUES
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-02-01'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-02-01'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-02-01'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-02-01'),

-- 2 Febbraio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-02-02'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-02-02'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-02-02'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-02-02'),

-- 3 Febbraio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-02-03'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-02-03'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-02-03'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-02-03'),

-- 4 Febbraio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-02-04'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-02-04'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-02-04'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-02-04'),

-- 5 Febbraio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-02-05'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-02-05'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-02-05'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-02-05'),

-- 6 Febbraio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-02-06'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-02-06'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-02-06'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-02-06'),

-- 7 Febbraio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-02-07'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-02-07'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-02-07'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-02-07'),

-- 8 Febbraio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-02-08'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-02-08'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-02-08'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-02-08'),

-- 9 Febbraio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-02-09'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-02-09'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-02-09'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-02-09'),

-- 10 Febbraio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-02-10'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-02-10'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-02-10'),

                                                           ('19:30', '22:30', 'DISPONIBILE', '2026-02-10');



-- Slot per tutto Gennaio 2026
-- 4 slot al giorno × 31 giorni = 124 slot totali

-- 1 Gennaio 2026
INSERT INTO slotorari (oraInizio, oraFine, stato, data) VALUES
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-01'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-01'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-01'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-01'),

-- 2 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-02'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-02'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-02'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-02'),

-- 3 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-03'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-03'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-03'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-03'),

-- 4 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-04'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-04'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-04'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-04'),

-- 5 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-05'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-05'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-05'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-05'),

-- 6 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-06'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-06'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-06'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-06'),

-- 7 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-07'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-07'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-07'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-07'),

-- 8 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-08'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-08'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-08'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-08'),

-- 9 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-09'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-09'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-09'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-09'),

-- 10 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-10'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-10'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-10'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-10'),

-- 11 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-11'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-11'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-11'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-11'),

-- 12 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-12'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-12'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-12'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-12'),

-- 13 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-13'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-13'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-13'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-13'),

-- 14 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-14'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-14'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-14'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-14'),

-- 15 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-15'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-15'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-15'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-15'),

-- 16 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-16'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-16'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-16'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-16'),

-- 17 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-17'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-17'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-17'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-17'),

-- 18 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-18'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-18'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-18'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-18'),

-- 19 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-19'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-19'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-19'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-19'),

-- 20 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-20'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-20'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-20'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-20'),

-- 21 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-21'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-21'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-21'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-21'),

-- 22 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-22'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-22'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-22'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-22'),

-- 23 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-23'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-23'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-23'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-23'),

-- 24 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-24'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-24'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-24'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-24'),

-- 25 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-25'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-25'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-25'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-25'),

-- 26 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-26'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-26'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-26'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-26'),

-- 27 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-27'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-27'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-27'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-27'),

-- 28 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-28'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-28'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-28'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-28'),

-- 29 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-29'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-29'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-29'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-29'),

-- 30 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-30'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-30'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-30'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-30'),

-- 31 Gennaio 2026
                                                            ('09:00', '12:00', 'DISPONIBILE', '2026-01-31'),
                                                            ('12:30', '15:30', 'DISPONIBILE', '2026-01-31'),
                                                            ('16:00', '19:00', 'DISPONIBILE', '2026-01-31'),
                                                            ('19:30', '22:30', 'DISPONIBILE', '2026-01-31');
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
                                                                                                                      ('2025-10-23', '2D', 9.50, 'Annullata', 5, 1, 1, 7),
                                                                                                                      ('2025-10-16', '2D', 10.00, 'Conclusa', 8, 1, 1, 5),
                                                                                                                      ('2025-10-17', '3D', 13.00, 'Disponibile', 10, 1, 1, 10),
                                                                                                                      ('2025-10-17', '2D', 9.00, 'Disponibile', 13, 2, 1, 9),
                                                                                                                      ('2025-10-17', 'IMAX', 16.00, 'Disponibile', 14, 4, 1, 11),
                                                                                                                      ('2025-10-17', '2D', 8.50, 'Disponibile', 18, 5, 1, 9),
                                                                                                                      ('2025-10-18', '2D', 12.00, 'Disponibile', 9, 3, 1, 14),
                                                                                                                      ('2025-10-22', '3D', 14.00, 'Disponibile', 16, 2, 1, 14),
                                                                                                                      ('2025-10-18', '2D', 10.50, 'Disponibile', 15, 2, 1, 13),
                                                                                                                      ('2025-10-19', '2D', 11.00, 'Disponibile', 17, 4, 1, 18),
                                                                                                                      ('2025-10-19', '2D', 9.00, 'Disponibile', 19, 5, 1, 17),
                                                                                                                      ('2025-10-20', 'IMAX', 17.00, 'Disponibile', 20, 1, 1, 17);




-- ============================================================
-- GENERA POSTI PER TUTTE LE PROGRAMMAZIONI AUTOMATICAMENTE
-- ============================================================
-- ============================================================
-- GENERA POSTI PER TUTTE LE PROGRAMMAZIONI
-- ============================================================

DELIMITER $$

DROP PROCEDURE IF EXISTS GeneraPostiProgrammazione$$

CREATE PROCEDURE GeneraPostiProgrammazione(
    IN p_idProgrammazione INT,
    IN p_idSala INT
)
BEGIN
    DECLARE v_numeroDiFile INT;
    DECLARE v_numeroPostiPerFila INT;
    DECLARE v_fila INT DEFAULT 1;
    DECLARE v_posto INT;

    -- Recupera dimensioni sala
    SELECT numeroDiFile, numeroPostiPerFila
    INTO v_numeroDiFile, v_numeroPostiPerFila
    FROM SALA
    WHERE idSala = p_idSala;

    -- Genera posti
    WHILE v_fila <= v_numeroDiFile DO
            SET v_posto = 1;
            WHILE v_posto <= v_numeroPostiPerFila DO
                    INSERT INTO POSTO (stato, fila, numeroPosto, idProgrammazione, idSala)
                    VALUES ('Disponibile', v_fila, v_posto, p_idProgrammazione, p_idSala);  -- ✅ "Disponibile"!
                    SET v_posto = v_posto + 1;
                END WHILE;
            SET v_fila = v_fila + 1;
        END WHILE;
END$$

DELIMITER ;
-- Genera posti per TUTTE le programmazioni (da 4 a 20, escluse 1,2,3 già fatte manualmente)

-- Genera posti per TUTTE le 20 programmazioni
CALL GeneraPostiProgrammazione(1, 1);   -- Prog 1, Sala A
CALL GeneraPostiProgrammazione(2, 2);   -- Prog 2, Sala B
CALL GeneraPostiProgrammazione(3, 1);   -- Prog 3, Sala A
CALL GeneraPostiProgrammazione(4, 3);   -- Prog 4, Sala C
CALL GeneraPostiProgrammazione(5, 1);   -- Prog 5, Sala A
CALL GeneraPostiProgrammazione(6, 4);   -- Prog 6, Sala D
CALL GeneraPostiProgrammazione(7, 2);   -- Prog 7, Sala B
CALL GeneraPostiProgrammazione(8, 3);   -- Prog 8, Sala C
CALL GeneraPostiProgrammazione(9, 1);   -- Prog 9, Sala A
CALL GeneraPostiProgrammazione(10, 1);  -- Prog 10, Sala A
CALL GeneraPostiProgrammazione(11, 1);  -- Prog 11, Sala A
CALL GeneraPostiProgrammazione(12, 2);  -- Prog 12, Sala B
CALL GeneraPostiProgrammazione(13, 4);  -- Prog 13, Sala D
CALL GeneraPostiProgrammazione(14, 5);  -- Prog 14, Sala E
CALL GeneraPostiProgrammazione(15, 3);  -- Prog 15, Sala C
CALL GeneraPostiProgrammazione(16, 2);  -- Prog 16, Sala B
CALL GeneraPostiProgrammazione(17, 2);  -- Prog 17, Sala B
CALL GeneraPostiProgrammazione(18, 4);  -- Prog 18, Sala D
CALL GeneraPostiProgrammazione(19, 5);  -- Prog 19, Sala E
CALL GeneraPostiProgrammazione(20, 1);  -- Prog 20, Sala A
-- ============================================================
-- AGGIORNA SLOT COME OCCUPATI (solo quelli con programmazioni)
-- ============================================================

UPDATE SLOTORARI
SET stato = 'Occupato'
WHERE idSlot IN (
    SELECT DISTINCT idSlotOrario
    FROM PROGRAMMAZIONE
);


-- Riattiva check chiavi esterne
SET FOREIGN_KEY_CHECKS = 1;
