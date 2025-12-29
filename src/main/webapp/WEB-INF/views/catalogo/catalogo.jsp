<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Catalogo Film - Tickema</title>

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
      font-size: 3em;
      font-weight: bold;
      font-style: italic;
      margin-bottom: 15px;
      letter-spacing: 2px;
    }

    .hero p {
      font-size: 1.2em;
      opacity: 0.95;
    }

    /* Container */
    .catalogo-container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 0 30px 80px;
    }

    /* Filtri Section */
    .filtri-section {
      background: white;
      border-radius: 15px;
      padding: 30px;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
      margin-bottom: 40px;
    }

    .filtri-title {
      font-size: 1.8em;
      color: var(--dark);
      margin-bottom: 25px;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .filtri-form {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
    }

    .filtro-group {
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .filtro-group.full-width {
      grid-column: 1 / -1;
    }

    .filtro-label {
      font-weight: 600;
      color: var(--dark);
      font-size: 0.95em;
    }

    .filtro-input,
    .filtro-select {
      padding: 12px 15px;
      border: 2px solid var(--border);
      border-radius: 8px;
      font-size: 1em;
      transition: all 0.3s ease;
    }

    .filtro-input:focus,
    .filtro-select:focus {
      outline: none;
      border-color: var(--primary);
      box-shadow: 0 0 0 3px rgba(109, 93, 110, 0.1);
    }

    /* Checkbox Filtro */
    .filtro-checkbox-wrapper {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 14px 18px;
      margin-top:-10px;
      background: white;
      border: 1px solid var(--border);
      border-radius: 8px;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .filtro-checkbox-wrapper:hover {
      border-color: var(--primary);
      background: #fafafa;
    }

    .filtro-checkbox {
      width: 18px;
      height: 18px;
      cursor: pointer;
      accent-color: var(--primary);
      flex-shrink: 0;
    }

    .filtro-checkbox-wrapper label {
      font-size: 0.95em;
      color: var(--dark);
      cursor: pointer;
      user-select: none;
      font-weight: 500;
    }

    .filtri-actions {
      grid-column: 1 / -1;
      display: flex;
      gap: 15px;
      margin-top: 10px;
    }

    .btn-filtro {
      flex: 1;
      padding: 14px 30px;
      border: none;
      border-radius: 10px;
      font-size: 1.1em;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .btn-cerca {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
    }

    .btn-cerca:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(109, 93, 110, 0.3);
    }

    .btn-reset {
      background: white;
      color: var(--dark);
      border: 2px solid var(--border);
    }

    .btn-reset:hover {
      border-color: var(--primary);
      background: var(--light-gray);
    }

    /* Risultati */
    .risultati-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
    }

    .risultati-count {
      font-size: 1.3em;
      color: var(--dark);
      font-weight: 600;
    }

    /* Grid Film */
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
      cursor: pointer;
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
      font-size: 4em;
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
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
      gap: 15px;
      margin-bottom: 15px;
      font-size: 0.9em;
      color: #666;
    }

    .film-meta span {
      display: flex;
      align-items: center;
      gap: 5px;
    }

    .film-actions {
      display: flex;
      gap: 10px;
    }

    .btn-film {
      flex: 1;
      padding: 12px 20px;
      border: none;
      border-radius: 8px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      text-align: center;
      display: inline-block;
    }

    .btn-primary-film {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
    }

    .btn-primary-film:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(109, 93, 110, 0.3);
    }

    /* Nessun Risultato */
    .no-results {
      text-align: center;
      padding: 60px 20px;
      background: white;
      border-radius: 15px;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
    }

    .no-results-icon {
      font-size: 5em;
      margin-bottom: 20px;
      opacity: 0.3;
    }

    .no-results h2 {
      font-size: 2em;
      color: var(--dark);
      margin-bottom: 10px;
    }

    .no-results p {
      font-size: 1.1em;
      color: #666;
      margin-bottom: 20px;
    }

    /* Responsive */
    @media (max-width: 768px) {
      .hero h1 {
        font-size: 2em;
      }

      .filtri-form {
        grid-template-columns: 1fr;
      }

      .filtri-actions {
        flex-direction: column;
      }

      .films-grid {
        grid-template-columns: 1fr;
      }

      .risultati-header {
        flex-direction: column;
        gap: 15px;
        align-items: flex-start;
      }
    }

  </style>
</head>
<body>
<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Hero Section -->
<section class="hero">
  <h1>Catalogo Film</h1>
  <p>Esplora la nostra collezione completa</p>
</section>

