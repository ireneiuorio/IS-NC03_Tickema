<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard Staff - Tickema</title>

  <!-- CSS Base -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

  <style>
    /* Hero Section */
    .hero {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
      padding: 80px 30px;
      text-align: center;
      margin-bottom: 50px;
      position: relative;
      overflow: hidden;
    }

    .hero::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.1)" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,112C672,96,768,96,864,112C960,128,1056,160,1152,160C1248,160,1344,128,1392,112L1440,96L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>') no-repeat bottom;
      background-size: cover;
      opacity: 0.3;
    }

    .hero-content {
      position: relative;
      z-index: 1;
    }

    .hero h1 {
      font-size: 3.5em;
      font-weight: bold;
      font-style: italic;
      margin-bottom: 15px;
      letter-spacing: 2px;
      text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
    }

    .hero p {
      font-size: 1.3em;
      opacity: 0.95;
      margin-bottom: 10px;
    }

    .admin-badge {
      display: inline-block;
      background: rgba(255, 255, 255, 0.2);
      padding: 8px 20px;
      border-radius: 20px;
      font-size: 0.9em;
      margin-top: 10px;
      backdrop-filter: blur(10px);
    }

    /* Container */
    .dashboard-container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 0 30px 80px;
    }

    /* Sezione Gestione */
    .gestione-section {
      margin-bottom: 50px;
    }

    .section-title {
      font-size: 2.2em;
      color: var(--dark);
      margin-bottom: 35px;
      font-weight: 700;
      position: relative;
      padding-left: 20px;
    }

    .section-title::before {
      content: '';
      position: absolute;
      left: 0;
      top: 50%;
      transform: translateY(-50%);
      width: 5px;
      height: 40px;
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      border-radius: 3px;
    }

    /* Grid Azioni - Centrato per card singola */
    .actions-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
      gap: 35px;
      justify-items: center;
    }

    .action-card {
      background: white;
      border-radius: 20px;
      overflow: hidden;
      box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      cursor: pointer;
      text-decoration: none;
      display: block;
      border: 2px solid transparent;
      max-width: 500px;
      width: 100%;
    }

    .action-card:hover {
      transform: translateY(-12px);
      box-shadow: 0 20px 50px rgba(109, 93, 110, 0.25);
      border-color: var(--primary);
    }

    .action-icon-wrapper {
      width: 100%;
      height: 250px;
      position: relative;
      overflow: hidden;
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .action-icon-wrapper::before {
      content: '';
      position: absolute;
      top: -50%;
      left: -50%;
      width: 200%;
      height: 200%;
      background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
      animation: pulse 3s ease-in-out infinite;
    }

    @keyframes pulse {
      0%, 100% { transform: scale(1); opacity: 0.5; }
      50% { transform: scale(1.1); opacity: 0.8; }
    }

    .action-icon {
      position: relative;
      z-index: 1;
      transition: transform 0.4s ease;
    }

    .action-icon svg {
      width: 100px;
      height: 100px;
      stroke: white;
      filter: drop-shadow(0 4px 6px rgba(0, 0, 0, 0.2));
    }

    .action-card:hover .action-icon {
      transform: scale(1.15) rotate(5deg);
    }

    .action-info {
      padding: 35px 30px;
      background: white;
    }

    .action-title {
      font-size: 1.7em;
      font-weight: 700;
      color: var(--dark);
      margin-bottom: 15px;
      line-height: 1.3;
    }

    .action-description {
      color: #666;
      font-size: 1.05em;
      line-height: 1.7;
      margin-bottom: 20px;
    }

    .action-link {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      color: var(--primary);
      font-weight: 600;
      font-size: 1em;
      transition: gap 0.3s ease;
    }

    .action-card:hover .action-link {
      gap: 12px;
    }

    .action-link::after {
      content: '→';
      font-size: 1.2em;
    }

    /* Link Utili Section */
    .links-section {
      background: white;
      border-radius: 20px;
      padding: 40px;
      box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
    }

    .links-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 20px;
      margin-top: 25px;
    }

    .link-card {
      background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
      border: 2px solid #e9ecef;
      border-radius: 12px;
      padding: 25px;
      text-decoration: none;
      color: var(--dark);
      display: flex;
      align-items: center;
      gap: 18px;
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
    }

    .link-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(109, 93, 110, 0.1), transparent);
      transition: left 0.5s ease;
    }

    .link-card:hover::before {
      left: 100%;
    }

    .link-card:hover {
      border-color: var(--primary);
      transform: translateX(8px);
      box-shadow: 0 4px 15px rgba(109, 93, 110, 0.15);
    }

    .link-icon {
      flex-shrink: 0;
      width: 50px;
      height: 50px;
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 1.3em;
      transition: transform 0.3s ease;
    }

    .link-card:hover .link-icon {
      transform: scale(1.1) rotate(-5deg);
    }

    .link-text {
      font-size: 1.05em;
      font-weight: 600;
      position: relative;
      z-index: 1;
    }

    /* Responsive */
    @media (max-width: 768px) {
      .hero {
        padding: 60px 30px;
      }

      .hero h1 {
        font-size: 2.2em;
      }

      .hero p {
        font-size: 1.1em;
      }

      .section-title {
        font-size: 1.8em;
      }

      .actions-grid,
      .links-grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body>
<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Hero Section -->
<section class="hero">
  <div class="hero-content">
    <h1>Dashboard Personale</h1>
    <p>Benvenuto, ${sessionScope.utenteLoggato.nome} ${sessionScope.utenteLoggato.cognome}</p>
    <div class="admin-badge">Pannello Staff</div>
  </div>
</section>

<!-- Main Content -->
<main>
  <div class="dashboard-container">

    <!-- Sezione Gestione -->
    <div class="gestione-section">
      <h2 class="section-title">Le Tue Funzioni</h2>

      <div class="actions-grid">
        <!-- Validazione Acquisti -->
        <a href="${pageContext.request.contextPath}/staff/validazione-acquisti"
           class="action-card">
          <div class="action-icon-wrapper">
            <div class="action-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="20 6 9 17 4 12"></polyline>
              </svg>
            </div>
          </div>
          <div class="action-info">
            <h3 class="action-title">Validazione Acquisti</h3>
            <p class="action-description">
              Valida i biglietti degli utenti e gestisci gli accessi alle proiezioni cinematografiche
            </p>
            <span class="action-link">Vai alla validazione</span>
          </div>
        </a>
      </div>
    </div>

    <!-- Link Utili -->
    <div class="links-section">
      <h2 class="section-title">Link Rapidi</h2>

      <div class="links-grid">
        <a href="${pageContext.request.contextPath}/" class="link-card">
          <div class="link-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
            </svg>
          </div>
          <div class="link-text">Torna alla Home</div>
        </a>

        <a href="${pageContext.request.contextPath}/catalogo" class="link-card">
          <div class="link-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <rect x="2" y="7" width="20" height="15" rx="2" ry="2"></rect>
              <polyline points="17 2 12 7 7 2"></polyline>
            </svg>
          </div>
          <div class="link-text">Visualizza Catalogo</div>
        </a>

        <a href="${pageContext.request.contextPath}/programmazioniutente" class="link-card">
          <div class="link-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
              <line x1="16" y1="2" x2="16" y2="6"></line>
              <line x1="8" y1="2" x2="8" y2="6"></line>
              <line x1="3" y1="10" x2="21" y2="10"></line>
            </svg>
          </div>
          <div class="link-text">Visualizza Programmazioni</div>
        </a>

        <a href="${pageContext.request.contextPath}/utente/mostra-profilo" class="link-card">
          <div class="link-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
              <circle cx="12" cy="7" r="4"></circle>
            </svg>
          </div>
          <div class="link-text">Il Mio Profilo</div>
        </a>
      </div>
    </div>

  </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>