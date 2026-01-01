<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gestione Acquisti - Tickema Admin</title>

  <!-- CSS Base -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <style>
    /* Container */
    .acquisti-container {
      max-width: 1400px;
      margin: 40px auto;
      padding: 0 20px;
    }

    /* Header */
    .acquisti-header {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      padding: 50px 30px;
      border-radius: 20px;
      margin-bottom: 40px;
      box-shadow: 0 10px 40px rgba(109, 93, 110, 0.3);
      position: relative;
      overflow: hidden;
    }

    .acquisti-header::before {
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

    .acquisti-header-content {
      position: relative;
      z-index: 1;
    }

    .acquisti-header h1 {
      font-size: 2.5em;
      font-weight: 700;
      margin-bottom: 10px;
      letter-spacing: 1px;
    }

    .acquisti-header p {
      font-size: 1.1em;
      opacity: 0.95;
    }

    /* Statistiche */
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
      margin-bottom: 40px;
    }

    .stat-card {
      background: white;
      border-radius: 15px;
      padding: 25px;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
      border-left: 4px solid var(--primary);
      transition: all 0.3s ease;
    }

    .stat-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 30px rgba(109, 93, 110, 0.15);
    }

    .stat-label {
      font-size: 0.9em;
      color: #666;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      margin-bottom: 8px;
    }

    .stat-value {
      font-size: 2.5em;
      font-weight: 700;
      color: var(--primary);
    }

    /* Filtri */
    .controls-section {
      background: white;
      border-radius: 15px;
      padding: 30px;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
      margin-bottom: 30px;
    }

    .filter-buttons {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
    }

    .filter-btn {
      padding: 12px 24px;
      border: 2px solid var(--border);
      background: white;
      color: var(--dark);
      border-radius: 10px;
      cursor: pointer;
      font-weight: 600;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-block;
    }

    .filter-btn:hover {
      border-color: var(--primary);
      background: var(--light-gray);
    }

    .filter-btn.active {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      border-color: var(--primary);
    }

    /* Tabella Acquisti */
    .acquisti-table-wrapper {
      background: white;
      border-radius: 15px;
      overflow: hidden;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
    }

    .acquisti-table {
      width: 100%;
      border-collapse: collapse;
    }

    .acquisti-table thead {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
    }

    .acquisti-table th {
      padding: 20px;
      text-align: left;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      font-size: 0.9em;
    }

    .acquisti-table td {
      padding: 20px;
      border-bottom: 1px solid #f0f0f0;
    }

    .acquisti-table tbody tr {
      transition: all 0.3s ease;
    }

    .acquisti-table tbody tr:hover {
      background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
    }

    .acquisti-table tbody tr:last-child td {
      border-bottom: none;
    }

    /* Badge Stato */
    .stato-badge {
      display: inline-block;
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 0.85em;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .stato-completato {
      background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
      color: #2e7d32;
    }

    .stato-rimborsato {
      background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
      color: #f57c00;
    }

    /* Empty State */
    .empty-state {
      text-align: center;
      padding: 80px 20px;
      color: #666;
    }

    .empty-state h3 {
      color: var(--dark);
      font-size: 1.5em;
      margin-bottom: 10px;
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

    /* Responsive */
    @media (max-width: 768px) {
      .acquisti-header h1 {
        font-size: 2em;
      }

      .stats-grid {
        grid-template-columns: repeat(2, 1fr);
      }

      .filter-buttons {
        width: 100%;
      }

      .filter-btn {
        flex: 1;
      }

      .acquisti-table-wrapper {
        overflow-x: auto;
      }

      .acquisti-table {
        min-width: 800px;
      }
    }
  </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Main Content -->
<main>
  <div class="acquisti-container">

    <!-- Header -->
    <div class="acquisti-header">
      <div class="acquisti-header-content">
        <h1>Gestione Acquisti</h1>
        <p>Visualizza tutti gli acquisti effettuati nel sistema</p>
      </div>
    </div>

    <!-- Statistiche -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-label">Totale Acquisti</div>
        <div class="stat-value">${totaleAcquisti}</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Completati</div>
        <div class="stat-value">${totaleCompletati}</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Rimborsati</div>
        <div class="stat-value">${totaleRimborsati}</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Importo Totale</div>
        <div class="stat-value">€<fmt:formatNumber value="${importoTotale}" pattern="#,##0"/></div>
      </div>
    </div>

    <!-- Filtri -->
    <div class="controls-section">
      <div class="filter-buttons">
        <a href="${pageContext.request.contextPath}/admin/gestione-acquisti"
           class="filter-btn ${empty statoFiltro ? 'active' : ''}">
          Tutti
        </a>
        <a href="${pageContext.request.contextPath}/admin/gestione-acquisti?stato=Completato"
           class="filter-btn ${statoFiltro == 'Completato' ? 'active' : ''}">
          Completati
        </a>
        <a href="${pageContext.request.contextPath}/admin/gestione-acquisti?stato=Rimborsato"
           class="filter-btn ${statoFiltro == 'Rimborsato' ? 'active' : ''}">
          Rimborsati
        </a>
      </div>
    </div>

    <!-- Tabella Acquisti -->
    <c:choose>
      <c:when test="${empty acquisti}">
        <div class="acquisti-table-wrapper">
          <div class="empty-state">
            <h3>Nessun acquisto trovato</h3>
            <p>Non ci sono acquisti da visualizzare</p>
          </div>
        </div>
      </c:when>
      <c:otherwise>
        <div class="acquisti-table-wrapper">
          <table class="acquisti-table">
            <thead>
            <tr>
              <th>ID Acquisto</th>
              <th>Data e Ora</th>
              <th>Utente</th>
              <th>Numero Biglietti</th>
              <th>Importo Totale</th>
              <th>Stato</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="acquisto" items="${acquisti}">
              <tr>
                <td>#${acquisto.idAcquisto}</td>
                <td>
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
                </td>
                <td>
                    ${acquisto.utente.nome} ${acquisto.utente.cognome}
                  <br>
                  <small style="color: #666;">${acquisto.utente.email}</small>
                </td>
                <td>${acquisto.numeroBiglietti}</td>
                <td>€<fmt:formatNumber value="${acquisto.importoTotale}" pattern="#,##0.00"/></td>
                <td>
                  <c:choose>
                    <c:when test="${acquisto.stato == 'Completato'}">
                      <span class="stato-badge stato-completato">Completato</span>
                    </c:when>
                    <c:when test="${acquisto.stato == 'Rimborsato'}">
                      <span class="stato-badge stato-rimborsato">Rimborsato</span>
                    </c:when>
                    <c:otherwise>
                      <span class="stato-badge">${acquisto.stato}</span>
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </c:otherwise>
    </c:choose>

    <!-- Back Action -->
    <div class="back-action">
      <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">
        Torna alla Dashboard
      </a>
    </div>

  </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

</body>
</html>