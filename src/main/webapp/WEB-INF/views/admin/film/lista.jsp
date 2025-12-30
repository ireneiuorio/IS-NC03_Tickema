<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gestione Catalogo Film - Tickema</title>

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
    .catalogo-container {
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

    .alert-warning {
      background: #fff3cd;
      color: #856404;
      border: 1px solid #ffeaa7;
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

    .btn-danger {
      background: #dc3545;
      color: white;
    }

    .btn-danger:hover {
      background: #c82333;
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(220, 53, 69, 0.3);
    }

    /* Toolbar */
    .toolbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
    }

    .badge {
      padding: 8px 16px;
      border-radius: 20px;
      font-size: 0.9em;
      font-weight: 600;
    }

    .badge-info {
      background: white;
      color: var(--primary);
    }

    /* Films Grid */
    .films-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 30px;
    }

    .film-card {
      background: white;
      border-radius: 15px;
      overflow: hidden;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
      transition: all 0.3s ease;
    }

    .film-card:hover {
      transform: translateY(-10px);
      box-shadow: 0 15px 40px rgba(109, 93, 110, 0.3);
    }

    .film-poster {
      width: 100%;
      height: 400px;
      position: relative;
      overflow: hidden;
      background: linear-gradient(135deg, #f0f0f0 0%, #e0e0e0 100%);
    }

    .film-poster img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.3s ease;
    }

    .film-card:hover .film-poster img {
      transform: scale(1.05);
    }

    .film-poster-placeholder {
      width: 100%;
      height: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.2em;
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      font-weight: 600;
    }

    .film-info {
      padding: 20px;
    }

    .film-title {
      font-size: 1.3em;
      font-weight: 600;
      color: var(--dark);
      margin-bottom: 10px;
      min-height: 60px;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }

    .film-meta {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      margin-bottom: 15px;
      font-size: 0.9em;
      color: #666;
    }

    .film-badge {
      padding: 4px 10px;
      border-radius: 12px;
      background: #e9ecef;
      font-weight: 500;
    }

    .film-actions {
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
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
      box-shadow: 0 3px 10px rgba(108, 117, 125, 0.3);
    }

    .btn-small-danger {
      background: #dc3545;
      color: white;
    }

    .btn-small-danger:hover {
      background: #c82333;
      transform: translateY(-2px);
      box-shadow: 0 3px 10px rgba(220, 53, 69, 0.3);
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
        gap: 15px;
        align-items: flex-start;
      }

      .films-grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Hero Section -->
<section class="hero">
  <h1>Gestione Catalogo Film</h1>
  <p>Inserisci, modifica ed elimina i film dal catalogo cinematografico</p>
</section>

<!-- Main Content -->
<main>
  <div class="catalogo-container">

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

    <!-- CONFERMA ELIMINAZIONE -->
    <c:if test="${richiestaConferma && not empty film}">
      <div class="alert alert-warning">
        <div style="flex: 1;">
          <strong>Conferma eliminazione richiesta</strong>
          <p style="margin: 10px 0;">Stai per eliminare il film: <strong>${film.titolo}</strong></p>
          <p style="margin: 10px 0;"><em>Attenzione: Verifica che non ci siano programmazioni attive associate a questo film.</em></p>
          <div style="display: flex; gap: 10px; margin-top: 15px;">
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

    <!-- TOOLBAR AZIONI -->
    <div class="toolbar">
      <a href="?action=admin-form-crea" class="btn btn-primary">Nuovo Film</a>
      <span class="badge badge-info">
        ${films != null ? films.size() : 0} Film nel catalogo
      </span>
    </div>

    <!-- GRID FILM -->
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
        <div class="films-grid">
          <c:forEach var="film" items="${films}">
            <div class="film-card">
              <div class="film-poster">
                <c:choose>
                  <c:when test="${not empty film.locandina}">
                    <img src="${film.locandina}"
                         alt="${film.titolo}"
                         onerror="this.parentElement.innerHTML='<div class=\'film-poster-placeholder\'>Nessuna Immagine</div>'">
                  </c:when>
                  <c:otherwise>
                    <div class="film-poster-placeholder">Nessuna Immagine</div>
                  </c:otherwise>
                </c:choose>
              </div>

              <div class="film-info">
                <h3 class="film-title">${film.titolo}</h3>

                <div class="film-meta">
                  <span class="film-badge">#${film.idFilm}</span>
                  <span class="film-badge">${film.genere}</span>
                  <span>${film.anno}</span>
                  <span>${film.durata} min</span>
                </div>

                <div class="film-meta">
                  <span><strong>Regista:</strong> ${film.regista}</span>
                </div>

                <div class="film-actions">
                  <a href="${pageContext.request.contextPath}/admin/programmazione?action=lista&idFilm=${film.idFilm}"
                     class="btn-small btn-small-primary">
                    Programmazioni
                  </a>
                  <a href="?action=admin-form-modifica&id=${film.idFilm}"
                     class="btn-small btn-small-secondary">
                    Modifica
                  </a>
                  <button onclick="confermaEliminazione(${film.idFilm}, '${film.titolo}')"
                          class="btn-small btn-small-danger">
                    Elimina
                  </button>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>

  </div>
</main>

<!-- Footer -->
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

</body>
</html>