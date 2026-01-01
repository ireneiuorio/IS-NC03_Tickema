<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gestione Utenti - Tickema Admin</title>

  <!-- CSS Base -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <style>
    /* Container */
    .utenti-container {
      max-width: 1400px;
      margin: 40px auto;
      padding: 0 20px;
    }

    /* Header */
    .utenti-header {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      padding: 50px 30px;
      border-radius: 20px;
      margin-bottom: 40px;
      box-shadow: 0 10px 40px rgba(109, 93, 110, 0.3);
      position: relative;
      overflow: hidden;
    }

    .utenti-header::before {
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

    .utenti-header-content {
      position: relative;
      z-index: 1;
    }

    .utenti-header h1 {
      font-size: 2.5em;
      font-weight: 700;
      margin-bottom: 10px;
      letter-spacing: 1px;
    }

    .utenti-header p {
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

    /* Filtri e Ricerca */
    .controls-section {
      background: white;
      border-radius: 15px;
      padding: 30px;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
      margin-bottom: 30px;
    }

    .controls-grid {
      display: grid;
      grid-template-columns: 1fr auto;
      gap: 20px;
      align-items: end;
    }

    .search-group {
      position: relative;
    }

    .search-input {
      width: 100%;
      padding: 15px 50px 15px 20px;
      border: 2px solid var(--border);
      border-radius: 10px;
      font-size: 1em;
      transition: all 0.3s ease;
    }

    .search-input:focus {
      outline: none;
      border-color: var(--primary);
      box-shadow: 0 0 0 4px rgba(109, 93, 110, 0.1);
    }

    .search-btn {
      position: absolute;
      right: 5px;
      top: 50%;
      transform: translateY(-50%);
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 8px;
      cursor: pointer;
      font-weight: 600;
      transition: all 0.3s ease;
    }

    .search-btn:hover {
      transform: translateY(-50%) scale(1.05);
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

    /* Tabella Utenti */
    .utenti-table-wrapper {
      background: white;
      border-radius: 15px;
      overflow: hidden;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
    }

    .utenti-table {
      width: 100%;
      border-collapse: collapse;
    }

    .utenti-table thead {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
    }

    .utenti-table th {
      padding: 20px;
      text-align: left;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      font-size: 0.9em;
    }

    .utenti-table td {
      padding: 20px;
      border-bottom: 1px solid #f0f0f0;
    }

    .utenti-table tbody tr {
      transition: all 0.3s ease;
    }

    .utenti-table tbody tr:hover {
      background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
    }

    .utenti-table tbody tr:last-child td {
      border-bottom: none;
    }

    /* Badge Tipo */
    .tipo-badge {
      display: inline-block;
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 0.85em;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .tipo-cliente {
      background:white;
      color:var(--primary);
    }

    .tipo-personale {
      background:white;
      color:var(--primary);
    }

    .tipo-admin {
      background:white;
      color:var(--primary);
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
    .tipo-utente {
      background:white;
      color:var(--primary);
    }

    .btn-secondary:hover {
      background: var(--light-gray);
      transform: translateY(-2px);
    }

    /* Responsive */
    @media (max-width: 768px) {
      .utenti-header h1 {
        font-size: 2em;
      }

      .stats-grid {
        grid-template-columns: repeat(2, 1fr);
      }

      .controls-grid {
        grid-template-columns: 1fr;
      }

      .filter-buttons {
        width: 100%;
      }

      .filter-btn {
        flex: 1;
      }

      .utenti-table-wrapper {
        overflow-x: auto;
      }

      .utenti-table {
        min-width: 600px;
      }
    }
  </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Main Content -->
<main>
  <div class="utenti-container">

    <!-- Header -->
    <div class="utenti-header">
      <div class="utenti-header-content">
        <h1>Gestione Utenti</h1>
        <p>Visualizza e gestisci tutti gli utenti registrati</p>
      </div>
    </div>

    <!-- Statistiche -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-label">Totale Utenti</div>
        <div class="stat-value">${totaleUtenti}</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Utenti</div>
        <div class="stat-value">${totaleUtente}</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Personale</div>
        <div class="stat-value">${totalePersonale}</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Amministratori</div>
        <div class="stat-value">${totaleAdmin}</div>
      </div>
    </div>

    <!-- Controlli -->
    <div class="controls-section">
      <div class="controls-grid">
        <!-- Ricerca -->
        <form method="GET" action="${pageContext.request.contextPath}/admin/utenti" class="search-group">
          <input type="text"
                 name="search"
                 class="search-input"
                 placeholder="Cerca per nome, cognome o email..."
                 value="${searchQuery}">
          <button type="submit" class="search-btn">Cerca</button>
        </form>

        <!-- Filtri -->
        <!-- Filtri -->
        <div class="filter-buttons">
          <a href="${pageContext.request.contextPath}/admin/utenti"
             class="filter-btn ${empty tipoFiltro ? 'active' : ''}">
            Tutti
          </a>
          <a href="${pageContext.request.contextPath}/admin/utenti?tipo=Utente"
             class="filter-btn ${tipoFiltro == 'Utente' ? 'active' : ''}">
            Utenti
          </a>
          <a href="${pageContext.request.contextPath}/admin/utenti?tipo=Personale"
             class="filter-btn ${tipoFiltro == 'Personale' ? 'active' : ''}">
            Personale
          </a>
          <a href="${pageContext.request.contextPath}/admin/utenti?tipo=Admin"
             class="filter-btn ${tipoFiltro == 'Admin' ? 'active' : ''}">
            Admin
          </a>
        </div>
      </div>
    </div>

    <!-- Tabella Utenti -->
    <c:choose>
      <c:when test="${empty utenti}">
        <div class="utenti-table-wrapper">
          <div class="empty-state">
            <h3>Nessun utente trovato</h3>
            <p>Prova a modificare i filtri di ricerca</p>
          </div>
        </div>
      </c:when>
      <c:otherwise>
        <div class="utenti-table-wrapper">
          <table class="utenti-table">
            <thead>
            <tr>
              <th>ID</th>
              <th>Nome</th>
              <th>Cognome</th>
              <th>Email</th>
              <th>Telefono</th>
              <th>Tipo Account</th>
              <th>Saldo</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="utente" items="${utenti}">
              <tr>
                <td>#${utente.idAccount}</td>
                <td>${utente.nome}</td>
                <td>${utente.cognome}</td>
                <td>${utente.email}</td>
                <td>${utente.numeroDiTelefono}</td>
                <td>
                  <c:choose>
                    <c:when test="${utente.tipoAccount == 'Utente'}">
                      <span class="tipo-badge tipo-utente">Utente</span>
                    </c:when>
                    <c:when test="${utente.tipoAccount == 'Personale'}">
                      <span class="tipo-badge tipo-personale">Personale</span>
                    </c:when>
                    <c:when test="${utente.tipoAccount == 'Admin'}">
                      <span class="tipo-badge tipo-admin">Admin</span>
                    </c:when>
                    <c:otherwise>
                      <span class="tipo-badge">${utente.tipoAccount}</span>
                    </c:otherwise>
                  </c:choose>
                </td>

                <td>€<fmt:formatNumber value="${utente.saldo}" pattern="#,##0.00"/></td>
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