<!-- Main Content -->
<main>
  <div class="catalogo-container">

    <!-- Filtri -->
    <div class="filtri-section">
      <h2 class="filtri-title">Ricerca e Filtri</h2>

      <form method="GET" action="${pageContext.request.contextPath}/catalogo" class="filtri-form">

        <!-- Ricerca per Titolo -->
        <div class="filtro-group full-width">
          <label class="filtro-label">Titolo</label>
          <input type="text"
                 name="titolo"
                 class="filtro-input"
                 placeholder="Cerca per titolo..."
                 value="${searchTitolo}">
        </div>

        <!-- Genere -->
        <div class="filtro-group">
          <label class="filtro-label">Genere</label>
          <select name="genere" class="filtro-select">
            <option value="">Tutti i generi</option>
            <c:forEach var="g" items="${generiDisponibili}">
              <option value="${g}" ${genereSelezionato == g ? 'selected' : ''}>${g}</option>
            </c:forEach>
          </select>
        </div>

        <!-- Anno -->
        <div class="filtro-group">
          <label class="filtro-label">Anno</label>
          <select name="anno" class="filtro-select">
            <option value="">Tutti gli anni</option>
            <c:forEach var="a" items="${anniDisponibili}">
              <option value="${a}" ${annoSelezionato == a ? 'selected' : ''}>${a}</option>
            </c:forEach>
          </select>
        </div>

        <!-- Durata Minima -->
        <div class="filtro-group">
          <label class="filtro-label">Durata minima (min)</label>
          <input type="number"
                 name="durataMin"
                 class="filtro-input"
                 placeholder="es. 90"
                 min="0"
                 value="${durataMin != null ? durataMin : ''}">
        </div>

        <!-- Durata Massima -->
        <div class="filtro-group">
          <label class="filtro-label">Durata massima (min)</label>
          <input type="number"
                 name="durataMax"
                 class="filtro-input"
                 placeholder="es. 180"
                 min="0"
                 value="${durataMax != null ? durataMax : ''}">
        </div>

        <!-- Data Proiezione -->
        <div class="filtro-group">
          <label class="filtro-label">Data proiezione</label>
          <input type="date"
                 name="dataProiezione"
                 class="filtro-input"
                 value="${dataProiezione != null ? dataProiezione : ''}">
        </div>

        <!-- Solo in Programmazione -->
        <div class="filtro-group">
          <label class="filtro-label" style="margin-bottom: 8px;">Disponibilità</label>
          <div class="filtro-checkbox-wrapper" onclick="toggleCheckbox('inProgrammazione')">
            <input type="checkbox"
                   id="inProgrammazione"
                   name="inProgrammazione"
                   value="true"
                   class="filtro-checkbox"
            ${inProgrammazione ? 'checked' : ''}>

            <label for="inProgrammazione" style="cursor: pointer; user-select: none;">
              Solo film in programmazione
            </label>
          </div>
        </div>

        <!-- Azioni -->
        <div class="filtri-actions">
          <button type="submit" class="btn-filtro btn-cerca">
            Cerca
          </button>
          <button type="button" class="btn-filtro btn-reset" onclick="resetFiltri()">
            Reset
          </button>
        </div>
      </form>
    </div>

    <!-- Risultati -->
    <div class="risultati-header">
      <div class="risultati-count">
        <c:choose>
          <c:when test="${fn:length(films) == 0}">
            Nessun film trovato
          </c:when>
          <c:when test="${fn:length(films) == 1}">
            1 film trovato
          </c:when>
          <c:otherwise>
            ${fn:length(films)} film trovati
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <!-- Grid Film -->
    <c:choose>
      <c:when test="${not empty films}">
        <div class="films-grid">
          <c:forEach var="film" items="${films}">
            <div class="film-card">
              <div class="film-poster">
                <c:choose>
                  <c:when test="${not empty film.locandina}">
                    <img src="${film.locandina}"
                         alt="${film.titolo}"
                         onerror="this.parentElement.innerHTML='<div class=\'film-poster-placeholder\'></div>'">
                  </c:when>
                  <c:otherwise>
                    <div class="film-poster-placeholder"></div>
                  </c:otherwise>
                </c:choose>
              </div>

              <div class="film-info">
                <h3 class="film-title">${film.titolo}</h3>

                <div class="film-meta">
                  <span>${film.durata} min</span>
                  <span>${film.genere}</span>
                  <c:if test="${not empty film.anno && film.anno > 0}">
                    <span>${film.anno}</span>
                  </c:if>
                </div>

                <div class="film-actions">
                  <a href="${pageContext.request.contextPath}/dettaglio-film?idFilm=${film.idFilm}"
                     class="btn-film btn-primary-film">
                    Dettagli
                  </a>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:when>
      <c:otherwise>
        <!-- Nessun Risultato -->
        <div class="no-results">
          <div class="no-results-icon"></div>
          <h2>Nessun film trovato</h2>
          <p>Prova a modificare i filtri di ricerca</p>
          <button class="btn-filtro btn-cerca" onclick="resetFiltri()">
            Reset Filtri
          </button>
        </div>
      </c:otherwise>
    </c:choose>

  </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script>
  // Toggle checkbox programmaticamente
  function toggleCheckbox(id) {
    const checkbox = document.getElementById(id);
    checkbox.checked = !checkbox.checked;
  }

  // Reset filtri
  function resetFiltri() {
    window.location.href = '${pageContext.request.contextPath}/catalogo';
  }
</script>

</body>
</html>