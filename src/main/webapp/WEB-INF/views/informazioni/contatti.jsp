<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Contatti - Tickema</title>
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
      font-size: 2em;
      color: var(--dark);
      margin-bottom: 20px;
      font-weight: 600;
    }

    .section p {
      font-size: 1.1em;
      line-height: 1.8;
      color: #333;
      margin-bottom: 15px;
    }

    .contact-info {
      display: grid;
      gap: 20px;
    }

    .contact-item {
      display: flex;
      align-items: center;
      gap: 15px;
      padding: 20px;
      background: var(--light-gray);
      border-radius: 10px;
    }

    .contact-item strong {
      min-width: 100px;
      color: var(--primary);
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
  <h1>Contatti</h1>
  <p>Siamo qui per aiutarti</p>
</section>

<main>
  <div class="container">
    <div class="section">
      <h2>Informazioni di Contatto</h2>
      <div class="contact-info">
        <div class="contact-item">
          <strong>Indirizzo:</strong>
          <span>Via Cinema 123, Fisciano (SA)</span>
        </div>
        <div class="contact-item">
          <strong>Telefono:</strong>
          <span>+39 081 123 4567</span>
        </div>
        <div class="contact-item">
          <strong>Email:</strong>
          <span>info@tickema.it</span>
        </div>
        <div class="contact-item">
          <strong>Orari:</strong>
          <span>Lun-Dom: 10:00 - 23:00</span>
        </div>
      </div>
    </div>

    <div class="section">
      <h2>Assistenza Clienti</h2>
      <p>
        Per qualsiasi domanda o problema riguardante i tuoi biglietti,
        non esitare a contattarci via email o telefono durante gli orari di apertura.
      </p>
      <p>
        Il nostro team di supporto è sempre pronto ad aiutarti per garantirti
        la migliore esperienza possibile.
      </p>
    </div>
  </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>