<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gestione Catalogo Film - Tickema</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="admin-container">
  <div class="admin-card">

    <!-- HEADER -->
    <div class="admin-header">
      <h1>Gestione Catalogo Film</h1>
      <p>Inserisci, modifica ed elimina i film dal catalogo cinematografico</p>
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

      <!-- CONFERMA ELIMINAZIONE -->
      <c:if test="${richiestaConferma && not empty film}">
        <div class="alert alert-warning">
          <div>
            <strong>Conferma eliminazione richiesta</strong>
            <p>Stai per eliminare il film: <strong>${film.titolo}</strong></p>
            <p><em>Attenzione: Verifica che non ci siano programmazioni attive associate a questo film.</em></p>
            <div class="btn-group mt-20">
              <form method="POST" action="${pageContext.request.contextPath}/film" style="display:inline;">
                <input type="hidden" name="action" value="elimina">
                <input type="hidden" name="id" value="${film.idFilm}">
                <input type="hidden" name="conferma" value="true">
                <button type="submit" class="btn btn-danger">Conferma Eliminazione</button>
              </form>
              <a href="?action=admin-lista" class="btn btn-secondary">Annulla</a>
            </div>
          </div>
        </div>
      </c:if>

      <!-- FILTRI RICERCA -->
      <div class="form-section">
        <h3>Filtri di Ricerca</h3>
        <form method="GET" action="${pageContext.request.contextPath}/film">
          <input type="hidden" name="action" value="admin-lista">

          <div class="form-row">
            <div class="input-group">
              <label for="titolo">Titolo</label>
              <input type="text" id="titolo" name="titolo"
                     value="${param.titolo}" placeholder="Cerca per titolo...">
            </div>

            <div class="input-group">
              <label for="genere">Genere</label>
              <select id="genere" name="genere">
                <option value="">Tutti i generi</option>
                <option value="Azione" ${param.genere == 'Azione' ? 'selected' : ''}>Azione</option>
                <option value="Commedia" ${param.genere == 'Commedia' ? 'selected' : ''}>Commedia</option>
                <option value="Dramma" ${param.genere == 'Dramma' ? 'selected' : ''}>Dramma</option>
                <option value="Horror" ${param.genere == 'Horror' ? 'selected' : ''}>Horror</option>
                <option value="Fantascienza" ${param.genere == 'Fantascienza' ? 'selected' : ''}>Fantascienza</option>
                <option value="Thriller" ${param.genere == 'Thriller' ? 'selected' : ''}>Thriller</option>
                <option value="Animazione" ${param.genere == 'Animazione' ? 'selected' : ''}>Animazione</option>
              </select>
            </div>

            <div class="input-group">
              <label for="anno">Anno</label>
              <input type="number" id="anno" name="anno"
                     value="${param.anno}" min="1888" max="2030">
            </div>
          </div>

          <div class="btn-group">
            <button type="submit" class="btn btn-primary">Filtra</button>
            <a href="?action=admin-lista" class="btn btn-secondary">↻ Reset</a>
          </div>
        </form>
      </div>

      <!-- TOOLBAR AZIONI -->
      <div class="toolbar">
        <div class="toolbar-left">
          <a href="?action=admin-form-crea" class="btn btn-success">+ Nuovo Film</a>
        </div>
        <div class="toolbar-right">
                    <span class="badge badge-info">
                        ${films != null ? films.size() : 0} Film nel catalogo
                    </span>
        </div>
      </div>

      <!-- TABELLA FILM -->
      <c:choose>
        <c:when test="${empty films}">
          <div class="empty-state">
            <h3>Nessun film trovato</h3>
            <p>Il catalogo è vuoto o non ci sono film che corrispondono ai filtri selezionati.</p>
            <a href="?action=admin-form-crea" class="btn btn-primary">
              Aggiungi il primo film
            </a>
          </div>
        </c:when>

        <c:otherwise>
          <div class="table-container">
            <table class="admin-table">
              <thead>
              <tr>
                <th>ID</th>
                <th>Locandina</th>
                <th>Titolo</th>
                <th>Genere</th>
                <th>Anno</th>
                <th>Durata</th>
                <th>Regista</th>
                <th>Azioni</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach var="film" items="${films}">
                <tr>
                  <td><strong>#${film.idFilm}</strong></td>
                  <td>
                    <c:choose>
                      <c:when test="${not empty film.locandina}">
                        <img src="${film.locandina}"
                             alt="${film.titolo}"
                             class="film-thumbnail"
                             onerror="this.src='${pageContext.request.contextPath}/images/placeholder-film.png'">
                      </c:when>
                      <c:otherwise>
                        <div class="film-thumbnail-placeholder">🎬</div>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <strong>${film.titolo}</strong>
                  </td>
                  <td>
                    <span class="badge badge-secondary">${film.genere}</span>
                  </td>
                  <td>${film.anno}</td>
                  <td>${film.durata} min</td>
                  <td>${film.regista}</td>
                  <td>
                    <div class="btn-group">
                      <a href="${pageContext.request.contextPath}/admin/programmazione?action=lista&idFilm=${film.idFilm}"
                         class="btn btn-small btn-info"
                         title="Programmazioni">
                        📅
                      </a>
                      <a href="?action=admin-form-modifica&id=${film.idFilm}"
                         class="btn btn-small btn-secondary"
                         title="Modifica">
                        ✏
                      </a>
                      <button onclick="confermaEliminazione(${film.idFilm}, '${film.titolo}')"
                              class="btn btn-small btn-danger"
                              title="Elimina">
                        🗑
                      </button>
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

<jsp:include page="/WEB-INF/includes/footer.jsp" />

<!-- JAVASCRIPT -->
<script>
  function confermaEliminazione(idFilm, titolo) {
    if (confirm('Sei sicuro di voler eliminare il film "' + titolo + '"?\n\nATTENZIONE: Verifica che non ci siano programmazioni attive.')) {
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = '${pageContext.request.contextPath}/film';

      const actionInput = document.createElement('input');
      actionInput.type = 'hidden';
      actionInput.name = 'action';
      actionInput.value = 'elimina';
      form.appendChild(actionInput);

      const idInput = document.createElement('input');
      idInput.type = 'hidden';
      idInput.name = 'id';
      idInput.value = idFilm;
      form.appendChild(idInput);

      document.body.appendChild(form);
      form.submit();
    }
  }
</script>