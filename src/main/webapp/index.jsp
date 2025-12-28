<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tickema - Home</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Georgia', serif;
      background-color: #3d3d4d;
      color: #ffffff;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    /* Header */
    .header {
      background-color: #2c2d3a;
      padding: 1.2rem 2rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 2px 5px rgba(0,0,0,0.3);
    }

    .menu-icon {
      width: 40px;
      height: 30px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      cursor: pointer;
    }

    .menu-icon span {
      width: 100%;
      height: 4px;
      background-color: #ffffff;
      border-radius: 2px;
    }

    .logo {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      text-decoration: none;
      color: #ffffff;
    }

    .logo-icon {
      width: 40px;
      height: 40px;
    }

    .logo-text {
      font-size: 2rem;
      font-style: italic;
    }

    .user-icon {
      width: 50px;
      height: 50px;
      background-color: #b8b8c8;
      border-radius: 50%;
      cursor: pointer;
    }

    /* Carousel */
    .carousel-section {
      background: linear-gradient(135deg, #7d7b8f 0%, #5a5869 100%);
      padding: 4rem 2rem;
      text-align: center;
      position: relative;
    }

    .carousel-title {
      font-size: 2.5rem;
      font-weight: normal;
      margin-bottom: 2rem;
      color: #ffffff;
    }

    .carousel-arrow {
      position: absolute;
      top: 50%;
      transform: translateY(-50%);
      font-size: 4rem;
      color: #4a4858;
      cursor: pointer;
      user-select: none;
      transition: color 0.3s;
    }

    .carousel-arrow:hover {
      color: #6a6878;
    }

    .carousel-arrow.left {
      left: 2rem;
    }

    .carousel-arrow.right {
      right: 2rem;
    }

    /* Main Content */
    .content {
      flex: 1;
      padding: 3rem 2rem;
      max-width: 1400px;
      margin: 0 auto;
      width: 100%;
    }

    /* Consigliati Section */
    .section-title {
      font-size: 2.5rem;
      font-weight: normal;
      margin-bottom: 2rem;
      padding-left: 1.5rem;
      border-left: 6px solid #d4a574;
      color: #ffffff;
    }

    /* Film Grid */
    .film-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 2rem;
      margin-bottom: 3rem;
    }

    .film-card {
      background-color: #4a4858;
      border-radius: 8px;
      overflow: hidden;
      cursor: pointer;
      transition: transform 0.3s, box-shadow 0.3s;
    }

    .film-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 20px rgba(0,0,0,0.4);
    }

    .film-poster {
      width: 100%;
      height: 200px;
      background-color: #5a5869;
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
    }

    .placeholder-icon {
      width: 80px;
      height: 80px;
      background-color: #b8b8c8;
      border-radius: 50%;
      position: relative;
    }

    .placeholder-icon::before {
      content: '';
      position: absolute;
      top: 20px;
      left: 50%;
      transform: translateX(-50%);
      width: 35px;
      height: 35px;
      background-color: #5a5869;
      border-radius: 50%;
    }

    .placeholder-icon::after {
      content: '';
      position: absolute;
      bottom: 15px;
      left: 50%;
      transform: translateX(-50%);
      width: 60px;
      height: 35px;
      background-color: #5a5869;
      border-radius: 50% 50% 0 0;
    }

    .film-info {
      padding: 1rem;
      text-align: center;
    }

    .film-title {
      font-size: 1.5rem;
      font-weight: normal;
      margin-bottom: 0.3rem;
      color: #ffffff;
    }

    .film-description {
      font-size: 0.9rem;
      color: #b8b8c8;
      line-height: 1.4;
    }

    /* Footer */
    .footer {
      background-color: #2c2d3a;
      text-align: center;
      padding: 1.5rem;
      color: #b8b8c8;
      font-size: 0.95rem;
    }

    /* Responsive */
    @media (max-width: 1200px) {
      .film-grid {
        grid-template-columns: repeat(3, 1fr);
      }
    }

    @media (max-width: 768px) {
      .film-grid {
        grid-template-columns: repeat(2, 1fr);
      }

      .carousel-title {
        font-size: 1.8rem;
      }

      .section-title {
        font-size: 1.8rem;
      }
    }

    @media (max-width: 480px) {
      .film-grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body>
<!-- Header -->
<header class="header">
  <div class="menu-icon">
    <span></span>
    <span></span>
    <span></span>
  </div>

  <a href="${pageContext.request.contextPath}/home" class="logo">
    <svg class="logo-icon" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
      <circle cx="50" cy="50" r="45" fill="none" stroke="#ffffff" stroke-width="3"/>
      <circle cx="50" cy="20" r="8" fill="#ffffff"/>
      <circle cx="77" cy="32" r="8" fill="#ffffff"/>
      <circle cx="77" cy="68" r="8" fill="#ffffff"/>
      <circle cx="50" cy="80" r="8" fill="#ffffff"/>
      <circle cx="23" cy="68" r="8" fill="#ffffff"/>
      <circle cx="23" cy="32" r="8" fill="#ffffff"/>
    </svg>
    <span class="logo-text">tickema</span>
  </a>

  <div class="user-icon"></div>
</header>

<!-- Carousel Section -->
<section class="carousel-section">
  <div class="carousel-arrow left">&lt;</div>
  <h2 class="carousel-title">Programmazioni a prezzo ridotto</h2>
  <div class="carousel-arrow right">&gt;</div>
</section>

<!-- Main Content -->
<main class="content">
  <!-- Consigliati Section -->
  <h3 class="section-title">Consigliati</h3>

  <c:choose>
    <c:when test="${not empty films}">
      <div class="film-grid">
        <c:forEach var="film" items="${films}">
          <div class="film-card" onclick="location.href='${pageContext.request.contextPath}/film?id=${film.idFilm}'">
            <div class="film-poster">
              <c:choose>
                <c:when test="${not empty film.locandina}">
                  <img src="${pageContext.request.contextPath}${film.locandina}"
                       alt="${film.titolo}"
                       onerror="this.style.display='none'; this.parentElement.innerHTML='<div class=\'placeholder-icon\'></div>';">
                </c:when>
                <c:otherwise>
                  <div class="placeholder-icon"></div>
                </c:otherwise>
              </c:choose>
            </div>
            <div class="film-info">
              <div class="film-title">${film.titolo}</div>
              <div class="film-description">
                <c:choose>
                  <c:when test="${film.trama.length() > 80}">
                    ${film.trama.substring(0, 80)}...
                  </c:when>
                  <c:otherwise>
                    ${film.trama}
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:when>
    <c:otherwise>
      <div class="film-grid">
        <c:forEach begin="1" end="4">
          <div class="film-card">
            <div class="film-poster">
              <div class="placeholder-icon"></div>
            </div>
            <div class="film-info">
              <div class="film-title">Titolo</div>
              <div class="film-description">breve descrizione del film</div>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>
</main>

<!-- Footer -->
<footer class="footer">
  Tickema - Tutti diritti riservati © 2025
</footer>
</body>
</html>