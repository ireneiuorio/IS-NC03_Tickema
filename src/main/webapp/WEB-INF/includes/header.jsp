<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<header class="header">
    <div class="header-container">
        <!-- Hamburger Menu (Mobile) - A SINISTRA -->
        <div class="hamburger" onclick="toggleMenu()">
            <span></span>
            <span></span>
            <span></span>
        </div>

        <!-- Logo - AL CENTRO -->
        <a href="${pageContext.request.contextPath}/" class="logo">
            <img src="${pageContext.request.contextPath}/assets/images/logo.png"
                 alt="Tickema Logo"
                 class="logo-img"
                 onerror="this.style.display='none'">
        </a>

        <!-- Navigation Menu -->
        <nav>
            <ul class="nav-menu" id="navMenu">
                <li>
                    <a href="${pageContext.request.contextPath}/"
                       class="${pageContext.request.requestURI.endsWith('/') || pageContext.request.requestURI.endsWith('/index.jsp') ? 'active' : ''}">
                        Home
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/programmazioni"
                       class="${fn:contains(pageContext.request.requestURI, '/programmazioni') ? 'active' : ''}">
                        Catalogo
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/programmazioni"
                       class="${fn:contains(pageContext.request.requestURI, '/programmazioni') ? 'active' : ''}">
                        Programmazioni
                    </a>
                </li>

                <c:choose>
                    <c:when test="${not empty sessionScope.utente}">
                        <!-- User logged in -->
                        <li>
                            <a href="${pageContext.request.contextPath}/profilo"
                               class="${fn:contains(pageContext.request.requestURI, '/profilo') ? 'active' : ''}">
                                Profilo ${sessionScope.utente.nome}
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
                            <a href="${pageContext.request.contextPath}/login.jsp">
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

        <!-- User Info & Icon - A DESTRA -->
        <div class="header-user">
            <c:if test="${not empty sessionScope.utente}">
                <div class="user-saldo">
                    <span class="saldo-label">Saldo:</span>
                    <span class="saldo-value">€<fmt:formatNumber value="${sessionScope.utente.saldo}" pattern="#,##0.00"/></span>
                </div>
                <div class="user-icon" onclick="window.location.href='${pageContext.request.contextPath}/profilo'" title="${sessionScope.utente.nome} ${sessionScope.utente.cognome}">
                        ${fn:substring(sessionScope.utente.nome, 0, 1)}${fn:substring(sessionScope.utente.cognome, 0, 1)}
                </div>
            </c:if>
        </div>
    </div>
</header>

<script>
    function toggleMenu() {
        const navMenu = document.getElementById('navMenu');
        navMenu.classList.toggle('active');
    }

    // Chiudi menu quando clicchi fuori
    document.addEventListener('click', function(event) {
        const nav = document.getElementById('navMenu');
        const hamburger = document.querySelector('.hamburger');

        if (!nav.contains(event.target) && !hamburger.contains(event.target)) {
            nav.classList.remove('active');
        }
    });
    // Script per gestire il menu hamburger laterale
    function toggleMenu() {
        const nav = document.querySelector('nav');
        const navMenu = document.getElementById('navMenu');
        const body = document.body;

        // Toggle delle classi active
        nav.classList.toggle('active');
        navMenu.classList.toggle('active');

        // Gestione overlay
        let overlay = document.querySelector('.nav-overlay');

        if (!overlay) {
            overlay = document.createElement('div');
            overlay.className = 'nav-overlay';
            document.body.appendChild(overlay);

            // Click sull'overlay chiude il menu
            overlay.addEventListener('click', closeMenu);
        }

        overlay.classList.toggle('active');

        // Previeni scroll quando il menu è aperto
        if (nav.classList.contains('active')) {
            body.style.overflow = 'hidden';
        } else {
            body.style.overflow = '';
        }
    }

    function closeMenu() {
        const nav = document.querySelector('nav');
        const navMenu = document.getElementById('navMenu');
        const overlay = document.querySelector('.nav-overlay');
        const body = document.body;

        nav.classList.remove('active');
        navMenu.classList.remove('active');

        if (overlay) {
            overlay.classList.remove('active');
        }

        body.style.overflow = '';
    }

    // Chiudi menu con tasto ESC
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            const nav = document.querySelector('nav');
            if (nav.classList.contains('active')) {
                closeMenu();
            }
        }
    });

    // Chiudi menu quando si clicca su un link (opzionale)
    document.querySelectorAll('.nav-menu a').forEach(link => {
        link.addEventListener('click', function() {
            // Chiudi il menu dopo aver cliccato un link
            setTimeout(closeMenu, 200);
        });
    });


</script>
