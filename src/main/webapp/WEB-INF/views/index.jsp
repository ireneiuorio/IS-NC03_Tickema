<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Home - Tickema</title>

  <!-- CSS Base -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <style>
    /* Hero Section */
    .hero {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      padding: 80px 30px;
      text-align: center;
      margin-bottom: 60px;
    }

    .hero h1 {
      font-size: 3.5em;
      font-weight: 300;
      margin-bottom: 20px;
      letter-spacing: 3px;
    }

    .hero p {
      font-size: 1.4em;
      opacity: 0.9;
      max-width: 600px;
      margin: 0 auto;
    }

    /* Film Consigliati Section */
    .section {
      max-width: 1400px;
      margin: 0 auto 80px;
      padding: 0 30px;
    }

    .section-title {
      font-size: 2.5em;
      color: var(--dark);
      margin-bottom: 40px;
      font-weight: 300;
      letter-spacing: 1px;
      display: flex;
      align-items: center;
      gap: 15px;
    }

    /* Carousel Container */
    .carousel-container {
      position: relative;
      overflow: hidden;
      padding: 20px 0;
    }

    .carousel-wrapper {
      display: flex;
      gap: 30px;
      overflow-x: auto;
      scroll-behavior: smooth;
      padding: 10px;
      scrollbar-width: none; /* Firefox */
    }

    .carousel-wrapper::-webkit-scrollbar {
      display: none; /* Chrome, Safari */
    }

    /* Film Card */
    .film-card {
      min-width: 280px;
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
      background: linear-gradient(135deg, #f0f0f0 0%, #e0e0e0 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 4em;
      position: relative;
      overflow: hidden;
    }

    .film-poster::before {
      content: '🎬';
      position: absolute;
      font-size: 8em;
      opacity: 0.1;
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
    }

    .film-meta {
      display: flex;
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
      margin-top: 15px;
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

    /* Carousel Navigation */
    .carousel-nav {
      position: absolute;
      top: 50%;
      transform: translateY(-50%);
      background: rgba(109, 93, 110, 0.9);
      color: white;
      width: 50px;
      height: 50px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      z-index: 10;
      transition: all 0.3s ease;
    }

    .carousel-nav:hover {
      background: var(--dark);
      transform: translateY(-50%) scale(1.1);
    }

    .carousel-nav.prev {
      left: 10px;
    }

    .carousel-nav.next {
      right: 10px;
    }

    /* Responsive */
    @media (max-width: 768px) {
      .hero h1 {
        font-size: 2.5em;
      }

      .hero p {
        font-size: 1.1em;
      }

      .section-title {
        font-size: 2em;
      }

      .film-card {
        min-width: 250px;
      }
    }
  </style>
</head>
<body>
<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Hero Section -->
<section class="hero">
  <h1>🎬 Benvenuto su Tickema</h1>
  <p>Il tuo cinema preferito, sempre a portata di click</p>
</section>

<!-- Main Content -->
<main>

  <!-- Film Consigliati -->
  <section class="section">
    <h2 class="section-title">🌟 Film Consigliati</h2>

    <div class="carousel-container">
      <!-- Navigation Buttons -->
      <div class="carousel-nav prev" onclick="scrollCarousel(-1)">
        ◀
      </div>
      <div class="carousel-nav next" onclick="scrollCarousel(1)">
        ▶
      </div>

      <!-- Carousel -->
      <div class="carousel-wrapper" id="filmCarousel">
        <c:forEach var="film" items="${filmConsigliati}">
          <div class="film-card">
            <div class="film-poster">
              🎬
            </div>
            <div class="film-info">
              <h3 class="film-title">${film.titolo}</h3>

              <div class="film-meta">
                <span>⏱️ ${film.durata} min</span>
                <span>🎭 ${film.genere}</span>
              </div>

              <div class="film-actions">
                <a href="${pageContext.request.contextPath}/programmazioni?idFilm=${film.idFilm}"
                   class="btn-film btn-primary-film">
                  📅 Vedi Programmazione
                </a>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
    </div>
  </section>

</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script>
  // Carousel Scroll Function
  function scrollCarousel(direction) {
    const carousel = document.getElementById('filmCarousel');
    const scrollAmount = 310; // larghezza card + gap

    carousel.scrollBy({
      left: direction * scrollAmount,
      behavior: 'smooth'
    });
  }

  // Auto-scroll del carousel
  let autoScrollInterval;

  function startAutoScroll() {
    autoScrollInterval = setInterval(() => {
      const carousel = document.getElementById('filmCarousel');

      // Se arrivi alla fine, torna all'inizio
      if (carousel.scrollLeft + carousel.clientWidth >= carousel.scrollWidth - 10) {
        carousel.scrollTo({ left: 0, behavior: 'smooth' });
      } else {
        scrollCarousel(1);
      }
    }, 5000); // Ogni 5 secondi
  }

  function stopAutoScroll() {
    clearInterval(autoScrollInterval);
  }

  // Avvia auto-scroll al caricamento
  window.addEventListener('load', () => {
    startAutoScroll();

    // Ferma auto-scroll quando l'utente interagisce
    const carousel = document.getElementById('filmCarousel');
    carousel.addEventListener('mouseenter', stopAutoScroll);
    carousel.addEventListener('mouseleave', startAutoScroll);
  });
</script>

</body>
</html>