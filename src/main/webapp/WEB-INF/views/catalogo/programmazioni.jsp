<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Programmazioni - Tickema</title>

  <!-- CSS Base -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

  <style>
    /* Hero Section */
    .hero {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      padding: 60px 30px;
      text-align: center;
      margin-bottom: 60px;
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
    .programmazioni-container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 30px 80px;
    }

    /* Info Header */
    .info-header {
      margin-bottom: 30px;
    }

    .info-count {
      font-size: 1.2em;
      color: var(--dark);
      font-weight: 600;
    }

    /* Grid Programmazioni */
    .programmazioni-grid {
      display: grid;
      gap: 20px;
    }

    .prog-card {
      background: white;
      border: 1px solid #e8e8e8;
      border-radius: 12px;
      padding: 28px;
      transition: all 0.3s ease;
      display: grid;
      grid-template-columns: 140px 1fr auto;
      gap: 25px;
      align-items: center;
    }

    .prog-card:hover {
      border-color: var(--primary);
      box-shadow: 0 4px 20px rgba(109, 93, 110, 0.1);
      transform: translateY(-2px);
    }

    /* Poster */
    .prog-poster {
      width: 140px;
      height: 200px;
      border-radius: 8px;
      overflow: hidden;
      background: linear-gradient(135deg, #f0f0f0 0%, #e0e0e0 100%);
    }

    .prog-poster img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .prog-poster-placeholder {
      width: 100%;
      height: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 3em;
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
    }

    /* Info */
    .prog-info {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    .prog-title {
      font-size: 1.5em;
      font-weight: 600;
      color: var(--dark);
      margin-bottom: 5px;
    }

    .prog-meta {
      display: flex;
      flex-wrap: wrap;
      gap: 15px;
      font-size: 0.95em;
      color: #666;
    }

    .prog-meta span {
      display: flex;
      align-items: center;
      gap: 5px;
    }

    .prog-details {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
      gap: 15px;
      margin-top: 8px;
    }

    .detail-item {
      display: flex;
      flex-direction: column;
      gap: 3px;
    }

    .detail-label {
      font-size: 0.75em;
      color: #aaa;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .detail-value {
      font-size: 1em;
      color: var(--dark);
      font-weight: 600;
    }

    .detail-price {
      font-size: 1.5em;
      color: var(--primary);
      font-weight: 700;
    }

    /* Actions */
    .prog-actions {
      display: flex;
      flex-direction: column;
      gap: 10px;
      align-items: flex-end;
    }

    .btn-acquista {
      padding: 8px 20px;
      margin:auto;
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      border: none;
      border-radius: 8px;
      font-size: 1em;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      white-space: nowrap;
    }

    .btn-acquista:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(109, 93, 110, 0.25);
    }

    .btn-dettagli {
      padding: 8px 20px;
      background: white;
      color: var(--primary);
      border: 1px solid var(--primary);
      border-radius: 8px;
      font-size: 0.9em;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      white-space: nowrap;
    }

    .btn-dettagli:hover {
      background: var(--primary);
      color: white;
    }

    /* No Results */
    .no-results {
      text-align: center;
      padding: 60px 20px;
      background: white;
      border-radius: 16px;
      box-shadow: 0 2px 20px rgba(0, 0, 0, 0.04);
    }

    .no-results h3 {
      font-size: 1.5em;
      color: var(--dark);
      margin-bottom: 12px;
      font-weight: 600;
    }

    .no-results p {
      color: #999;
      font-size: 1.05em;
      margin-bottom: 20px;
    }

    .btn-catalogo {
      padding: 12px 30px;
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      border: none;
      border-radius: 8px;
      font-size: 1em;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-block;
    }

    .btn-catalogo:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(109, 93, 110, 0.25);
    }

    /* Responsive */
    @media (max-width: 768px) {
      .hero h1 {
        font-size: 2em;
      }

      .prog-card {
        grid-template-columns: 1fr;
        text-align: center;
      }

      .prog-poster {
        width: 120px;
        height: 180px;
        margin: 0 auto;
      }

      .prog-actions {
        align-items: stretch;
      }
    }
  </style>
</head>
<body>
<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Hero Section -->
<section class="hero">
  <h1>Programmazioni</h1>
  <p>Tutte le proiezioni disponibili</p>
</section>

<!-- Main Content -->
<main>
  <div class="programmazioni-container">

    <!-- Info Header -->
    <div class="info-header">
      <div class="info-count">
        <c:choose>
          <c:when test="${fn:length(programmazioni) == 0}">
            Nessuna programmazione trovata
          </c:when>
          <c:when test="${fn:length(programmazioni) == 1}">
            1 programmazione disponibile
          </c:when>
          <c:otherwise>
            ${fn:length(programmazioni)} programmazioni disponibili
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <!-- Grid Programmazioni -->
    <c:choose>
      <c:when test="${not empty programmazioni}">
        <div class="programmazioni-grid">
          <c:forEach var="prog" items="${programmazioni}">
            <div class="prog-card">
              <!-- Poster -->
              <div class="prog-poster">
                <c:choose>
                  <c:when test="${not empty prog.film.locandina}">
                    <img src="${prog.film.locandina}"
                         alt="${prog.film.titolo}"
                         onerror="this.parentElement.innerHTML='<div class=\'prog-poster-placeholder\'>🎬</div>'">
                  </c:when>
                  <c:otherwise>
                    <div class="prog-poster-placeholder">🎬</div>
                  </c:otherwise>
                </c:choose>
              </div>

              <!-- Info -->
              <div class="prog-info">
                <h3 class="prog-title">${prog.film.titolo}</h3>

                <div class="prog-meta">
                  <span>${prog.film.durata} min</span>
                  <span>${prog.film.genere}</span>
                  <c:if test="${not empty prog.film.anno && prog.film.anno > 0}">
                    <span>${prog.film.anno}</span>
                  </c:if>
                </div>

                <div class="prog-details">
                  <div class="detail-item">
                    <span class="detail-label">Data</span>
                    <span class="detail-value">${prog.dataProgrammazione}</span>
                  </div>
                  <div class="detail-item">
                    <span class="detail-label">Orario</span>
                    <span class="detail-value">${prog.slotOrari.oraInizio}</span>
                  </div>
                  <div class="detail-item">
                    <span class="detail-label">Sala</span>
                    <span class="detail-value">${prog.sala.nome}</span>
                  </div>
                  <div class="detail-item">
                    <span class="detail-label">Prezzo</span>
                    <span class="detail-price">€<fmt:formatNumber value="${prog.prezzoBase}" pattern="#,##0.00"/></span>
                  </div>
                </div>
              </div>

              <!-- Actions -->
              <div class="prog-actions">
                <a href="${pageContext.request.contextPath}/acquisto?idProgrammazione=${prog.idProgrammazione}&numeroBiglietti=1"
                   class="btn-acquista">
                  Acquista
                </a>
                <a href="${pageContext.request.contextPath}/dettaglio-film?idFilm=${prog.film.idFilm}"
                   class="btn-dettagli">
                  Dettagli Film
                </a>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:when>
      <c:otherwise>
        <!-- Nessun Risultato -->
        <div class="no-results">
          <h3>Nessuna programmazione disponibile</h3>
          <p>Al momento non ci sono proiezioni programmate</p>
          <a href="${pageContext.request.contextPath}/catalogo" class="btn-catalogo">
            Vai al Catalogo
          </a>
        </div>
      </c:otherwise>
    </c:choose>

  </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

</body>
</html>