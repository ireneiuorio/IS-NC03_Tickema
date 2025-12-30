<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gestione Programmazioni - Tickema</title>

  <!-- CSS Base -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

  <style>
    /* Hero Section */
    .hero {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      padding: 60px 30px;
      text-align: center;
      margin-bottom: 40px;
    }

    .hero h1 {
      font-size: 2.5em;
      font-weight: bold;
      font-style: italic;
      margin-bottom: 10px;
      letter-spacing: 2px;
    }

    .hero p {
      font-size: 1.1em;
      opacity: 0.95;
    }

    /* Container */
    .container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 0 30px 80px;
    }

    /* Messaggi */
    .alert {
      padding: 15px 20px;
      border-radius: 10px;
      margin-bottom: 20px;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .alert-success {
      background: #d4edda;
      color: #155724;
      border: 1px solid #c3e6cb;
    }

    .alert-danger {
      background: #f8d7da;
      color: #721c24;
      border: 1px solid #f5c6cb;
    }

    /* Toolbar */
    .toolbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
      flex-wrap: wrap;
      gap: 15px;
    }

    .toolbar-actions {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
    }

    .badge {
      padding: 8px 16px;
      border-radius: 20px;
      font-size: 0.9em;
      font-weight: 600;
    }

    .badge-info {
      background: white;
      color:var(--primary);

    }

    .btn {
      padding: 12px 24px;
      border: none;
      border-radius: 8px;
      font-size: 1em;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-block;
      text-align: center;
    }

    .btn-primary {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
    }

    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(109, 93, 110, 0.3);
    }

    .btn-secondary {
      background: white;
      color: var(--dark);
      border: 2px solid var(--border);
    }

    .btn-secondary:hover {
      border-color: var(--primary);
      background: var(--light-gray);
    }

    /* Table */
    .table-wrapper {
      background: white;
      border-radius: 15px;
      padding: 30px;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
      overflow-x: auto;
    }

    .programmazioni-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }

    .programmazioni-table thead {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
    }

    .programmazioni-table th {
      padding: 15px;
      text-align: left;
      font-weight: 600;
      font-size: 0.9em;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .programmazioni-table td {
      padding: 15px;
      border-bottom: 1px solid #e9ecef;
    }

    .programmazioni-table tbody tr {
      transition: background 0.3s ease;
    }

    .programmazioni-table tbody tr:hover {
      background: #f8f9fa;
    }

    /* Badge Stati */
    .badge-status {
      padding: 6px 12px;
      border-radius: 12px;
      font-size: 0.85em;
      font-weight: 600;
      display: inline-block;
    }

    .badge-success {
      background: var(--primary);
      color:white;
    }

    .badge-danger {
      background: #f8d7da;
      color: #721c24;
    }

    .badge-warning {
      background: #fff3cd;
      color: #856404;
    }

    .badge-secondary {
      background: #e9ecef;
      color: #495057;
    }

    /* Action Buttons */
    .action-buttons {
      display: flex;
      gap: 8px;
    }

    .btn-small {
      padding: 8px 14px;
      font-size: 0.85em;
      border-radius: 6px;
      border: none;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-block;
      font-weight: 600;
    }

    .btn-small-primary {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
    }

    .btn-small-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 3px 10px rgba(109, 93, 110, 0.3);
    }

    .btn-small-secondary {
      background: #6c757d;
      color: white;
    }

    .btn-small-secondary:hover {
      background: #5a6268;
      transform: translateY(-2px);
    }

    .btn-small-danger {
      background: #dc3545;
      color: white;
    }

    .btn-small-danger:hover {
      background: #c82333;
      transform: translateY(-2px);
    }

    /* Empty State */
    .empty-state {
      text-align: center;
      padding: 60px 20px;
      background: white;
      border-radius: 15px;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
    }

    .empty-state h3 {
      font-size: 2em;
      color: var(--dark);
      margin-bottom: 10px;
    }

    .empty-state p {
      font-size: 1.1em;
      color: #666;
      margin-bottom: 20px;
    }

    /* Responsive */
    @media (max-width: 768px) {
      .hero h1 {
        font-size: 1.8em;
      }

      .toolbar {
        flex-direction: column;
        align-items: flex-start;
      }

      .programmazioni-table {
        font-size: 0.9em;
      }

      .programmazioni-table th,
      .programmazioni-table td {
        padding: 10px 8px;
      }
    }
  </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Hero Section -->
<section class="hero">
  <h1>Gestione Programmazioni</h1>
  <c:choose>
    <c:when test="${not empty film}">
      <p>Film: <strong>${film.titolo}</strong> (${film.durata} min)</p>
    </c:when>
    <c:otherwise>
      <p>Crea, modifica ed elimina le programmazioni cinematografiche</p>
    </c:otherwise>
  </c:choose>
