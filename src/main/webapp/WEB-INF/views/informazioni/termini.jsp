<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Termini e Condizioni - Tickema</title>
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
  <h1>Termini e Condizioni</h1>
  <p>Condizioni generali di utilizzo del servizio</p>
</section>

<main>
  <div class="container">
    <div class="section">
      <h2>1. Accettazione dei Termini</h2>
      <p>
        Utilizzando il servizio Tickema, accetti integralmente i presenti termini e condizioni.
        Se non accetti questi termini, ti preghiamo di non utilizzare il servizio.
      </p>
    </div>

    <div class="section">
      <h2>2. Acquisto Biglietti</h2>
      <p>
        L'acquisto dei biglietti è soggetto a disponibilità.
      </p>
    </div>

    <div class="section">
      <h2>3. Rimborsi e Cancellazioni</h2>
      <p>
        I biglietti acquistati possono essere rimborsati solo in caso di annullamento
        della programmazione da parte del cinema. Non sono previsti rimborsi per
        mancata presentazione dello spettatore.
      </p>
    </div>

    <div class="section">
      <h2>4. Responsabilità</h2>
      <p>
        Tickema si impegna a fornire un servizio di qualità ma non può essere ritenuta
        responsabile per eventuali disservizi dovuti a cause di forza maggiore o a
        malfunzionamenti tecnici non dipendenti dalla propria volontà.
      </p>
    </div>

    <div class="section">
      <h2>5. Modifiche ai Termini</h2>
      <p>
        Ci riserviamo il diritto di modificare questi termini in qualsiasi momento.
        Le modifiche saranno pubblicate su questa pagina e entreranno in vigore
        immediatamente.
      </p>
    </div>
  </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>
