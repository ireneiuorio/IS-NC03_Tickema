<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalogo Film - Tickema</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* ============================================
           BARRA FILTRI
           ============================================ */
        .filters-section {
            background: #FFFFFF;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(77, 69, 87, 0.15);
            margin-bottom: 40px;
        }

        .filters-container {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: center;
        }

        .search-box {
            flex: 1;
            min-width: 250px;
        }

        .search-input {
            width: 100%;
            padding: 12px 20px;
            border: 2px solid #E0E0E0;
            border-radius: 8px;
            font-size: 1em;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: #6D5D6E;
            box-shadow: 0 0 0 3px rgba(109, 93, 110, 0.1);
        }

        .filter-group {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 12px 24px;
            background: #F5F5F5;
            border: 2px solid transparent;
            border-radius: 8px;
            color: #4F4557;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.95em;
        }

        .filter-btn:hover {
            background: #6D5D6E;
            color: #FFFFFF;
            transform: translateY(-2px);
        }

        .filter-btn.active {
            background: linear-gradient(135deg, #6D5D6E 0%, #4F4557 100%);
            color: #FFFFFF;
            border-color: #6D5D6E;
        }

        .filter-dropdown {
            padding: 12px 24px;
            background: #F5F5F5;
            border: 2px solid transparent;
            border-radius: 8px;
            color: #4F4557;
            font-weight: 500;
            font-size: 0.95em;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-dropdown:focus {
            outline: none;
            border-color: #6D5D6E;
            background: #FFFFFF;
        }

        /* ============================================
           INFO RISULTATI
           ============================================ */
        .results-info {
            margin-bottom: 30px;
            padding: 15px 20px;
            background: rgba(109, 93, 110, 0.1);
            border-radius: 8px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .results-count {
            font-size: 1.1em;
            color: #4F4557;
            font-weight: 500;
        }

        .results-filter-tag {
            background: #6D5D6E;
            color: #FFFFFF;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
        }

        /* ============================================
           GRIGLIA FILM (3 colonne)
           ============================================ */
        .film-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 35px;
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
            height: 400px;
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
            width: 120px;
            height: 120px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4em;
            color: rgba(255, 255, 255, 0.5);
        }

        .film-info {
            padding: 30px;
        }

        .film-title {
            font-size: 1.6em;
            color: #4F4557;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .film-description {
            font-size: 1em;
            color: #666;
            line-height: 1.7;
            margin-bottom: 20px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }

        .film-details {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            font-size: 0.95em;
            color: #999;
        }

        .film-detail-item {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .genre-badge {
            display: inline-block;
            background: linear-gradient(135deg, #6D5D6E 0%, #4F4557 100%);
            color: #FFFFFF;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 500;
            margin-top: 10px;
        }

        /* No Results */
        .no-results {
            text-align: center;
            padding: 100px 20px;
        }

        .no-results-icon {
            font-size: 6em;
            margin-bottom: 20px;
            opacity: 0.3;
        }

        .no-results h3 {
            font-size: 1.8em;
            color: #4F4557;
            margin-bottom: 10px;
            font-weight: 300;
        }

        .no-results p {
            color: #999;
            font-size: 1.1em;
        }

        /* ============================================
           RESPONSIVE
           ============================================ */
        @media (max-width: 1200px) {
            .film-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 968px) {
            .filters-container {
                flex-direction: column;
                align-items: stretch;
            }

            .search-box {
                width: 100%;
            }

            .filter-group {
                justify-content: center;
            }
        }

        @media (max-width: 768px) {
            .film-grid {
                grid-template-columns: 1fr;
            }

            .film-poster {
                height: 350px;
            }

            .results-info {
                flex-direction: column;
                gap: 10px;
            }
        }

        @media (max-width: 480px) {
            .filters-section {
                padding: 20px;
            }

            .filter-btn,
            .filter-dropdown {
                width: 100%;
            }

            .film-info {
                padding: 20px;
            }

            .film-title {
                font-size: 1.4em;
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
        <li><a href="${pageContext.request.contextPath}/home/">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/catalogo/" class="active">Catalogo Film</a></li>
        <li><a href="${pageContext.request.contextPath}/programmazione/">Programmazione</a></li>
        <li><a href="${pageContext.request.contextPath}/biglietti/">I Miei Biglietti</a></li>
        <li><a href="${pageContext.request.contextPath}/profilo/">Profilo</a></li>
    </ul>
</nav>

<!-- Main Content -->
<main class="container">
    <h1 class="page-title">Catalogo Film</h1>

    <!-- Filtri -->
    <div class="filters-section">
        <form action="${pageContext.request.contextPath}/catalogo/" method="get">
            <div class="filters-container">
                <!-- Ricerca -->
                <div class="search-box">
                    <input type="text"
                           name="search"
                           class="search-input"
                           placeholder="🔍 Cerca film per titolo..."
                           value="${searchQuery}">
                </div>

                <!-- Filtri per genere -->
                <div class="filter-group">
                    <select name="genere" class="filter-dropdown" onchange="this.form.submit()">
                        <option value="">Tutti i generi</option>
                        <option value="Azione" ${selectedGenre == 'Azione' ? 'selected' : ''}>Azione</option>
                        <option value="Commedia" ${selectedGenre == 'Commedia' ? 'selected' : ''}>Commedia</option>
                        <option value="Drammatico" ${selectedGenre == 'Drammatico' ? 'selected' : ''}>Drammatico</option>
                        <option value="Horror" ${selectedGenre == 'Horror' ? 'selected' : ''}>Horror</option>
                        <option value="Fantascienza" ${selectedGenre == 'Fantascienza' ? 'selected' : ''}>Fantascienza</option>
                    </select>

                    <button type="submit" class="btn btn-primary">Cerca</button>
                </div>
            </div>
        </form>
    </div>

    <!-- Info Risultati -->
    <c:if test="${not empty films}">
        <div class="results-info">
                <span class="results-count">
                    Trovati <strong>${films.size()}</strong> film
                </span>
            <c:if test="${not empty searchQuery || not empty selectedGenre}">
                <div>
                    <c:if test="${not empty searchQuery}">
                        <span class="results-filter-tag">🔍 "${searchQuery}"</span>
                    </c:if>
                    <c:if test="${not empty selectedGenre}">
                        <span class="results-filter-tag">📁 ${selectedGenre}</span>
                    </c:if>
                </div>
            </c:if>
        </div>
    </c:if>

    <!-- Griglia Film -->
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
                                    <c:when test="${film.trama.length() > 150}">
                                        ${film.trama.substring(0, 150)}...
                                    </c:when>
                                    <c:otherwise>
                                        ${film.trama}
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <div class="film-details">
                                <span class="film-detail-item">🎬 ${film.regista}</span>
                                <span class="film-detail-item">📅 ${film.anno}</span>
                                <span class="film-detail-item">⏱️ ${film.durata} min</span>
                            </div>
                            <span class="genre-badge">${film.genere}</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="no-results">
                <div class="no-results-icon">🎬</div>
                <h3>Nessun film trovato</h3>
                <p>Prova a modificare i filtri di ricerca</p>
                <c:if test="${not empty searchQuery || not empty selectedGenre}">
                    <a href="${pageContext.request.contextPath}/catalogo/" class="btn btn-secondary" style="margin-top: 20px;">
                        Mostra tutti i film
                    </a>
                </c:if>
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
            <div class="social-links">
                <a href="#">📘</a>
                <a href="#">📷</a>
                <a href="#">🐦</a>
            </div>
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
        <div class="footer-section">
            <h3>Contatti</h3>
            <ul>
                <li>📧 info@tickema.it</li>
                <li>📞 +39 123 456 7890</li>
                <li>📍 Via Cinema 1, Milano</li>
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