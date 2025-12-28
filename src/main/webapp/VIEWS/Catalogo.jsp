<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalogo Film - Tickema</title>
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

        /* Filters Bar */
        .filters-bar {
            background-color: #3d3d4d;
            padding: 2rem;
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            justify-content: center;
            align-items: center;
        }

        .filter-item {
            position: relative;
        }

        .filter-button,
        .search-input {
            background-color: #4a4858;
            color: #ffffff;
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 6px;
            font-size: 1rem;
            font-family: 'Georgia', serif;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: background-color 0.3s;
        }

        .filter-button:hover,
        .filter-button.active {
            background-color: #5a5869;
        }

        .filter-button::after {
            content: '▼';
            font-size: 0.7rem;
        }

        .search-input {
            width: 250px;
            cursor: text;
        }

        .search-input::placeholder {
            color: #b8b8c8;
        }

        .search-form {
            display: inline-block;
        }

        /* Main Content */
        .content {
            flex: 1;
            padding: 3rem 2rem;
            max-width: 1400px;
            margin: 0 auto;
            width: 100%;
        }

        /* Film Grid - 3 colonne come nel mockup */
        .film-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2.5rem;
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
            height: 250px;
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
            width: 100px;
            height: 100px;
            background-color: #b8b8c8;
            border-radius: 50%;
            position: relative;
        }

        .placeholder-icon::before {
            content: '';
            position: absolute;
            top: 25px;
            left: 50%;
            transform: translateX(-50%);
            width: 40px;
            height: 40px;
            background-color: #5a5869;
            border-radius: 50%;
        }

        .placeholder-icon::after {
            content: '';
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            width: 70px;
            height: 40px;
            background-color: #5a5869;
            border-radius: 50% 50% 0 0;
        }

        .film-info {
            padding: 1.5rem;
        }

        .film-title {
            font-size: 1.8rem;
            font-weight: normal;
            margin-bottom: 0.5rem;
            color: #ffffff;
        }

        .film-description {
            font-size: 1rem;
            color: #b8b8c8;
            line-height: 1.5;
        }

        /* Footer */
        .footer {
            background-color: #2c2d3a;
            text-align: center;
            padding: 1.5rem;
            color: #b8b8c8;
            font-size: 0.95rem;
            margin-top: 3rem;
        }

        /* No Results */
        .no-results {
            text-align: center;
            padding: 4rem 2rem;
            color: #b8b8c8;
            font-size: 1.2rem;
        }

        /* Responsive */
        @media (max-width: 1200px) {
            .film-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .film-grid {
                grid-template-columns: 1fr;
            }

            .filters-bar {
                flex-direction: column;
                align-items: stretch;
            }

            .filter-button,
            .search-input {
                width: 100%;
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

<!-- Filters Bar -->
<div class="filters-bar">
    <!-- Ricerca -->
    <form action="${pageContext.request.contextPath}/catalogo" method="get" class="search-form">
        <input type="text"
               name="search"
               class="search-input"
               placeholder="cerca 🔍"
               value="${searchQuery}">
    </form>

    <!-- Filtro Genere -->
    <div class="filter-item">
        <button class="filter-button ${not empty selectedGenre ? 'active' : ''}"
                onclick="toggleGenereDropdown()">
            genere
        </button>
    </div>

    <!-- Altri filtri (non implementati ma visibili come nel mockup) -->
    <button class="filter-button">durata</button>
    <button class="filter-button">anno</button>
    <button class="filter-button">data 📅</button>
    <button class="filter-button">in programmazione</button>
</div>

<!-- Main Content -->
<main class="content">
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
                                    <c:when test="${film.trama.length() > 120}">
                                        ${film.trama.substring(0, 120)}...
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
            <div class="no-results">
                Nessun film disponibile al momento.
            </div>
        </c:otherwise>
    </c:choose>
</main>

<!-- Footer -->
<footer class="footer">
    Tickema - Tutti diritti riservati © 2023
</footer>

<script>
    // Dropdown genere (placeholder - da implementare)
    function toggleGenereDropdown() {
        alert('Filtro genere - Da implementare con dropdown');
        // Qui potresti aprire un menu dropdown con i vari generi
    }
</script>
</body>
</html>