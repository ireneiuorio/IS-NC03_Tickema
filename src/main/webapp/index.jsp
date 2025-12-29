<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tickema - Home</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    /* ============================================
       SEZIONE HERO / CAROUSEL
       ============================================ */
    .hero-section {
      background: linear-gradient(135deg, #6D5D6E 0%, #4F4557 100%);
      padding: 80px 30px;
      text-align: center;
      position: relative;
      overflow: hidden;
    }

    .hero-section::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: url('data:image/svg+xml,<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="40" fill="none" stroke="rgba(255,255,255,0.03)" stroke-width="2"/></svg>');
      opacity: 0.3;
    }

    .hero-content {
      position: relative;
      z-index: 1;
      max-width: 800px;
      margin: 0 auto;
    }

    .hero-title {
      font-size: 3em;
      color: #FFFFFF;
      margin-bottom: 20px;
      font-weight: 300;
      letter-spacing: 2px;
    }

    .hero-subtitle {
      font-size: 1.3em;
      color: rgba(255, 255, 255, 0.9);
      margin-bottom: 30px;
    }

    .carousel-controls {
      display: flex;
      justify-content: center;
      gap: 20px;
      margin-top: 30px;
    }

    .carousel-arrow {
      width: 50px;
      height: 50px;
      background: rgba(255, 255, 255, 0.2);
      border: 2px solid rgba(255, 255, 255, 0.5);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      transition: all 0.3s ease;
      backdrop-filter: blur(10px);
    }

    .carousel-arrow:hover {
      background: rgba(255, 255, 255, 0.3);
      transform: scale(1.1);
    }

    /* ============================================
       SEZIONE CONSIGLIATI
       ============================================ */
    .section-header {
      margin: 60px 0 40px;
      padding-left: 20px;
      border-left: 6px solid #6D5D6E;
    }

    .section-title {
      font-size: 2.5em;
      color: #4F4557;
      font-weight: 300;
      letter-spacing: 1px;
    }

    /* ============================================
       GRIGLIA FILM (4 colonne)
       ============================================ */
    .film-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 30px;
      margin-bottom: 50px;
    }

    .film-card {
      background: #FFFFFF;
      border-radius: 15px;
      overflow: hidden;
      box-shadow: 0 5px 20px rgba(77, 69, 87, 0.15);
      transition: all 0.3s ease;
      cursor: pointer;
    }

    .film-card:hover {
      transform: translateY(-10px);
      box-shadow: 0 15px 40px rgba(77, 69, 87, 0.25);
    }

    .film-poster {
      width: 100%;
      height: 350px;
      background: linear-gradient(135deg, #6D5D6E 0%, #4F4557 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      overflow: hidden;
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

    .placeholder-icon {
      width: 100px;
      height: 100px;
      background: rgba(255, 255, 255, 0.2);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 3em;
      color: rgba(255, 255, 255, 0.5);
    }

    .film-info {
      padding: 25px;
    }

    .film-title {
      font-size: 1.4em;
      color: #4F4557;
      margin-bottom: 10px;
      font-weight: 600;
    }

    .film-description {
      font-size: 0.95em;
      color: #666;
      line-height: 1.6;
      overflow: hidden;
      display: -webkit-box;
      -webkit-line-clamp: 3;
      -webkit-box-orient: vertical;
    }

    .film-meta {
      display: flex;
      gap: 15px;
      margin-top: 15px;
      font-size: 0.9em;
      color: #999;
    }

    .film-meta span {
      display: flex;
      align-items: center;
      gap: 5px;
    }

    /* CTA Button */
    .cta-section {
      text-align: center;
      margin-top: 50px;
    }

    /* No Results */
    .no-results {
      text-align: center;
      padding: 80px 20px;
      color: #999;
    }

    .no-results-icon {
      font-size: 5em;
      margin-bottom: 20px;
      opacity: 0.3;
    }

    /* ============================================
       RESPONSIVE
       ============================================ */
    @media (max-width: 1200px) {
      .film-grid {
        grid-template-columns: repeat(3, 1fr);
      }
    }

    @media (max-width: 968px) {
      .film-grid {
        grid-template-columns: repeat(2, 1fr);
      }

      .hero-title {
        font-size: 2.2em;
      }

      .hero-subtitle {
        font-size: 1.1em;
      }
    }

    @media (max-width: 768px) {
      .section-title {
        font-size: 2em;
      }

      .film-poster {
        height: 300px;
      }
    }

    @media (max-width: 480px) {
      .film-grid {
        grid-template-columns: 1fr;
      }

      .hero-title {
        font-size: 1.8em;
      }

      .hero-subtitle {
        font-size: 1em;
      }

      .section-header {
        margin: 40px 0 30px;
      }
    }
  </style>
</head>
<body>
<!-- Header -->
<header class="header">
  <div class="header-container">
    <!-- Hamburger Menu -->
    <div class="hamburger" id="hamburger">
      <span></span>
      <span></span>
      <span></span>
    </div>

    <!-- Logo -->
    <a href="${pageContext.request.contextPath}/home/" class="logo">
      <span class="logo-text">tickema</span>
    </a>

    <!-- User Section -->
    <div class="header-user">
      <div class="user-icon">U</div>
    </div>
  </div>
</header>

<!-- Navigation Overlay -->
<div class="nav-overlay" id="navOverlay"></div>

<!-- Navigation Menu -->
<nav id="navMenu">
  <ul class="nav-menu">
    <li><a href="${pageContext.request.contextPath}/home/" class="active">Home</a></li>
    <li><a href="${pageContext.request.contextPath}/catalogo/">Catalogo Film</a></li>
    <li><a href="${pageContext.request.contextPath}/programmazione/">Programmazione</a></li>
    <li><a href="${pageContext.request.contextPath}/biglietti/">I Miei Biglietti</a></li>
    <li><a href="${pageContext.request.contextPath}/profilo/">Profilo</a></li>
  </ul>
</nav>

<!-- Hero Section (Carousel) -->
<section class="hero-section">
  <div class="hero-content">
    <h1 class="hero-title">Programmazioni a prezzo ridotto</h1>
    <p class="hero-subtitle">Scopri le migliori offerte della settimana</p>
    <div class="carousel-controls">
      <div class="carousel-arrow">&lt;</div>
      <div class="carousel-arrow">&gt;</div>
    </div>
  </div>
</section>

<!-- Main Content -->
<main class="container">
  <!-- Sezione Consigliati -->
  <div class="section-header">
    <h2 class="section-title">Consigliati</h2>
  </div>

  <c:choose>
    <c:when test="${not empty films}">
      <div class="film-grid">
        <c:forEach var="film" items="${films}">
          <div class="film-card" onclick="location.href='${pageContext.request.contextPath}/catalogo/film?id=${film.idFilm}'">
            <div class="film-poster">
              <c:choose>
                <c:when test="${not empty film.locandina}">
                  <img src="${pageContext.request.contextPath}${film.locandina}"
                       alt="${film.titolo}"
                       onerror="this.parentElement.innerHTML='<div class=\'placeholder-icon\'>🎬</div>';">
                </c:when>
                <c:otherwise>
                  <div class="placeholder-icon">🎬</div>
                </c:otherwise>
              </c:choose>
            </div>
            <div class="film-info">
              <h3 class="film-title">${film.titolo}</h3>
              <p class="film-description">
                <c:choose>
                  <c:when test="${film.trama.length() > 120}">
                    ${film.trama.substring(0, 120)}...
                  </c:when>
                  <c:otherwise>
                    ${film.trama}
                  </c:otherwise>
                </c:choose>
              </p>
              <div class="film-meta">
                <span>📅 ${film.anno}</span>
                <span>⏱️ ${film.durata} min</span>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>

      <!-- CTA per vedere tutti i film -->
      <div class="cta-section">
        <a href="${pageContext.request.contextPath}/catalogo/" class="btn btn-primary">
          Vedi Tutti i Film
        </a>
      </div>
    </c:when>
    <c:otherwise>
      <div class="no-results">
        <div class="no-results-icon">🎬</div>
        <p>Nessun film disponibile al momento.</p>
      </div>
    </c:otherwise>
  </c:choose>
</main>

<!-- Footer -->
<footer class="footer">
  <div class="footer-container">
    <div class="footer-section">
      <h3>Tickema</h3>
      <p>La tua esperienza cinematografica digitale. Prenota i tuoi biglietti online in pochi click.</p>
    </div>
    <div class="footer-section">
      <h3>Link Utili</h3>
      <ul>
        <li><a href="${pageContext.request.contextPath}/home/">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/catalogo/">Catalogo</a></li>
        <li><a href="${pageContext.request.contextPath}/programmazione/">Programmazione</a></li>
        <li><a href="${pageContext.request.contextPath}/contatti/">Contatti</a></li>
      </ul>
    </div>
  </div>
  <div class="footer-bottom">
    <p>&copy; 2025 Tickema - Tutti i diritti riservati</p>
    <p>Progetto Ingegneria del Software</p>
  </div>
</footer>

<!-- JavaScript per Menu -->
<script>
  const hamburger = document.getElementById('hamburger');
  const navMenu = document.getElementById('navMenu');
  const navOverlay = document.getElementById('navOverlay');

  function toggleMenu() {
    navMenu.classList.toggle('active');
    navOverlay.classList.toggle('active');
  }

  hamburger.addEventListener('click', toggleMenu);
  navOverlay.addEventListener('click', toggleMenu);
</script>
</body>
</html>