<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Errore - Tickema</title>

    <!-- CSS Base -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        .error-container {
            max-width: 700px;
            margin: 60px auto;
            padding: 0 20px;
        }

        .error-card {
            background: var(--white);
            border-radius: 20px;
            box-shadow: 0 10px 40px var(--shadow);
            overflow: hidden;
        }

        .error-header {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            color: var(--white);
            padding: 50px 30px;
            text-align: center;
        }

        .error-icon {
            font-size: 5em;
            margin-bottom: 20px;
            animation: shake 0.5s;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-10px); }
            20%, 40%, 60%, 80% { transform: translateX(10px); }
        }

        .error-header h1 {
            font-size: 2.5em;
            font-weight: 300;
            margin-bottom: 10px;
            letter-spacing: 2px;
        }

        .error-header p {
            font-size: 1.1em;
            opacity: 0.9;
        }

        .error-content {
            padding: 40px 30px;
        }

        .error-message {
            background: linear-gradient(135deg, #fff3cd 0%, #ffe69c 100%);
            border-left: 5px solid #ffc107;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 30px;
        }

        .error-message-title {
            color: #856404;
            font-size: 1.3em;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .error-message-text {
            color: #856404;
            font-size: 1.1em;
            line-height: 1.6;
        }

        .error-suggestions {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 30px;
        }

        .error-suggestions h3 {
            color: var(--dark);
            font-size: 1.3em;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .error-suggestions ul {
            list-style: none;
            padding: 0;
        }

        .error-suggestions li {
            padding: 12px 0;
            color: #555;
            font-size: 1.05em;
            display: flex;
            align-items: start;
            gap: 10px;
        }

        .error-suggestions li:before {
            content: "→";
            color: var(--primary);
            font-weight: bold;
            font-size: 1.2em;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            flex: 1;
            padding: 15px 30px;
            border: none;
            border-radius: 12px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: var(--white);
            box-shadow: 0 5px 20px var(--shadow);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px var(--shadow);
        }

        .btn-secondary {
            background: var(--white);
            color: var(--dark);
            border: 2px solid var(--primary);
        }

        .btn-secondary:hover {
            background: var(--light-gray);
            transform: translateY(-2px);
        }

        .error-code {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid var(--border);
            color: #999;
            font-size: 0.9em;
        }

        @media (max-width: 768px) {
            .error-header {
                padding: 40px 20px;
            }

            .error-header h1 {
                font-size: 1.8em;
            }

            .error-icon {
                font-size: 3.5em;
            }

            .button-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Main Content -->
<main>
    <div class="error-container">
        <div class="error-card">
            <!-- Header -->
            <div class="error-header">
                <div class="error-icon">❌</div>
                <h1>Ops! Qualcosa è andato storto</h1>
                <p>Si è verificato un errore durante l'operazione</p>
            </div>

            <div class="error-content">
                <!-- Messaggio di errore -->
                <div class="error-message">
                    <div class="error-message-title">
                        <span>⚠️</span>
                        <span>Dettagli errore:</span>
                    </div>
                    <div class="error-message-text">
                        <c:choose>
                            <c:when test="${not empty errore}">
                                ${errore}
                            </c:when>
                            <c:otherwise>
                                Si è verificato un errore imprevisto. Riprova più tardi.
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Suggerimenti -->
                <div class="error-suggestions">
                    <h3>💡 Cosa puoi fare:</h3>
                    <ul>
                        <li>Verifica di essere connesso al tuo account</li>
                        <li>Torna alla homepage e riprova</li>
                        <li>Controlla la tua connessione internet</li>
                        <li>Se il problema persiste, contatta l'assistenza</li>
                    </ul>
                </div>

                <!-- Bottoni -->
                <div class="button-group">
                    <a href="javascript:history.back()" class="btn btn-secondary">
                        ← Torna Indietro
                    </a>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                        🏠 Vai alla Home
                    </a>
                </div>

                <!-- Error Code (opzionale) -->
                <c:if test="${not empty pageContext.errorData}">
                    <div class="error-code">
                        Codice errore: ${pageContext.errorData.statusCode}
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>