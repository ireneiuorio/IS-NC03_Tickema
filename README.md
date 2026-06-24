

# Tickema

### Sistema di Gestione e Vendita Biglietti Cinematografici

*Progetto realizzato per il corso di **Ingegneria del Software** — Prof. C. Gravino*
*Corso di Laurea Triennale in Informatica — Università degli Studi di Salerno*


---

## Descrizione

**Tickema** è un'applicazione web pensata per digitalizzare e ottimizzare il processo di acquisto dei biglietti cinematografici e la gestione della programmazione di una struttura multisala. Il sistema offre inoltre un modulo di validazione dei biglietti dedicato al personale del cinema.

L'obiettivo del progetto è fornire una piattaforma:
- **Semplice e intuitiva** per gli utenti finali (max 3 click per raggiungere una proiezione);
- **Affidabile** nella gestione delle transazioni economiche e delle prenotazioni concorrenti;
- **Sicura** nel trattamento dei dati personali (conforme al GDPR);
- **Performante** anche su dispositivi mobili e con viewport variabili.

---

## Team — Gruppo NC03

| Nome | Ruolo | Acronimo | Contatto |
|------|-------|----------|----------|
| Irene Iuorio | Team Member | II | i.iuorio2@studenti.unisa.it |
| Laura Pascarella | Team Member | LP | l.pascarella5@studenti.unisa.it |
| Raffaella Maurelli | Team Member | RM | r.maurelli@studenti.unisa.it |
| Sara Di Tella | Team Member | SDT | s.ditella@studenti.unisa.it |

---

## Funzionalità Principali

### Gestione Utenti (SGU)
- Registrazione, login e logout
- Gestione profilo utente e credenziali
- Visualizzazione e gestione del saldo personale
- Validazione biglietti tramite QR Code (riservata al personale)

### Gestione Catalogo (SGC)
- Visualizzazione catalogo film con dettagli completi (trama, regista, genere, locandina)
- Ricerca film per titolo, genere, anno o data di proiezione
- Aggiunta, modifica ed eliminazione film (Amministratore)
- Pubblicazione e consultazione di recensioni utente

### Gestione Programmazioni (SGP)
- Creazione di programmazioni singole o multiple
- Gestione di sale, posti e slot orari
- Definizione di tariffe e percentuali di sconto
- Verifica automatica della disponibilità delle sale

### Gestione Acquisti (SGA)
- Acquisto biglietti con assegnazione automatica dei posti
- Generazione di biglietti digitali con QR Code univoco
- Storico acquisti consultabile dall'utente
- Gestione rimborsi con accredito automatico sul saldo

### Metodi di Pagamento Supportati
- **Carta di credito**
- **Saldo utente**
- **Pagamento misto** (saldo + carta)

---

## Architettura

Tickema adotta un'**architettura a 3 livelli (Three-Tier)** in stile **Closed Layered**, in cui ogni livello comunica esclusivamente con quello immediatamente inferiore.

```
┌─────────────────────────────────────────────────┐
│  PRESENTATION TIER  →  Servlet + JSP (Control)  │
├─────────────────────────────────────────────────┤
│  LOGIC TIER         →  Service (Facade)         │
├─────────────────────────────────────────────────┤
│  DATA TIER          →  Repository (DAO) + DBMS  │
└─────────────────────────────────────────────────┘
```

### Sottosistemi

| ID | Nome | Descrizione |
|----|------|-------------|
| **SGU** | Gestore Utenti | Profili, autenticazione, saldo, validazione |
| **SGC** | Gestore Catalogo | Film, recensioni, ricerca |
| **SGP** | Gestore Programmazioni | Proiezioni, sale, tariffe, slot orari |
| **SGA** | Gestore Acquisti | Biglietti, pagamenti, rimborsi |
| **SST** | Storage | Accesso ai dati (DAO) |
| **SDB** | Persistenza | DBMS relazionale |

---

## Design Patterns Utilizzati

### Facade Pattern
La classe `AcquistoFacade` coordina i molteplici servizi coinvolti nel flusso di acquisto (Programmazione, Posto, Tariffa, Acquisto, Pagamento, Saldo, Biglietto), esponendo un'unica interfaccia semplificata al Controller e nascondendo la complessità interna.

### Strategy Pattern
Il pattern `PaymentStrategy` definisce una famiglia di algoritmi intercambiabili per la gestione dei diversi metodi di pagamento:
- `CartaStrategy` — pagamento con carta di credito
- `SaldoStrategy` — pagamento con saldo utente
- `MistoStrategy` — pagamento combinato saldo + carta

### DAO Pattern
Ogni entità del database è gestita da una classe DAO dedicata (es. `AccountDAO`, `FilmDAO`, `BigliettoDAO`), che incapsula tutte le query SQL e disaccoppia la logica di business dal layer di persistenza.

---

## Struttura del Progetto

