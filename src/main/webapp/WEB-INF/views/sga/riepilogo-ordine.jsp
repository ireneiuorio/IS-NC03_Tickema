<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Acquisto Completato - Tickema</title>

  <!-- CSS Base -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <style>
    .riepilogo-container {
      max-width: 1000px;
      margin: 40px auto;
      padding: 0 20px;
    }

    /* Success Header */
    .success-header {
      background: linear-gradient(135deg, #4caf50 0%, #2e7d32 100%);
      color: var(--white);
      padding: 50px 30px;
      border-radius: 20px;
      text-align: center;
      margin-bottom: 40px;
      box-shadow: 0 10px 40px rgba(76, 175, 80, 0.3);
      animation: slideDown 0.5s ease-out;
    }

    @keyframes slideDown {
      from {
        opacity: 0;
        transform: translateY(-30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .success-icon {
      font-size: 5em;
      margin-bottom: 20px;
      animation: scaleUp 0.6s ease-out;
    }

    @keyframes scaleUp {
      from {
        transform: scale(0);
      }
      to {
        transform: scale(1);
      }
    }

    .success-header h1 {
      font-size: 2.5em;
      font-weight: 300;
      margin-bottom: 10px;
      letter-spacing: 2px;
    }

    .success-header p {
      font-size: 1.2em;
      opacity: 0.95;
    }

    /* Card generale */
    .info-card {
      background: var(--white);
      border-radius: 20px;
      box-shadow: 0 5px 20px var(--shadow);
      padding: 30px;
      margin-bottom: 30px;
    }

    .info-card h2 {
      color: var(--dark);
      font-size: 1.8em;
      margin-bottom: 20px;
      font-weight: 500;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    /* Film Info */
    .film-info-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 20px;
      margin-bottom: 20px;
    }

    .info-item {
      background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
      padding: 15px;
      border-radius: 10px;
      border-left: 4px solid var(--primary);
    }

    .info-label {
      font-size: 0.9em;
      color: #666;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      margin-bottom: 5px;
    }

    .info-value {
      font-size: 1.2em;
      color: var(--dark);
      font-weight: 600;
    }

    /* Posti */
    .posti-section {
      background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
      border-left: 4px solid #2196F3;
      padding: 20px;
      border-radius: 12px;
      margin-bottom: 20px;
    }

    .posti-section h3 {
      color: #1976d2;
      margin-bottom: 15px;
      font-size: 1.3em;
    }

    .posti-list {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
    }

    .posto-badge {
      background: var(--white);
      color: var(--primary);
      padding: 8px 15px;
      border-radius: 20px;
      font-weight: 600;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .vicinanza-badge {
      display: inline-block;
      padding: 8px 15px;
      border-radius: 20px;
      font-weight: 600;
      margin-top: 10px;
    }

    .vicinanza-ok {
      background: #e8f5e9;
      color: #2e7d32;
    }

    .vicinanza-parziale {
      background: #fff3e0;
      color: #e65100;
    }

    /* Biglietti Grid */
    .biglietti-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 20px;
      margin-top: 20px;
    }

    .biglietto-card {
      background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
      border: 2px solid var(--border);
      border-radius: 15px;
      padding: 25px;
      text-align: center;
      transition: all 0.3s ease;
    }

    .biglietto-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 30px var(--shadow);
      border-color: var(--primary);
    }

    .biglietto-header {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: var(--white);
      padding: 15px;
      border-radius: 10px;
      margin-bottom: 20px;
    }

    .biglietto-header h3 {
      margin: 0;
      font-size: 1.3em;
      font-weight: 600;
    }

    .biglietto-posto {
      font-size: 1.5em;
      color: var(--dark);
      font-weight: 700;
      margin: 15px 0;
    }

    .qr-code-container {
      background: var(--white);
      padding: 20px;
      border-radius: 10px;
      margin: 20px 0;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }

    .qr-code-container img {
      max-width: 200px;
      height: auto;
      border: 3px solid var(--border);
      border-radius: 10px;
    }

    .qr-code-text {
      font-family: 'Courier New', monospace;
      font-size: 0.85em;
      color: #666;
      margin-top: 10px;
      word-break: break-all;
    }

    .biglietto-prezzo {
      font-size: 1.3em;
      color: var(--primary);
      font-weight: 700;
      margin-top: 15px;
    }

    /* Pagamento */
    .pagamento-section {
      background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
      padding: 25px;
      border-radius: 12px;
      border-left: 4px solid var(--primary);
    }

    .pagamento-item {
      display: flex;
      justify-content: space-between;
      padding: 12px 0;
      border-bottom: 1px solid var(--border);
    }

    .pagamento-item:last-child {
      border-bottom: none;
      font-size: 1.3em;
      font-weight: 700;
      color: var(--dark);
      padding-top: 15px;
      margin-top: 10px;
      border-top: 2px solid var(--border);
    }

    .metodo-badge {
      display: inline-block;
      padding: 5px 12px;
      border-radius: 15px;
      font-size: 0.9em;
      font-weight: 600;
    }

    .metodo-saldo {
      background: #e3f2fd;
      color: #1976d2;
    }

    .metodo-carta {
      background: #fff3e0;
      color: #e65100;
    }

    /* Azioni */
    .azioni-section {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 15px;
      margin-top: 30px;
    }

    .btn-azione {
      padding: 15px 25px;
      border: none;
      border-radius: 12px;
      font-size: 1em;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
    }

    .btn-primary-action {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: var(--white);
      box-shadow: 0 5px 20px var(--shadow);
    }

    .btn-primary-action:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px var(--shadow);
    }

    .btn-secondary-action {
      background: var(--white);
      color: var(--dark);
      border: 2px solid var(--primary);
    }

    .btn-secondary-action:hover {
      background: var(--light-gray);
    }

    .btn-success {
      background: linear-gradient(135deg, #4caf50 0%, #2e7d32 100%);
      color: var(--white);
    }

    .btn-success:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 20px rgba(76, 175, 80, 0.3);
    }

    /* Note importanti */
    .note-importanti {
      background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
      border-left: 4px solid #ff9800;
      padding: 20px;
      border-radius: 12px;
      margin-top: 30px;
    }

    .note-importanti h3 {
      color: #e65100;
      margin-bottom: 15px;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .note-importanti ul {
      list-style: none;
      padding: 0;
    }

    .note-importanti li {
      padding: 8px 0;
      color: #e65100;
      display: flex;
      align-items: start;
      gap: 10px;
    }

    .note-importanti li:before {
      content: "•";
      font-size: 1.5em;
      font-weight: bold;
    }

    @media (max-width: 768px) {
      .success-header {
        padding: 40px 20px;
      }

      .success-header h1 {
        font-size: 1.8em;
      }

      .biglietti-grid {
        grid-template-columns: 1fr;
      }

      .film-info-grid {
        grid-template-columns: 1fr;
      }

      .azioni-section {
        grid-template-columns: 1fr;
      }
    }

    @media print {
      .header, .footer, .azioni-section, .note-importanti {
        display: none;
      }

      .biglietto-card {
        page-break-inside: avoid;
      }
    }
  </style>
</head>
<body>
<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Main Content -->
<main>
  <div class="riepilogo-container">

    <!-- Success Header -->
    <div class="success-header">
      <div class="success-icon"></div>
      <h1>Acquisto Completato!</h1>
      <p>I tuoi biglietti sono pronti</p>
      <p style="font-size: 0.9em; margin-top: 10px;">
        Ordine #${risultato.acquisto.idAcquisto}
      </p>
    </div>

    <!-- Film Info -->
    <div class="info-card">
      <h2>🎬 Dettagli Proiezione</h2>
      <div class="film-info-grid">
        <div class="info-item">
          <div class="info-label">Film</div>
          <div class="info-value">${risultato.programmazione.film.titolo}</div>
        </div>
        <div class="info-item">
          <div class="info-label">Data</div>
          <div class="info-value">
            <fmt:formatDate value="${risultato.programmazione.dataProgrammazione}" pattern="dd/MM/yyyy" />
          </div>
        </div>
        <div class="info-item">
          <div class="info-label">Orario</div>
          <div class="info-value">${risultato.programmazione.orarioInizio}</div>
        </div>
        <div class="info-item">
          <div class="info-label">Sala</div>
          <div class="info-value">${risultato.programmazione.sala.nome}</div>
        </div>
      </div>

      <!-- Posti Assegnati -->
      <div class="posti-section">
        <h3>🪑 I Tuoi Posti</h3>
        <div class="posti-list">
          <c:forEach items="${risultato.postiAssegnati}" var="posto">
                            <span class="posto-badge">
                                Fila ${posto.fila} - Posto ${posto.numeroPosto}
                            </span>
          </c:forEach>
        </div>

        <c:if test="${risultato.vicinanzaGarantita}">
          <div class="vicinanza-badge vicinanza-ok">
             Posti vicini garantiti
          </div>
        </c:if>
        <c:if test="${!risultato.vicinanzaGarantita}">
          <div class="vicinanza-badge vicinanza-parziale">
            Posti con vicinanza parziale
          </div>
        </c:if>
      </div>
    </div>

    <!-- Biglietti con QR Code -->
    <div class="info-card">
      <h2>I Tuoi Biglietti</h2>
      <p style="color: #666; margin-bottom: 20px;">
        Mostra questi QR code all'ingresso della sala
      </p>

      <div class="biglietti-grid">
        <c:forEach items="${risultato.biglietti}" var="biglietto" varStatus="status">
          <div class="biglietto-card">
            <div class="biglietto-header">
              <h3>Biglietto #${status.index + 1}</h3>
            </div>

            <div class="biglietto-posto">
              🪑 Fila ${biglietto.posto.fila} - Posto ${biglietto.posto.numeroPosto}
            </div>

            <!-- QR CODE -->
            <div class="qr-code-container">
              <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${biglietto.QRCode}"
                   alt="QR Code Biglietto #${biglietto.idBiglietto}"
                   loading="lazy">
              <div class="qr-code-text">${biglietto.QRCode}</div>
            </div>

            <div class="biglietto-prezzo">
              €<fmt:formatNumber value="${biglietto.prezzoFinale}" pattern="#,##0.00"/>
            </div>
          </div>
        </c:forEach>
      </div>
    </div>

    <!-- Riepilogo Pagamento -->
    <div class="info-card">
      <h2>Riepilogo Pagamento</h2>

      <div class="pagamento-section">
        <c:forEach items="${risultato.pagamenti}" var="pagamento">
          <div class="pagamento-item">
                            <span>
                                <span class="metodo-badge ${pagamento.metodoPagamento == 'Saldo' ? 'metodo-saldo' : 'metodo-carta'}">
                                    ${pagamento.metodoPagamento == 'Saldo' ? '💰' : '💳'} ${pagamento.metodoPagamento}
                                </span>
                            </span>
            <span>€<fmt:formatNumber value="${pagamento.importo}" pattern="#,##0.00"/></span>
          </div>
        </c:forEach>

        <div class="pagamento-item">
          <span>TOTALE PAGATO</span>
          <span>€<fmt:formatNumber value="${risultato.importoTotale}" pattern="#,##0.00"/></span>
        </div>
      </div>
    </div>

    <!-- Azioni -->
    <div class="azioni-section">
      <a href="${pageContext.request.contextPath}/i-miei-biglietti" class="btn-azione btn-primary-action">
        I Miei Biglietti
      </a>
      <a href="${pageContext.request.contextPath}/programmazioni" class="btn-azione btn-secondary-action">
         Nuova Prenotazione
      </a>
      <button onclick="window.print()" class="btn-azione btn-success">
        Stampa Biglietti
      </button>
    </div>

    <!-- Note Importanti -->
    <div class="note-importanti">
      <h3>Note Importanti</h3>
      <ul>
        <li>Presenta i QR code all'ingresso della sala 15 minuti prima dell'inizio</li>
        <li>I biglietti sono nominali e non cedibili</li>
        <li>Conserva questa pagina o salvala come PDF</li>
        <li>In caso di problemi, contatta l'assistenza mostrando l'ID ordine #${risultato.acquisto.idAcquisto}</li>
      </ul>
    </div>

  </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script>
  // Mostra messaggio di successo al caricamento
  window.onload = function() {
    console.log('Acquisto completato con successo!');
    console.log('Ordine ID:', ${risultato.acquisto.idAcquisto});
  };
</script>
</body>
</html>