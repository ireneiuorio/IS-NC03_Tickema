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
            <c:if test="${not empty sessionScope.utenteLoggato}">
                <div class="user-saldo">
                    <span class="saldo-label">Saldo:</span>
                    <span class="saldo-value">€<fmt:formatNumber value="${sessionScope.utenteLoggato.saldo}" pattern="#,##0.00"/></span>
                </div>
                <div class="user-profile" onclick="window.location.href='${pageContext.request.contextPath}/utente/mostra-profilo'" title="${sessionScope.utenteLoggato.nome} ${sessionScope.utenteLoggato.cognome}">
                    <div class="user-avatar">
                            ${fn:substring(sessionScope.utenteLoggato.nome, 0, 1)}${fn:substring(sessionScope.utenteLoggato.cognome, 0, 1)}
                    </div>
                    <span class="user-name">${sessionScope.utenteLoggato.nome}</span>
                </div>
            </c:if>

            <c:if test="${empty sessionScope.utenteLoggato}">
                <div class="user-profile login-btn" onclick="window.location.href='${pageContext.request.contextPath}/utente/login'" title="Accedi">
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
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 10px; vertical-align: middle;">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                    <polyline points="9 22 9 12 15 12 15 22"></polyline>
                </svg>
                Home
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/catalogo">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 10px; vertical-align: middle;">
                    <rect x="2" y="7" width="20" height="15" rx="2" ry="2"></rect>
                    <polyline points="17 2 12 7 7 2"></polyline>
                </svg>
                Catalogo
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/programmazioniutente">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 10px; vertical-align: middle;">
                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                    <line x1="16" y1="2" x2="16" y2="6"></line>
                    <line x1="8" y1="2" x2="8" y2="6"></line>
                    <line x1="3" y1="10" x2="21" y2="10"></line>
                </svg>
                Programmazioni
            </a>
        </li>

        <c:choose>
            <c:when test="${not empty sessionScope.utenteLoggato}">
                <!-- User logged in -->

                <!-- Sezione ADMIN - visibile solo agli amministratori -->
                <c:if test="${sessionScope.utenteLoggato.tipoAccount == 'Admin'}">
                    <li class="menu-divider">
                        <hr style="border: none; border-top: 1px solid rgba(255,255,255,0.2); margin: 10px 0;">
                        <span style="color: rgba(255,255,255,0.6); font-size: 0.85em; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; padding: 0 20px;">Area Admin</span>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 10px; vertical-align: middle;">
                                <rect x="3" y="3" width="7" height="7"></rect>
                                <rect x="14" y="3" width="7" height="7"></rect>
                                <rect x="14" y="14" width="7" height="7"></rect>
                                <rect x="3" y="14" width="7" height="7"></rect>
                            </svg>
                            Dashboard Admin
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/programmazione?action=lista">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 10px; vertical-align: middle;">
                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                <polyline points="14 2 14 8 20 8"></polyline>
                                <line x1="16" y1="13" x2="8" y2="13"></line>
                                <line x1="16" y1="17" x2="8" y2="17"></line>
                                <polyline points="10 9 9 9 8 9"></polyline>
                            </svg>
                            Gestione Programmazioni
                        </a>
                    </li>
                    <li class="menu-divider">
                        <hr style="border: none; border-top: 1px solid rgba(255,255,255,0.2); margin: 10px 0;">
                    </li>
                </c:if>

                <!-- Sezione PERSONALE - visibile solo al personale -->
                <c:if test="${sessionScope.utenteLoggato.tipoAccount == 'Personale'}">
                    <li class="menu-divider">
                        <hr style="border: none; border-top: 1px solid rgba(255,255,255,0.2); margin: 10px 0;">
                        <span style="color: rgba(255,255,255,0.6); font-size: 0.85em; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; padding: 0 20px;">Area Staff</span>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/staff/dashboard">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 10px; vertical-align: middle;">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                            Dashboard Staff
                        </a>
                    </li>
                    <li class="menu-divider">
                        <hr style="border: none; border-top: 1px solid rgba(255,255,255,0.2); margin: 10px 0;">
                    </li>
                </c:if>

                <!-- Menu comune a tutti gli utenti loggati -->
                <li>
                    <a href="${pageContext.request.contextPath}/utente/mostra-profilo">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 10px; vertical-align: middle;">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                        Profilo ${sessionScope.utenteLoggato.nome}
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/utente/storico-acquisti">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 10px; vertical-align: middle;">
                            <path d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"></path>
                            <polyline points="13 2 13 9 20 9"></polyline>
                        </svg>
                        I Miei Biglietti
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/utente/logout">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 10px; vertical-align: middle;">
                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                            <polyline points="16 17 21 12 16 7"></polyline>
                            <line x1="21" y1="12" x2="9" y2="12"></line>
                        </svg>
                        Logout
                    </a>
                </li>
            </c:when>
            <c:otherwise>
                <!-- User not logged in -->
                <li>
                    <a href="${pageContext.request.contextPath}/utente/login">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 10px; vertical-align: middle;">
                            <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                            <polyline points="10 17 15 12 10 7"></polyline>
                            <line x1="15" y1="12" x2="3" y2="12"></line>
                        </svg>
                        Login
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/utente/registrazione">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 10px; vertical-align: middle;">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="8.5" cy="7" r="4"></circle>
                            <line x1="20" y1="8" x2="20" y2="14"></line>
                            <line x1="23" y1="11" x2="17" y2="11"></line>
                        </svg>
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

    /* Menu divider styling */
    .menu-divider {
        list-style: none;
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