</section>

<!-- Main Content -->
<main>
  <div class="container">

    <!-- MESSAGGI -->
    <c:if test="${not empty sessionScope.messaggioSuccesso}">
      <div class="alert alert-success">
        <span>${sessionScope.messaggioSuccesso}</span>
      </div>
      <c:remove var="messaggioSuccesso" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.messaggioErrore}">
      <div class="alert alert-danger">
        <span>${sessionScope.messaggioErrore}</span>
      </div>
      <c:remove var="messaggioErrore" scope="session"/>
    </c:if>

    <!-- TOOLBAR -->
    <div class="toolbar">
      <div class="toolbar-actions">
        <c:if test="${not empty param.idFilm}">
          <a href="?action=formCrea&idFilm=${param.idFilm}" class="btn btn-primary">
            Nuova Programmazione
          </a>
          <a href="?action=formMultipla&idFilm=${param.idFilm}" class="btn btn-secondary">
            Creazione Multipla
          </a>
        </c:if>
      </div>
      <span class="badge badge-info">
        ${programmazioni.size()} Programmazioni
      </span>
    </div>

    <!-- TABELLA PROGRAMMAZIONI -->
    <c:choose>
      <c:when test="${empty programmazioni}">
        <div class="empty-state">
          <h3>Nessuna programmazione trovata</h3>
          <p>Non ci sono programmazioni per i filtri selezionati</p>
          <c:if test="${not empty param.idFilm}">
            <a href="?action=formCrea&idFilm=${param.idFilm}" class="btn btn-primary">
              Crea la prima programmazione
            </a>
          </c:if>
        </div>
      </c:when>

      <c:otherwise>
        <div class="table-wrapper">
          <table class="programmazioni-table">
            <thead>
            <tr>
              <th>ID</th>
              <th>Data</th>
              <th>Film</th>
              <th>Sala</th>
              <th>Orario</th>
              <th>Prezzo</th>
              <th>Tipo</th>
              <th>Stato</th>
              <th>Azioni</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="prog" items="${programmazioni}">
              <tr>
                <td><strong>#${prog.idProgrammazione}</strong></td>
                <td>${prog.dataProgrammazione}</td>
                <td>${prog.film.titolo}</td>
                <td>Sala ${prog.sala.nome}</td>
                <td>${prog.slotOrari.oraInizio} - ${prog.slotOrari.oraFine}</td>
                <td><strong>€ <fmt:formatNumber value="${prog.prezzoBase}" pattern="#,##0.00"/></strong></td>
                <td>${prog.tipo}</td>
                <td>
                  <c:choose>
                    <c:when test="${prog.stato == 'Disponibile'}">
                      <span class="badge-status badge-success">Disponibile</span>
                    </c:when>
                    <c:when test="${prog.stato == 'Annullata'}">
                      <span class="badge-status badge-danger">Annullata</span>
                    </c:when>
                    <c:when test="${prog.stato == 'In Corso'}">
                      <span class="badge-status badge-warning">In Corso</span>
                    </c:when>
                    <c:when test="${prog.stato == 'Conclusa'}">
                      <span class="badge-status badge-secondary">Conclusa</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge-status badge-warning">${prog.stato}</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <div class="action-buttons">
                    <a href="?action=dettaglio&id=${prog.idProgrammazione}"
                       class="btn-small btn-small-primary">
                      Dettagli
                    </a>
                    <c:if test="${prog.stato == 'Disponibile'}">
                      <a href="?action=formModifica&id=${prog.idProgrammazione}"
                         class="btn-small btn-small-secondary">
                        Modifica
                      </a>
                    </c:if>
                    <c:if test="${prog.stato != 'Conclusa'}">
                      <button onclick="confermaEliminazione(${prog.idProgrammazione}, ${prog.idFilm})"
                              class="btn-small btn-small-danger">
                        Elimina
                      </button>
                    </c:if>
                  </div>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </c:otherwise>
    </c:choose>

  </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

<!-- JAVASCRIPT -->
<script>
  function confermaEliminazione(idProgrammazione, idFilm) {
    if (confirm('ATTENZIONE!\n\nSei sicuro di voler eliminare questa programmazione?\n\n• Tutti i biglietti venduti verranno RIMBORSATI automaticamente\n• Lo slot orario verrà liberato\n• Questa azione NON può essere annullata')) {
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = '${pageContext.request.contextPath}/admin/programmazione';

      const params = {
        'action': 'elimina',
        'id': idProgrammazione,
        'idFilm': idFilm,
        'conferma': 'true'
      };

      for (let key in params) {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = key;
        input.value = params[key];
        form.appendChild(input);
      }

      document.body.appendChild(form);
      form.submit();
    }
  }
</script>

</body>
</html>