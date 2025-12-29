<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<header class="header">
    <div class="header-container">
        <!-- Hamburger Menu - A SINISTRA -->
        <div class="hamburger" onclick="toggleMenu()">
            <span></span>
            <span></span>
            <span></span>
        </div>

        <!-- Logo - AL CENTRO (la tua immagine) -->
        <a href="${pageContext.request.contextPath}/" class="logo">
            <img src="${pageContext.request.contextPath}/assets/images/logo.png"
                 alt="Tickema Logo"
                 class="logo-img">
        </a>

        <!-- User Info & Icon - A DESTRA -->
        <div class="header-user">
            <c:if test="${not empty sessionScope.utente}">
                <div class="user-saldo">
                    <span class="saldo-label">Saldo:</span>
                    <span class="saldo-value">€<fmt:formatNumber value="${sessionScope.utente.saldo}" pattern="#,##0.00"/></span>
                </div>
                <div class="user-profile" onclick="window.location.href='${pageContext.request.contextPath}/profilo'" title="${sessionScope.utente.nome} ${sessionScope.utente.cognome}">
                    <div class="user-avatar">
                            ${fn:substring(sessionScope.utente.nome, 0, 1)}${fn:substring(sessionScope.utente.cognome, 0, 1)}
                    </div>
                    <span class="user-name">${sessionScope.utente.nome}</span>
                </div>
            </c:if>

            <c:if test="${empty sessionScope.utente}">
                <div class="user-profile login-btn" onclick="window.location.href='${pageContext.request.contextPath}/fake-login.jsp'" title="Accedi">
                    <div class="user-avatar">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                    </div>
                    <span class="user-name">Accedi</span>
                </div>
            </c:if>
        </div>
    </div>
</header>

<!-- Navigation Menu LATERALE (FUORI dall'header!) -->
<nav id="navMenu">
    <ul class="nav-menu">
        <li>
            <a href="${pageContext.request.contextPath}/">
                Home
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/catalogo">
                Catalogo
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/programmazioniutente">
                Programmazioni
            </a>
        </li>

        <c:choose>
            <c:when test="${not empty sessionScope.utente}">
                <!-- User logged in -->
                <li>
                    <a href="${pageContext.request.contextPath}/profilo">
                        Profilo ${sessionScope.utente.nome}
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/i-miei-biglietti">
                        I Miei Biglietti
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/logout">
                        Logout
                    </a>
                </li>
            </c:when>
            <c:otherwise>
                <!-- User not logged in -->
                <li>
                    <a href="${pageContext.request.contextPath}/fake-login.jsp">
                        Login
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/registrazione.jsp">
                        Registrati
                    </a>
                </li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>

<!-- Overlay per chiudere il menu -->
<div class="nav-overlay" id="navOverlay"></div>

<style>
    /* User Profile Styling */
    .user-profile {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 8px 15px;
        border-radius: 25px;
        background: rgba(255, 255, 255, 0.15);
        cursor: pointer;
        transition: all 0.3s ease;
        backdrop-filter: blur(10px);
    }

    .user-profile:hover {
        background: rgba(255, 255, 255, 0.25);
        transform: translateY(-2px);
    }

    .user-avatar {
        width: 40px;
        height: 40px;
        background: var(--white);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--primary);
        font-weight: 700;
        font-size: 0.95em;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    .user-avatar svg {
        color: var(--primary);
    }

    .user-name {
        color: var(--white);
        font-weight: 600;
        font-size: 0.95em;
    }

    .login-btn .user-name {
        opacity: 0.95;
    }

    @media (max-width: 768px) {
        .user-name {
            display: none;
        }

        .user-profile {
            padding: 8px;
        }
    }
</style>

<script>
    function toggleMenu() {
        const nav = document.getElementById('navMenu');
        const overlay = document.getElementById('navOverlay');

        nav.classList.toggle('active');
        overlay.classList.toggle('active');

        // Previeni scroll quando il menu è aperto
        if (nav.classList.contains('active')) {
            document.body.style.overflow = 'hidden';
        } else {
            document.body.style.overflow = '';
        }
    }

    function closeMenu() {
        const nav = document.getElementById('navMenu');
        const overlay = document.getElementById('navOverlay');

        nav.classList.remove('active');
        overlay.classList.remove('active');
        document.body.style.overflow = '';
    }

    // Chiudi menu cliccando sull'overlay
    document.addEventListener('click', function(event) {
        const overlay = document.getElementById('navOverlay');
        if (event.target === overlay) {
            closeMenu();
        }
    });

    // Chiudi menu con tasto ESC
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            const nav = document.getElementById('navMenu');
            if (nav && nav.classList.contains('active')) {
                closeMenu();
            }
        }
    });

    // Chiudi menu quando si clicca su un link
    document.querySelectorAll('.nav-menu a').forEach(link => {
        link.addEventListener('click', function() {
            setTimeout(closeMenu, 200);
        });
    });
</script>