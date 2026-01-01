<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Storico Acquisti - Tickema</title>

  <!-- CSS Base -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <style>
    /* Container principale */
    .storico-container {
      max-width: 1200px;
      margin: 40px auto;
      padding: 0 20px;
    }

    /* Header */
    .storico-header {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      padding: 50px 30px;
      border-radius: 20px;
      text-align: center;
      margin-bottom: 40px;
      box-shadow: 0 10px 40px rgba(109, 93, 110, 0.3);
      position: relative;
      overflow: hidden;
    }

    .storico-header::before {
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

    .storico-header-content {
      position: relative;
      z-index: 1;
    }

    .storico-header h1 {
      font-size: 2.5em;
      font-weight: 700;
      margin-bottom: 10px;
      letter-spacing: 1px;
    }

    .storico-header p {
      font-size: 1.1em;
      opacity: 0.95;
    }

    /* Empty State */
    .empty-state {
      text-align: center;
      padding: 80px 20px;
      background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
      border-radius: 20px;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
    }

    .empty-state h2 {
      color: var(--dark);
      font-size: 1.8em;
      margin-bottom: 15px;
    }

    .empty-state p {
      color: #666;
      font-size: 1.1em;
      margin-bottom: 30px;
    }

    /* Acquisto Card */
    .acquisto-card {
      background: white;
      border-radius: 20px;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
      margin-bottom: 30px;
      overflow: hidden;
      transition: all 0.3s ease;
    }

    .acquisto-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
    }

    /* Header acquisto */
    .acquisto-header {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      padding: 25px 30px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 15px;
    }

    .acquisto-numero {
      font-size: 1.3em;
      font-weight: 700;
    }

    .acquisto-data {
      font-size: 1em;
      opacity: 0.9;
    }

    .acquisto-importo {
      font-size: 1.5em;
      font-weight: 700;
    }

    /* Content acquisto */
    .acquisto-content {
      padding: 30px;
    }

    /* Biglietti grid */
    .biglietti-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 20px;
    }

    /* Link biglietto */
    .biglietto-mini-link {
      text-decoration: none;
      color: inherit;
      display: block;
    }

    .biglietto-mini {
      background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
      border: 2px solid var(--border);
      border-left: 4px solid var(--primary);
      border-radius: 12px;
      padding: 20px;
      transition: all 0.3s ease;
      cursor: pointer;
      height: 100%;
    }

    .biglietto-mini-link:hover .biglietto-mini {
      border-color: var(--primary);
      box-shadow: 0 5px 20px rgba(109, 93, 110, 0.2);
      transform: translateX(5px);
    }

    .biglietto-film {
      font-size: 1.2em;
      font-weight: 700;
      color: var(--dark);
      margin-bottom: 15px;
      padding-bottom: 10px;
      border-bottom: 1px solid var(--border);
    }

    .biglietto-info-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 8px;
      font-size: 0.95em;
    }

    .biglietto-label {
      color: #666;
    }

    .biglietto-value {
      font-weight: 600;
      color: var(--dark);
    }

    /* Stato biglietto */
    .stato-badge {
      display: inline-block;
      padding: 5px 12px;
      border-radius: 20px;
      font-size: 0.85em;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .stato-emesso {
      background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
      color: #2e7d32;
    }

    .stato-validato {
      background:white;
      color:var(--primary);
    }

    .stato-rimborsato {
      background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
      color: #f57c00;
    }

    .stato-scaduto {
      background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
      color: #c62828;
    }

    /* QR Code mini */
    .qr-mini {
      margin-top: 15px;
      padding-top: 15px;
      border-top: 1px solid var(--border);
      text-align: center;
    }

    .qr-mini img {
      width: 100px;
      height: 100px;
      border-radius: 8px;
      border: 2px solid var(--border);
    }

    .qr-code-text {
      font-size: 0.75em;
      color: #666;
      margin-top: 5px;
      word-break: break-all;
    }

    /* Actions */
    .back-action {
      margin-top: 40px;
      text-align: center;
    }

    .btn {
      padding: 15px 40px;
      border: none;
      border-radius: 12px;
      font-size: 1.1em;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-block;
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
      .storico-header h1 {
        font-size: 2em;
      }

      .acquisto-header {
        flex-direction: column;
        text-align: center;
      }

      .biglietti-grid {
        grid-template-columns: 1fr;
      }

      .biglietto-mini-link:hover .biglietto-mini {
        transform: translateY(-5px);
      }
    }
  </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Main Content -->
<main>
  <div class="storico-container">

    <!-- Header -->
    <div class="storico-header">
      <div class="storico-header-content">
        <h1>Storico Acquisti</h1>
        <p>Tutti i tuoi biglietti acquistati su Tickema</p>
      </div>
    </div>

    <!-- Lista acquisti -->
    <c:choose>
      <c:when test="${empty acquisti}">
        <!-- Empty State -->
        <div class="empty-state">
          <h2>Nessun acquisto effettuato</h2>
          <p>Non hai ancora acquistato biglietti. Esplora la nostra programmazione!</p>
          <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
            Scopri i Film
          </a>
        </div>
      </c:when>
      <c:otherwise>
        <!-- Acquisti -->
        <c:forEach var="acquisto" items="${acquisti}">
          <div class="acquisto-card">
            <!-- Header Acquisto -->
            <div class="acquisto-header">
              <div>
                <div class="acquisto-numero">Ordine #${acquisto.idAcquisto}</div>
                <div class="acquisto-data">
                  <c:set var="dataOra" value="${acquisto.dataOraAcquisto}" />
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
              <div class="acquisto-importo">
                €<fmt:formatNumber value="${acquisto.importoTotale}" pattern="#,##0.00"/>
              </div>
            </div>

            <!-- Content Acquisto -->
            <div class="acquisto-content">
              <div class="biglietti-grid">
                <c:forEach var="biglietto" items="${bigliettiPerAcquisto[acquisto.idAcquisto]}">
                  <a href="${pageContext.request.contextPath}/biglietto/dettaglio?id=${biglietto.idBiglietto}"
                     class="biglietto-mini-link">
                    <div class="biglietto-mini">
                      <div class="biglietto-film">
                          ${biglietto.programmazione.film.titolo}
                      </div>

                      <div class="biglietto-info-row">
                        <span class="biglietto-label">Data:</span>
                        <span class="biglietto-value">
                            ${biglietto.programmazione.dataProgrammazione}
                        </span>
                      </div>

                      <div class="biglietto-info-row">
                        <span class="biglietto-label">Orario:</span>
                        <span class="biglietto-value">
                            ${biglietto.programmazione.slotOrari.oraInizio}
                        </span>
                      </div>

                      <div class="biglietto-info-row">
                        <span class="biglietto-label">Sala:</span>
                        <span class="biglietto-value">
                            ${biglietto.programmazione.sala.nome}
                        </span>
                      </div>

                      <div class="biglietto-info-row">
                        <span class="biglietto-label">Posto:</span>
                        <span class="biglietto-value">
                                                    Fila ${biglietto.posto.fila}, N. ${biglietto.posto.numeroPosto}
                                                </span>
                      </div>

                      <div class="biglietto-info-row">
                        <span class="biglietto-label">Prezzo:</span>
                        <span class="biglietto-value">
                                                    €<fmt:formatNumber value="${biglietto.prezzoFinale}" pattern="#,##0.00"/>
                                                </span>
                      </div>

                      <div class="biglietto-info-row">
                        <span class="biglietto-label">Stato:</span>
                        <span class="biglietto-value">
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

                      <!-- QR Code Mini -->
                      <c:if test="${biglietto.stato == 'Emesso'}">
                        <div class="qr-mini">
                          <img src="https://api.qrserver.com/v1/create-qr-code/?size=100x100&data=${biglietto.QRCode}"
                               alt="QR Code">
                          <div class="qr-code-text">${biglietto.QRCode}</div>
                        </div>
                      </c:if>
                    </div>
                  </a>
                </c:forEach>
              </div>
            </div>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>

    <!-- Back Action -->
    <div class="back-action">
      <a href="${pageContext.request.contextPath}/utente/mostra-profilo" class="btn btn-secondary">
        Torna al Profilo
      </a>
    </div>

  </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

</body>
</html>