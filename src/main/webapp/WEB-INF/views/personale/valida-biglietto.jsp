<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Validazione Biglietti - Tickema</title>

  <!-- CSS Base -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <style>
    .validazione-container {
      max-width: 800px;
      margin: 40px auto;
      padding: 0 20px;
    }

    .validazione-card {
      background: white;
      border-radius: 20px;
      box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
      overflow: hidden;
    }

    .validazione-header {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      padding: 40px 30px;
      text-align: center;
    }

    .validazione-header h1 {
      font-size: 2.5em;
      font-weight: 700;
      margin-bottom: 10px;
    }

    .validazione-header p {
      font-size: 1.1em;
      opacity: 0.9;
    }

    .validazione-content {
      padding: 40px 30px;
    }

    /* Form di scansione */
    .scan-form {
      margin-bottom: 30px;
    }

    .form-group {
      margin-bottom: 20px;
    }

    .form-group label {
      display: block;
      font-weight: 600;
      margin-bottom: 8px;
      color: var(--dark);
    }

    .form-group input {
      width: 100%;
      padding: 15px;
      border: 2px solid var(--border);
      border-radius: 8px;
      font-size: 1.1em;
      transition: all 0.3s ease;
    }

    .form-group input:focus {
      outline: none;
      border-color: var(--primary);
      box-shadow: 0 0 0 3px rgba(109, 93, 110, 0.1);
    }

    /* Alert messages */
    .alert {
      padding: 20px;
      border-radius: 12px;
      margin-bottom: 25px;
      display: flex;
      align-items: center;
      gap: 15px;
      animation: slideDown 0.3s ease;
    }

    @keyframes slideDown {
      from {
        opacity: 0;
        transform: translateY(-20px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .alert-success {
      background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
      border-left: 5px solid #4caf50;
      color: #2e7d32;
    }

    .alert-warning {
      background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
      border-left: 5px solid #ff9800;
      color: #e65100;
    }

    .alert-error {
      background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
      border-left: 5px solid #f44336;
      color: #c62828;
    }

    .alert-icon {
      font-size: 2em;
    }

    /* Dettagli biglietto */
    .biglietto-dettagli {
      background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
      padding: 25px;
      border-radius: 15px;
      border-left: 4px solid var(--primary);
      margin-top: 20px;
    }

    .biglietto-dettagli h3 {
      color: var(--primary);
      font-size: 1.4em;
      margin-bottom: 20px;
      font-weight: 600;
    }

    .dettaglio-row {
      display: flex;
      justify-content: space-between;
      padding: 12px 0;
      border-bottom: 1px solid #e0e0e0;
    }

    .dettaglio-row:last-child {
      border-bottom: none;
    }

    .dettaglio-label {
      font-weight: 600;
      color: #666;
    }

    .dettaglio-value {
      color: var(--dark);
      font-weight: 600;
    }

    /* Bottoni */
    .btn {
      padding: 18px 40px;
      border: none;
      border-radius: 12px;
      font-size: 1.2em;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-block;
    }

    .btn-primary {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      box-shadow: 0 5px 20px rgba(109, 93, 110, 0.3);
      width: 100%;
    }

    .btn-primary:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 30px rgba(109, 93, 110, 0.4);
    }

    .btn-secondary {
      background: white;
      color: var(--primary);
      border: 2px solid var(--primary);
      margin-top: 15px;
      width: 100%;
    }

    .btn-secondary:hover {
      background: var(--light-gray);
      transform: translateY(-2px);
    }

    /* Istruzioni */
    .istruzioni {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      padding: 20px;
      border-radius: 12px;
      margin-bottom: 30px;
    }

    .istruzioni h3 {
      color: var(--dark);
      font-size: 1.2em;
      margin-bottom: 15px;
    }

    .istruzioni ul {
      list-style: none;
      padding: 0;
    }

    .istruzioni li {
      padding: 8px 0;
      padding-left: 25px;
      position: relative;
    }

    .istruzioni li:before {
      content: "✓";
      position: absolute;
      left: 0;
      color: var(--primary);
      font-weight: bold;
    }

    @media (max-width: 768px) {
      .validazione-header h1 {
        font-size: 2em;
      }

      .dettaglio-row {
        flex-direction: column;
        gap: 5px;
      }
    }
  </style>
</head>
<body>
<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Main Content -->
<main>
  <div class="validazione-container">

    <div class="validazione-card">
      <!-- Header -->
      <div class="validazione-header">
        <h1>Validazione Biglietti</h1>
        <p>Scansiona o inserisci il codice QR del biglietto</p>
      </div>

      <div class="validazione-content">

        <!-- Messaggi di feedback -->
        <c:if test="${not empty successo}">
          <div class="alert alert-success">
            <span class="alert-icon">✓</span>
            <div>
              <strong>Successo!</strong> ${successo}
            </div>
          </div>
        </c:if>

        <c:if test="${not empty warning}">
          <div class="alert alert-warning">
            <span class="alert-icon">⚠</span>
            <div>
              <strong>Attenzione!</strong> ${warning}
            </div>
          </div>
        </c:if>

        <c:if test="${not empty errore}">
          <div class="alert alert-error">
            <span class="alert-icon">✕</span>
            <div>
              <strong>Errore!</strong> ${errore}
            </div>
          </div>
        </c:if>

        <!-- Istruzioni -->
        <div class="istruzioni">
          <h3>Come validare un biglietto:</h3>
          <ul>
            <li>Scansiona il QR Code dal dispositivo del cliente</li>
            <li>Oppure inserisci manualmente il codice</li>
            <li>Verifica i dettagli del biglietto</li>
            <li>Clicca "Valida Biglietto" per confermare</li>
          </ul>
        </div>

        <!-- Form di validazione -->
        <form method="POST" action="${pageContext.request.contextPath}/valida-biglietto" class="scan-form">
          <div class="form-group">
            <label for="qrCode">Codice QR Biglietto</label>
            <input type="text"
                   id="qrCode"
                   name="qrCode"
                   placeholder="TKT-20250101120000-abc123de"
                   required
                   autofocus>
          </div>

          <button type="submit" class="btn btn-primary">
            Valida Biglietto
          </button>
        </form>

        <!-- Dettagli biglietto (se presente) -->
        <c:if test="${not empty biglietto}">
          <div class="biglietto-dettagli">
            <h3>Dettagli Biglietto</h3>

            <div class="dettaglio-row">
              <span class="dettaglio-label">Film:</span>
              <span class="dettaglio-value">${biglietto.programmazione.film.titolo}</span>
            </div>

            <div class="dettaglio-row">
              <span class="dettaglio-label">Data Proiezione:</span>
              <span class="dettaglio-value">${biglietto.programmazione.dataProgrammazione}</span>
            </div>

            <div class="dettaglio-row">
              <span class="dettaglio-label">Orario:</span>
              <span class="dettaglio-value">${biglietto.programmazione.slotOrari.oraInizio}</span>
            </div>

            <div class="dettaglio-row">
              <span class="dettaglio-label">Sala:</span>
              <span class="dettaglio-value">${biglietto.programmazione.sala.nome}</span>
            </div>

            <div class="dettaglio-row">
              <span class="dettaglio-label">Posto:</span>
              <span class="dettaglio-value">Fila ${biglietto.posto.fila}, Numero ${biglietto.posto.numeroPosto}</span>
            </div>

            <div class="dettaglio-row">
              <span class="dettaglio-label">Prezzo:</span>
              <span class="dettaglio-value">€<fmt:formatNumber value="${biglietto.prezzoFinale}" pattern="#,##0.00"/></span>
            </div>

            <div class="dettaglio-row">
              <span class="dettaglio-label">Stato:</span>
              <span class="dettaglio-value">${biglietto.stato}</span>
            </div>

            <c:if test="${not empty biglietto.dataUtilizzo}">
              <div class="dettaglio-row">
                <span class="dettaglio-label">Data Utilizzo:</span>
                <span class="dettaglio-value">
                                    <fmt:formatDate value="${biglietto.dataUtilizzo}" pattern="dd/MM/yyyy HH:mm" />
                                </span>
              </div>
            </c:if>

            <div class="dettaglio-row">
              <span class="dettaglio-label">QR Code:</span>
              <span class="dettaglio-value">${biglietto.QRCode}</span>
            </div>
          </div>
        </c:if>

        <!-- Bottone reset -->
        <a href="${pageContext.request.contextPath}/personale/valida-biglietto" class="btn btn-secondary">
          Nuova Scansione
        </a>

      </div>
    </div>
  </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script>
  // Auto-focus sul campo QR Code
  document.getElementById('qrCode').focus();

  // Seleziona tutto il testo quando si clicca sul campo
  document.getElementById('qrCode').addEventListener('click', function() {
    this.select();
  });
</script>

</body>
</html>