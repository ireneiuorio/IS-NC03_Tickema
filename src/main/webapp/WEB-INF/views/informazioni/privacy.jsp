<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Privacy Policy - Tickema</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

  <style>
    .hero {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      padding: 80px 30px;
      text-align: center;
      margin-bottom: 60px;
    }

    .hero h1 {
      font-size: 3em;
      font-weight: bold;
      font-style: italic;
      margin-bottom: 15px;
      letter-spacing: 2px;
    }

    .container {
      max-width: 900px;
      margin: 0 auto 80px;
      padding: 0 30px;
    }

    .section {
      background: white;
      border-radius: 16px;
      padding: 45px;
      box-shadow: 0 2px 20px rgba(0, 0, 0, 0.04);
      margin-bottom: 30px;
    }

    .section h2 {
      font-size: 1.8em;
      color: var(--dark);
      margin-bottom: 15px;
      font-weight: 600;
    }

    .section p {
      font-size: 1.05em;
      line-height: 1.8;
      color: #333;
      margin-bottom: 15px;
    }

    @media (max-width: 768px) {
      .hero h1 { font-size: 2em; }
      .section { padding: 30px 25px; }
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/includes/header.jsp" />

<section class="hero">
  <h1>Privacy Policy</h1>
  <p>La tua privacy è importante per noi</p>
</section>

<main>
  <div class="container">
    <div class="section">
      <h2>1. Raccolta dei Dati</h2>
      <p>
        Tickema raccoglie dati personali necessari per l'erogazione del servizio di
        prenotazione biglietti cinematografici. I dati raccolti includono nome, cognome,
        email e informazioni di pagamento.
      </p>
    </div>

    <div class="section">
      <h2>2. Utilizzo dei Dati</h2>
      <p>
        I dati personali vengono utilizzati esclusivamente per:
      </p>
      <p>
        - Gestione delle prenotazioni e acquisto biglietti<br>
        - Comunicazioni relative al servizio<br>
        - Miglioramento dell'esperienza utente
      </p>
    </div>

    <div class="section">
      <h2>3. Protezione dei Dati</h2>
      <p>
        Adottiamo misure di sicurezza appropriate per proteggere i tuoi dati personali
        contro accessi non autorizzati, alterazioni, divulgazioni o distruzioni.
      </p>
    </div>

    <div class="section">
      <h2>4. Diritti dell'Utente</h2>
      <p>
        Hai il diritto di accedere, modificare o cancellare i tuoi dati personali
        in qualsiasi momento contattando il nostro servizio clienti.
      </p>
    </div>
  </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>