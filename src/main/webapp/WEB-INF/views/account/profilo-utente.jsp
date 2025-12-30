<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Il Mio Profilo - Tickema</title>

    <!-- CSS Base -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        .profile-container {
            max-width: 800px;
            margin: 60px auto;
            padding: 0 20px;
        }

        .profile-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .profile-avatar-big {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5em;
            font-weight: 700;
            margin: 0 auto 20px;
            box-shadow: 0 10px 25px var(--shadow);
        }

        /* Messaggio di successo */
        .success-message {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 15px;
            border-radius: 10px;
            border-left: 4px solid #2e7d32;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-top: 30px;
        }

        .info-group {
            border-bottom: 1px solid var(--border);
            padding-bottom: 10px;
        }

        .info-label {
            display: block;
            font-size: 0.85em;
            color: #777;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 1.1em;
            font-weight: 600;
            color: var(--dark);
        }

        .profile-actions {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 40px;
        }

        .btn-profile {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 15px;
            font-size: 1em;
        }

        @media (max-width: 600px) {
            .info-grid {
                grid-template-columns: 1fr;
            }
            .profile-actions {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp"/>

<!-- Contenitore principale del profilo -->
<main class="profile-container">

    <div class="profile-header">
        <h1 class="page-title">Il mio profilo</h1>
    </div>

    <!-- Messaggio di successo dopo aggiornamento -->
    <c:if test="${param.update == 'success'}">
        <div class="success-message">
            <span>✓</span>
            <span>Profilo aggiornato con successo!</span>
        </div>
    </c:if>

    <div class="card">
        <!-- Avatar con iniziale del nome -->
        <div class="profile-avatar-big">
            ${fn:substring(utente.nome, 0, 1)}
        </div>

        <!-- Dettagli del profilo utente -->
        <div class="info-grid">

            <div class="info-group">
                <span class="info-label">Nome completo</span>
                <span class="info-value">${utente.nome} ${utente.cognome}</span>
            </div>

            <div class="info-group">
                <span class="info-label">Email</span>
                <span class="info-value">${utente.email}</span>
            </div>

            <div class="info-group">
                <span class="info-label">Numero di telefono</span>
                <span class="info-value">${utente.numeroDiTelefono}</span>
            </div>

            <div class="info-group">
                <span class="info-label">Saldo attuale</span>
                <span class="info-value">€ ${utente.saldo}</span>
            </div>
        </div>

        <!-- Azioni del profilo -->
        <div class="profile-actions">
            <a href="${pageContext.request.contextPath}/utente/storico-acquisti"
               class="btn btn-primary btn-profile">
                <span>Storico acquisti</span>
            </a>

            <a href="${pageContext.request.contextPath}/utente/modifica-profilo"
               class="btn btn-secondary btn-profile">
                <span>Modifica Profilo</span>
            </a>

            <a href="${pageContext.request.contextPath}/utente/modifica-credenziali"
               class="btn btn-secondary btn-profile">
                <span>Modifica Credenziali</span>
            </a>

            <a href="${pageContext.request.contextPath}/utente/logout"
               class="btn btn-secondary btn-profile">
                <span>Logout</span>
            </a>
        </div>
    </div>

</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

</body>
</html>