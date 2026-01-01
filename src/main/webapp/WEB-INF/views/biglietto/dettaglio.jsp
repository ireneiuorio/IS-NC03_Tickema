<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dettaglio Biglietto - Tickema</title>

  <!-- CSS Base -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <style>
    /* Container principale */
    .dettaglio-container {
      max-width: 800px;
      margin: 40px auto;
      padding: 0 20px;
    }

    /* Header */
    .dettaglio-header {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      padding: 50px 30px;
      border-radius: 20px 20px 0 0;
      text-align: center;
      box-shadow: 0 10px 40px rgba(109, 93, 110, 0.3);
      position: relative;
      overflow: hidden;
    }

    .dettaglio-header::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.1)" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,112C672,96,768,96,864,112C960,128,1056,160,1152,160C1248,160,1344,128,1392,112L1440,96L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>') no-repeat bottom;
      background-size: cover;
      opacity: 0.3;
    }

    .dettaglio-header-content {
      position: relative;
      z-index: 1;
    }

    .dettaglio-header h1 {
      font-size: 2.5em;
      font-weight: 700;
      margin-bottom: 10px;
      letter-spacing: 1px;
    }

    .dettaglio-header p {
      font-size: 1.2em;
      opacity: 0.95;
    }

    /* Card principale */
    .dettaglio-card {
      background: white;
      border-radius: 0 0 20px 20px;
      box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
      overflow: hidden;
    }

    .dettaglio-content {
      padding: 40px 30px;
    }

    /* Sezioni */
    .info-section {
      margin-bottom: 35px;
      padding-bottom: 35px;
      border-bottom: 2px solid #f0f0f0;
    }

    .info-section:last-child {
      border-bottom: none;
      margin-bottom: 0;
      padding-bottom: 0;
    }

    .info-section h2 {
      color: var(--primary);
      font-size: 1.6em;
      margin-bottom: 20px;
      font-weight: 600;
      position: relative;
      padding-left: 15px;
    }

    .info-section h2::before {
      content: '';
      position: absolute;
      left: 0;
      top: 50%;
      transform: translateY(-50%);
      width: 4px;
      height: 30px;
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      border-radius: 2px;
    }

    /* Info rows */
    .info-row {
      display: flex;
      justify-content: space-between;
      padding: 15px 20px;
      background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
      border-radius: 10px;
      margin-bottom: 10px;
      transition: all 0.3s ease;
    }

    .info-row:hover {
      background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
      transform: translateX(5px);
    }

    .info-label {
      color: #666;
      font-weight: 500;
    }

    .info-value {
      font-weight: 600;
      color: var(--dark);
      text-align: right;
    }

    /* Badge stato */
    .stato-badge {
      display: inline-block;
      padding: 8px 16px;
      border-radius: 20px;
      font-size: 0.9em;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .stato-emesso {
      background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
      color: #2e7d32;
    }

    .stato-validato {
      background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
      color: #1976d2;
    }

    .stato-rimborsato {
      background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
      color: #f57c00;
    }

    .stato-scaduto {
      background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
      color: #c62828;
    }

    /* QR Code */
    .qr-section {
      text-align: center;
      padding: 30px;
      background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
      border-radius: 15px;
    }

    .qr-section p {
      color: #666;
      font-size: 1em;
      margin-bottom: 20px;
    }

    .qr-code {
      display: inline-block;
      background: white;
      padding: 20px;
      border-radius: 15px;
      border: 2px solid var(--border);
      margin: 20px 0;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    }

    .qr-code img {
      display: block;
      width: 200px;
      height: 200px;
    }

    .qr-text {
      font-size: 0.9em;
      color: #666;
      margin-top: 15px;
      word-break: break-all;
      font-family: monospace;
      background: white;
      padding: 10px;
      border-radius: 8px;
      border: 1px solid var(--border);
    }

    /* Alert info */
    .info-alert {
      background: white;
      border-left: 4px solid var(--primary);
      padding: 20px;
      border-radius: 10px;
      margin-top: 20px;
      color: var(--primary);
      font-weight: 500;
    }

    .info-alert strong {
      display: block;
      margin-bottom: 5px;
      font-size: 1.1em;
    }

    /* Actions */
    .actions {
      display: flex;
      gap: 20px;
      margin-top: 40px;
    }

    .btn {
      flex: 1;
      padding: 18px 40px;
      border: none;
      border-radius: 12px;
      font-size: 1.2em;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
    }

    .btn-secondary {
      background: white;
      color: var(--primary);
      border: 2px solid var(--primary);
    }

    .btn-secondary:hover {
      background: var(--light-gray);
      transform: translateY(-2px);
    }

    .btn-primary {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      box-shadow: 0 5px 20px rgba(109, 93, 110, 0.3);
    }

    .btn-primary:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 30px rgba(109, 93, 110, 0.4);
    }

    /* Responsive */
    @media (max-width: 768px) {
      .dettaglio-header h1 {
        font-size: 2em;
      }

      .dettaglio-header p {
        font-size: 1em;
      }

      .info-row {
        flex-direction: column;
        gap: 10px;
      }

      .info-value {
        text-align: left;
      }

      .actions {
        flex-direction: column;
      }

      .qr-code img {
        width: 150px;
        height: 150px;
      }
    }

    @media print {
      .actions, header, footer {
        display: none;
      }

      .dettaglio-header {
        background: var(--primary);
        -webkit-print-color-adjust: exact;
        print-color-adjust: exact;
      }
    }
  </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Main Content -->
