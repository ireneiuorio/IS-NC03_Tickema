<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Riepilogo Acquisto - Tickema</title>

  <!-- CSS Base -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <style>
    /* Container principale */
    .riepilogo-container {
      max-width: 1000px;
      margin: 40px auto;
      padding: 0 20px;
    }

    /* Header successo */
    .success-header {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      padding: 50px 30px;
      border-radius: 20px 20px 0 0;
      text-align: center;
      box-shadow: 0 10px 40px rgba(109, 93, 110, 0.3);
    }

    .success-icon {
      width: 80px;
      height: 80px;
      background: white;
      color: var(--primary);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 3em;
      margin: 0 auto 20px;
      animation: successPop 0.6s ease-out;
    }

    @keyframes successPop {
      0% { transform: scale(0); opacity: 0; }
      50% { transform: scale(1.2); }
      100% { transform: scale(1); opacity: 1; }
    }

    .success-header h1 {
      font-size: 2.5em;
      font-weight: 700;
      margin-bottom: 10px;
      letter-spacing: 1px;
    }

    .success-header p {
      font-size: 1.2em;
      opacity: 0.95;
    }

    /* Card principale */
    .riepilogo-card {
      background: white;
      border-radius: 0 0 20px 20px;
      box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
      overflow: hidden;
    }

    .riepilogo-content {
      padding: 40px 30px;
    }

    /* Sezione informazioni */
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
    }

    /* Grid dettagli */
    .details-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
    }

    .detail-box {
      background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
      padding: 20px;
      border-radius: 12px;
      border-left: 4px solid var(--primary);
    }

    .detail-label {
      font-size: 0.9em;
      color: #666;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      margin-bottom: 8px;
    }

    .detail-value {
      font-size: 1.3em;
      color: var(--dark);
      font-weight: 600;
    }

    /* Biglietti */
    .biglietti-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 20px;
    }

    .biglietto-card {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      padding: 25px;
      border-radius: 15px;
      box-shadow: 0 5px 20px rgba(109, 93, 110, 0.3);
      transition: all 0.3s ease;
    }

    .biglietto-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 30px rgba(109, 93, 110, 0.4);
    }

    .biglietto-header {
      font-size: 1.2em;
      font-weight: 700;
      margin-bottom: 15px;
      padding-bottom: 15px;
      border-bottom: 1px solid rgba(255, 255, 255, 0.2);
    }

    .biglietto-info {
      margin-bottom: 10px;
      display: flex;
      justify-content: space-between;
      font-size: 0.95em;
    }

    .biglietto-label {
      opacity: 0.8;
    }

    .biglietto-value {
      font-weight: 600;
      text-align: right;
    }

    /* QR Code */
    .qr-section {
      margin-top: 20px;
      padding-top: 20px;
      border-top: 1px solid rgba(255, 255, 255, 0.2);
      text-align: center;
    }

    .qr-code {
      background: white;
      padding: 15px;
      border-radius: 10px;
      display: inline-block;
      margin-top: 10px;
    }

    .qr-code img {
      display: block;
      width: 150px;
      height: 150px;
    }

    /* Riepilogo pagamento */
    .payment-summary {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      padding: 25px;
      border-radius: 15px;
      margin-top: 20px;
    }

    .payment-row {
      display: flex;
      justify-content: space-between;
      padding: 12px 0;
      font-size: 1.1em;
    }

    .payment-row.total {
      border-top: 2px solid var(--primary);
      margin-top: 15px;
      padding-top: 15px;
      font-size: 1.4em;
      font-weight: 700;
      color: var(--primary);
    }

    .payment-method {
      background: white;
      padding: 15px;
      border-radius: 10px;
      margin-top: 15px;
      border-left: 4px solid var(--primary);
    }

    .payment-method-label {
      font-size: 0.9em;
      color: #666;
      margin-bottom: 5px;
    }

    .payment-method-value {
      font-size: 1.1em;
      font-weight: 600;
      color: var(--dark);
    }

    /* Azioni */
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
      gap: 10px;
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

    .btn-secondary {
      background: white;
      color: var(--primary);
      border: 2px solid var(--primary);
    }

    .btn-secondary:hover {
      background: var(--light-gray);
      transform: translateY(-2px);
    }

    /* Alert info */
    .info-alert {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      border-left: 4px solid var(--primary);
      padding: 20px;
      border-radius: 10px;
      margin-top: 30px;
      display: flex;
      align-items: flex-start;
      gap: 15px;
    }

    .info-alert-text {
      flex: 1;
      color: var(--dark);
      line-height: 1.6;
    }

    /* Responsive */
    @media (max-width: 768px) {
      .success-header h1 {
        font-size: 2em;
      }

      .success-icon {
        width: 60px;
        height: 60px;
        font-size: 2em;
      }

      .details-grid {
        grid-template-columns: 1fr;
      }

      .biglietti-grid {
        grid-template-columns: 1fr;
      }

      .actions {
        flex-direction: column;
      }

      .payment-row {
        font-size: 1em;
      }

      .payment-row.total {
        font-size: 1.2em;
      }
    }

    @media print {
      .actions, .info-alert, header, footer {
        display: none;
      }

      .success-header {
        background: var(--primary);
        -webkit-print-color-adjust: exact;
        print-color-adjust: exact;
      }

      .biglietto-card {
        background: var(--primary);
        -webkit-print-color-adjust: exact;
        print-color-adjust: exact;
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
      <div class="success-icon">✓</div>
      <h1>Acquisto Completato!</h1>
      <p>Grazie per aver scelto Tickema</p>
    </div>

    <div class="riepilogo-card">
      <div class="riepilogo-content">

        <!-- Dettagli Acquisto -->
        <div class="info-section">
          <h2>Dettagli Acquisto</h2>
          <div class="details-grid">
            <div class="detail-box">
              <div class="detail-label">Numero Ordine</div>
              <div class="detail-value">#${risultato.acquisto.idAcquisto}</div>
            </div>
            <div class="detail-box">
              <div class="detail-label">Data e Ora</div>
              <div class="detail-value">
                <c:set var="dataOra" value="${risultato.acquisto.dataOraAcquisto}" />
                <c:choose>
                  <c:when test="${not empty dataOra}">
                    <fmt:parseDate value="${dataOra}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                    <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                  </c:when>
                  <c:otherwise>
                    ${dataOra}
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
            <div class="detail-box">
              <div class="detail-label">Numero Biglietti</div>
              <div class="detail-value">${risultato.acquisto.numeroBiglietti}</div>
            </div>
            <div class="detail-box">
              <div class="detail-label">Importo Totale</div>
              <div class="detail-value">
                €<fmt:formatNumber value="${risultato.acquisto.importoTotale}" pattern="#,##0.00"/>
              </div>
            </div>
          </div>
        </div>

        <!-- Biglietti -->
        <div class="info-section">
          <h2>I Tuoi Biglietti</h2>
          <div class="biglietti-grid">
            <c:forEach var="biglietto" items="${risultato.biglietti}" varStatus="status">
              <div class="biglietto-card">
                <div class="biglietto-header">
                  Biglietto ${status.index + 1}
                </div>

                <div class="biglietto-info">
                  <span class="biglietto-label">Film:</span>
                  <span class="biglietto-value">
                      ${biglietto.programmazione.film.titolo}
                  </span>
                </div>

                <div class="biglietto-info">
                  <span class="biglietto-label">Data:</span>
                  <span class="biglietto-value">
                      ${biglietto.programmazione.dataProgrammazione}
                  </span>
                </div>

                <div class="biglietto-info">
                  <span class="biglietto-label">Orario:</span>
                  <span class="biglietto-value">
                      ${biglietto.programmazione.slotOrari.oraInizio}
                  </span>
                </div>

                <div class="biglietto-info">
                  <span class="biglietto-label">Sala:</span>
                  <span class="biglietto-value">
                      ${biglietto.programmazione.sala.nome}
                  </span>
                </div>

                <div class="biglietto-info">
                  <span class="biglietto-label">Posto:</span>
                  <span class="biglietto-value">
                    Fila ${biglietto.posto.fila}, Numero ${biglietto.posto.numeroPosto}
                  </span>
                </div>

                <div class="biglietto-info">
                  <span class="biglietto-label">Prezzo:</span>
                  <span class="biglietto-value">
                    €<fmt:formatNumber value="${biglietto.prezzoFinale}" pattern="#,##0.00"/>
                  </span>
                </div>

                <!-- QR Code -->
                <div class="qr-section">
                  <div class="biglietto-label">Codice Biglietto</div>
                  <div class="qr-code">
                    <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${biglietto.QRCode}"
                         alt="QR Code Biglietto">
                  </div>
                  <div style="margin-top: 10px; font-size: 0.85em; opacity: 0.9;">
                      ${biglietto.QRCode}
                  </div>
                </div>
              </div>
            </c:forEach>
          </div>
        </div>

        <!-- Riepilogo Pagamento -->
        <div class="info-section">
          <h2>Riepilogo Pagamento</h2>

          <div class="payment-summary">
            <c:forEach var="pagamento" items="${risultato.pagamenti}">
              <div class="payment-row">
                <span>
                  <c:choose>
                    <c:when test="${pagamento.metodoPagamento == 'Saldo'}">
                      Pagato con Saldo
                    </c:when>
                    <c:otherwise>
                      Pagato con Carta
                    </c:otherwise>
                  </c:choose>
                </span>
                <span>€<fmt:formatNumber value="${pagamento.importo}" pattern="#,##0.00"/></span>
              </div>
            </c:forEach>

            <div class="payment-row total">
              <span>TOTALE PAGATO</span>
              <span>€<fmt:formatNumber value="${risultato.acquisto.importoTotale}" pattern="#,##0.00"/></span>
            </div>
          </div>

          <c:if test="${sessionScope.utenteLoggato != null}">
            <div class="payment-method">
              <div class="payment-method-label">Saldo Rimanente</div>
              <div class="payment-method-value">
                €<fmt:formatNumber value="${sessionScope.utenteLoggato.saldo}" pattern="#,##0.00"/>
              </div>
            </div>
          </c:if>
        </div>

        <!-- Info Alert -->
        <div class="info-alert">
          <div class="info-alert-text">
            <strong>Importante:</strong> Ricorda di presentare il QR Code all'ingresso.
            Puoi salvare questa pagina o fare uno screenshot dei biglietti.
          </div>
        </div>

        <!-- Azioni -->
        <div class="actions">
          <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
            Torna alla Home
          </a>
          <button onclick="window.print()" class="btn btn-primary">
            Stampa Biglietti
          </button>
        </div>

      </div>
    </div>
  </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

</body>
</html>