<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Siamo - Tickema</title>

    <!-- CSS Base -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

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
            font-size: 3em;
            font-weight: bold;
            font-style: italic;
            margin-bottom: 15px;
            letter-spacing: 2px;
        }

        .hero p {
            font-size: 1.2em;
            opacity: 0.95;
            max-width: 700px;
            margin: 0 auto;
        }

        /* Container */
        .chi-siamo-container {
            max-width: 900px;
            margin: 0 auto 80px;
            padding: 0 30px;
        }

        /* Section */
        .section {
            background: white;
            border-radius: 16px;
            padding: 45px;
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.04);
            margin-bottom: 30px;
        }

        .section h2 {
            font-size: 2em;
            color: var(--dark);
            margin-bottom: 20px;
            font-weight: 600;
        }

        .section p {
            font-size: 1.1em;
            line-height: 1.8;
            color: #333;
            margin-bottom: 15px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 2em;
            }

            .section {
                padding: 30px 25px;
            }
        }
    </style>
</head>
<body>
<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Hero Section -->
<section class="hero">
    <h1>Chi Siamo</h1>
    <p>Innovazione digitale al servizio del cinema</p>
</section>

<!-- Main Content -->
<main>
    <div class="chi-siamo-container">

        <!-- Il Progetto -->
        <div class="section">
            <h2>Il Progetto</h2>
            <p>
                Tickema è una piattaforma web sviluppata nell'ambito del corso di
                Ingegneria del Software presso l'Università degli Studi di Salerno.
            </p>
            <p>
                Il sistema è stato progettato per digitalizzare e semplificare il processo
                di prenotazione e acquisto di biglietti cinematografici, offrendo
                un'interfaccia intuitiva e un'esperienza utente ottimale.
            </p>
        </div>

        <!-- Obiettivi -->
        <div class="section">
            <h2>Obiettivi del Sistema</h2>
            <p>
                Il sistema Tickema è stato progettato per rispondere alle esigenze moderne
                di gestione delle prenotazioni cinematografiche. La piattaforma permette agli utenti
                di consultare il catalogo film, visualizzare le programmazioni disponibili,
                e completare l'acquisto in modo sicuro e veloce.
            </p>
        </div>

    </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

</body>
</html>