<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gestione Programmazioni - Tickema</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-style.css">
</head>
<body>

<div class="admin-container">
  <div class="admin-card">

    <!-- HEADER -->
    <div class="admin-header">
      <h1>Gestione Programmazioni</h1>
      <c:choose>
        <c:when test="${not empty film}">
          <p>Film: <strong>${film.titolo}</strong> (${film.durata} min)</p>
        </c:when>
        <c:otherwise>
          <p>Crea, modifica ed elimina le programmazioni cinematografiche</p>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="admin-content">

      <!-- MESSAGGI -->
      <c:if test="${not empty sessionScope.messaggioSuccesso}">
        <div class="alert alert-success">
          <span class="alert-icon">✓</span>
          <span>${sessionScope.messaggioSuccesso}</span>
        </div>
        <c:remove var="messaggioSuccesso" scope="session"/>
      </c:if>

      <c:if test="${not empty sessionScope.messaggioErrore}">
        <div class="alert alert-danger">
          <span class="alert-icon">✕</span>
          <span>${sessionScope.messaggioErrore}</span>
        </div>
        <c:remove var="messaggioErrore" scope="session"/>
      </c:if>

      <!-- FILTRI -->
      <div class="form-section">
        <h3>Filtri di Ricerca</h3>
        <form method="GET" action="${pageContext.request.contextPath}/admin/programmazione">
          <input type="hidden" name="action" value="lista">

          <div class="form-row">
            <div class="input-group">
              <label for="data">Data</label>
              <input type="date" id="data" name="data" value="${param.data}">
            </div>

            <div class="input-group">
              <label for="idFilm">ID Film</label>
              <input type="number" id="idFilm" name="idFilm" value="${param.idFilm}" min="1">
            </div>

            <div class="input-group">
              <label for="idSala">ID Sala</label>
              <input type="number" id="idSala" name="idSala" value="${param.idSala}" min="1">
            </div>
          </div>

          <div class="btn-group">
            <button type="submit" class="btn btn-primary">Filtra</button>
            <a href="?action=lista" class="btn btn-secondary">↻ Reset</a>
          </div>
        </form>
      </div>

      <!-- TOOLBAR AZIONI -->
      <div class="toolbar">
        <div class="toolbar-left">
          <c:if test="${not empty param.idFilm}">
            <a href="?action=formCrea&idFilm=${param.idFilm}" class="btn btn-success">
              Nuova Programmazione
            </a>
            <a href="?action=formMultipla&idFilm=${param.idFilm}" class="btn btn-primary">
              Creazione Multipla
            </a>
          </c:if>
        </div>
        <div class="toolbar-right">
                    <span class="badge badge-info">
                        ${programmazioni.size()} Programmazioni
                    </span>
        </div>
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
          <div class="table-container">
            <table class="admin-table">
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
                  <td>
                    <fmt:formatDate value="${prog.dataProgrammazione}" pattern="dd/MM/yyyy" type="date"/>
                  </td>
                  <td>${prog.film.titolo}</td>
                  <td>Sala ${prog.sala.nome}</td>
                  <td>
                    <fmt:formatDate value="${prog.slotOrari.oraInizio}" pattern="HH:mm" type="time"/> -
                    <fmt:formatDate value="${prog.slotOrari.oraFine}" pattern="HH:mm" type="time"/>
                  </td>
                  <td><strong>€ <fmt:formatNumber value="${prog.prezzoBase}" pattern="#,##0.00"/></strong></td>
                  <td>${prog.tipo}</td>
                  <td>
                    <c:choose>
                      <c:when test="${prog.stato == 'DISPONIBILE'}">
                        <span class="badge badge-success">✓ Disponibile</span>
                      </c:when>
                      <c:when test="${prog.stato == 'ANNULLATA'}">
                        <span class="badge badge-danger">✕ Annullata</span>
                      </c:when>
                      <c:when test="${prog.stato == 'IN CORSO'}">
                        <span class="badge badge-info">▶ In Corso</span>
                      </c:when>
                      <c:when test="${prog.stato == 'CONCLUSA'}">
                        <span class="badge badge-secondary">■ Conclusa</span>
                      </c:when>
                      <c:otherwise>
                        <span class="badge badge-warning">${prog.stato}</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <div class="btn-group">
                      <a href="?action=dettaglio&id=${prog.idProgrammazione}"
                         class="btn btn-small btn-primary" title="Dettagli">
                      </a>
                      <c:if test="${prog.stato == 'DISPONIBILE'}">
                        <a href="?action=formModifica&id=${prog.idProgrammazione}"
                           class="btn btn-small btn-secondary" title="Modifica">
                        </a>
                      </c:if>
                      <c:if test="${prog.stato != 'CONCLUSA'}">
                        <button onclick="confermaEliminazione(${prog.idProgrammazione}, ${prog.idFilm})"
                                class="btn btn-small btn-danger" title="Elimina">
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
  </div>
</div>

<!-- JAVASCRIPT -->
<script>
  function confermaEliminazione(idProgrammazione, idFilm) {
    if (confirm('ATTENZIONE!\n\nSei sicuro di voler eliminare questa programmazione?\n\n• Tutti i biglietti venduti verranno RIMBORSATI automaticamente\n• Lo slot orario verrà liberato\n• Questa azione NON può essere annullata')) {
      // Crea form nascosto per POST
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = '${pageContext.request.contextPath}/admin/programmazione';

      // Aggiungi parametri
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