```
Tickema/
├── src/
│   ├── Control/          # Servlet HTTP
│   │   ├── SGU/          # Autenticazione, Profilo, Validazione
│   │   ├── SGC/          # Catalogo, Recensioni
│   │   ├── SGP/          # Programmazioni, Sale, Tariffe
│   │   └── SGA/          # Acquisti, Pagamenti, Biglietti
│   ├── Service/          # Business Logic (Facade)
│   │   ├── SGU/
│   │   ├── SGC/
│   │   ├── SGP/
│   │   └── SGA/
│   ├── Repository/       # DAO (accesso al DB)
│   │   ├── SGU/
│   │   ├── SGC/
│   │   ├── SGP/
│   │   └── SGA/
│   ├── Entity/           # Bean / POJO
│   │   ├── SGU/
│   │   ├── SGC/
│   │   ├── SGP/
│   │   └── SGA/
│   └── Exception/        # Eccezioni personalizzate
│       ├── SGU/
│       ├── SGC/
│       ├── SGP/
│       └── SGA/
├── WebContent/           # JSP, CSS, JS, immagini
├── database/             # Script SQL di inizializzazione
└── docs/                 # Documentazione (RAD, SDD, ODD)
```

---

## Convenzioni di Codice

| Elemento | Convenzione | Esempio |
|----------|-------------|---------|
| Classi e interfacce | `UpperCamelCase` (sostantivi singolari) | `GestioneAcquisti` |
| Metodi | `lowerCamelCase` (verbi) | `calcolaTotale()` |
| Variabili e parametri | `lowerCamelCase` | `idAccount` |
| Costanti | `UPPER_SNAKE_CASE` | `MAX_BIGLIETTI` |
| DAO | suffisso `DAO` | `FilmDAO` |
| Service | suffisso `Service` | `AcquistoService` |
| Servlet | suffisso `Servlet` | `CheckoutServlet` |
| Eccezioni | suffisso `Exception` | `EmailGiaRegistrataException` |

---

## Setup e Installazione

### Prerequisiti
- **JDK 17+**
- **MySQL 8.0+** (o MariaDB)
- **Apache Tomcat 10+**
- **Maven** o **Gradle** (per la gestione delle dipendenze)
- IDE consigliato: **IntelliJ IDEA** o **Eclipse for Enterprise Java**

### Installazione

1. **Clona il repository**
   ```bash
   git clone https://github.com/ireneiuorio/IS-NC03_Tickema.git
   cd IS-NC03_Tickema
   ```

2. **Configura il database**
   ```bash
   mysql -u root -p < database/schema.sql
   mysql -u root -p < database/seed.sql   # dati di esempio (opzionale)
   ```

3. **Configura le credenziali del DB**
   Modifica il file di configurazione (es. `src/main/resources/db.properties`):
   ```properties
   db.url=jdbc:mysql://localhost:3306/tickema
   db.user=tuo_utente
   db.password=tua_password
   ```

4. **Compila e fai il deploy su Tomcat**
   Importa il progetto nell'IDE, configuralo come applicazione web e avvia Tomcat.

5. **Accedi all'applicazione**
   ```
   http://localhost:8080/Tickema
   ```

---

## Attori del Sistema

| Acronimo | Ruolo | Permessi |
|----------|-------|----------|
| **UO** | Utente Ospite | Navigazione catalogo, registrazione |
| **UR** | Utente Registrato | Login |
| **UA** | Utente Autenticato | Acquisti, recensioni, gestione profilo |
| **PER** | Personale | Validazione biglietti all'ingresso |
| **ADM** | Amministratore | Gestione completa di catalogo, programmazioni, sale, tariffe |

---

## Design Goals

Il sistema è stato progettato seguendo obiettivi di qualità ben definiti:

- **Performance** — caricamento pagine entro 2s nel 95% dei casi
- **Sicurezza** — comunicazioni HTTPS (TLS ≥ 1.2), password hashate (SHA-256+)
- **Usabilità** — percorso d'acquisto in 3 click, completamento in < 5 minuti
- **Responsive Design** — adattamento da 320px a 1024px
- **Compatibilità** — ultime due versioni di Chrome, Firefox, Safari
- **Conformità Legale** — GDPR, conservazione dati acquisti per 24 mesi

---

## Documentazione

La documentazione completa del progetto è disponibile nella cartella [`/docs`](./docs):

| Documento | Descrizione |
|-----------|-------------|
| **SOW** (Statement of Work) | Definizione iniziale del lavoro |
| **RAD** (Requirements Analysis Document) | Analisi dei requisiti |
| **SDD** (System Design Document) | Progettazione del sistema |
| **ODD** (Object Design Document) | Progettazione degli oggetti |

---

## Riferimenti

> **"Object-Oriented Software Engineering: Conquering Complex and Changing Systems"**
> Bernd Bruegge & Allen H. Dutoit — 3rd edition, 2014

---



Progetto sviluppato a scopo didattico nell'ambito del corso di Ingegneria del Software presso l'Università degli Studi di Salerno — A.A. 2025/2026.


**Tickema** — *Il tuo cinema, a portata di click*

Made by Gruppo **NC03**