<main>
  <div class="dettaglio-container">

    <!-- Header -->
    <div class="dettaglio-header">
      <div class="dettaglio-header-content">
        <h1>Dettaglio Biglietto</h1>
        <p>${biglietto.programmazione.film.titolo}</p>
      </div>
    </div>

    <div class="dettaglio-card">
      <div class="dettaglio-content">

        <!-- Info Film -->
        <div class="info-section">
          <h2>Informazioni Spettacolo</h2>

          <div class="info-row">
            <span class="info-label">Film:</span>
            <span class="info-value">${biglietto.programmazione.film.titolo}</span>
          </div>

          <div class="info-row">
            <span class="info-label">Data:</span>
            <span class="info-value">${biglietto.programmazione.dataProgrammazione}</span>
          </div>

          <div class="info-row">
            <span class="info-label">Orario:</span>
            <span class="info-value">${biglietto.programmazione.slotOrari.oraInizio}</span>
          </div>

          <div class="info-row">
            <span class="info-label">Sala:</span>
            <span class="info-value">${biglietto.programmazione.sala.nome}</span>
          </div>

          <div class="info-row">
            <span class="info-label">Posto:</span>
            <span class="info-value">Fila ${biglietto.posto.fila}, Numero ${biglietto.posto.numeroPosto}</span>
          </div>
        </div>

        <!-- Info Biglietto -->
        <div class="info-section">
          <h2>Dettagli Biglietto</h2>

          <div class="info-row">
            <span class="info-label">ID Biglietto:</span>
            <span class="info-value">#${biglietto.idBiglietto}</span>
          </div>

          <div class="info-row">
            <span class="info-label">Prezzo:</span>
            <span class="info-value">€<fmt:formatNumber value="${biglietto.prezzoFinale}" pattern="#,##0.00"/></span>
          </div>

          <div class="info-row">
            <span class="info-label">Stato:</span>
            <span class="info-value">
                            <c:choose>
                              <c:when test="${biglietto.stato == 'Emesso'}">
                                <span class="stato-badge stato-emesso">Emesso</span>
                              </c:when>
                              <c:when test="${biglietto.stato == 'Validato'}">
                                <span class="stato-badge stato-validato">Validato</span>
                              </c:when>
                              <c:when test="${biglietto.stato == 'Rimborsato'}">
                                <span class="stato-badge stato-rimborsato">Rimborsato</span>
                              </c:when>
                              <c:when test="${biglietto.stato == 'Scaduto'}">
                                <span class="stato-badge stato-scaduto">Scaduto</span>
                              </c:when>
                              <c:otherwise>
                                <span class="stato-badge">${biglietto.stato}</span>
                              </c:otherwise>
                            </c:choose>
                        </span>
          </div>

          <c:if test="${not empty biglietto.dataUtilizzo}">
            <div class="info-row">
              <span class="info-label">Data Utilizzo:</span>
              <span class="info-value">
                                <c:set var="dataUtilizzo" value="${biglietto.dataUtilizzo}" />
                                <c:choose>
                                  <c:when test="${not empty dataUtilizzo}">
                                    <fmt:parseDate value="${dataUtilizzo}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                                    <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                                  </c:when>
                                  <c:otherwise>
                                    ${dataUtilizzo}
                                  </c:otherwise>
                                </c:choose>
                            </span>
            </div>
          </c:if>
        </div>

        <!-- QR Code -->
        <c:if test="${biglietto.stato == 'Emesso'}">
          <div class="info-section">
            <h2>QR Code di Accesso</h2>
            <div class="qr-section">
              <p>Presenta questo codice all'ingresso della sala</p>
              <div class="qr-code">
                <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${biglietto.QRCode}"
                     alt="QR Code Biglietto">
              </div>
              <div class="qr-text">${biglietto.QRCode}</div>

              <div class="info-alert">
                <strong>Importante!</strong>
                Ricorda di presentare questo QR Code all'ingresso.
                Puoi salvare questa pagina o fare uno screenshot.
              </div>
            </div>
          </div>
        </c:if>

        <!-- Actions -->
        <div class="actions">
          <a href="${pageContext.request.contextPath}/utente/storico-acquisti" class="btn btn-secondary">
            Torna allo Storico
          </a>
          <c:if test="${biglietto.stato == 'Emesso'}">
            <button onclick="window.print()" class="btn btn-primary">
              Stampa Biglietto
            </button>
          </c:if>
        </div>

      </div>
    </div>

  </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

</body>
</html>