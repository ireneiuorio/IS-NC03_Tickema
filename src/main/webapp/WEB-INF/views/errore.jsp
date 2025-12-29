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
            margin: 60px auto 80px;
            padding: 0 30px;
        }

        .error-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.04);
            overflow: hidden;
        }

        .error-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: white;
            padding: 50px 30px;
            text-align: center;
        }

        .error-icon {
            font-size: 4em;
            margin-bottom: 20px;
        }

        .error-header h1 {
            font-size: 2.2em;
            font-weight: 600;
            margin-bottom: 10px;
            letter-spacing: 1px;
        }

        .error-header p {
            font-size: 1.1em;
            opacity: 0.95;
        }

        .error-content {
            padding: 40px 35px;
        }

        .error-message {
            background: #fff3e0;
            border-left: 4px solid #ff9800;
            padding: 25px;
            border-radius: 8px;
            margin-bottom: 30px;
        }

        .error-message-title {
            color: #e65100;
            font-size: 1.2em;
            font-weight: 600;
            margin-bottom: 12px;
        }

        .error-message-text {
            color: #e65100;
            font-size: 1.05em;
            line-height: 1.7;
        }

        .error-suggestions {
            background: var(--light-gray);
            padding: 25px;
            border-radius: 8px;
            margin-bottom: 30px;
        }

        .error-suggestions h3 {
            color: var(--dark);
            font-size: 1.2em;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .error-suggestions ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .error-suggestions li {
            padding: 10px 0;
            color: #555;
            font-size: 1em;
            line-height: 1.6;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            flex: 1;
            padding: 14px 28px;
            border: none;
            border-radius: 8px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(109, 93, 110, 0.25);
        }

        .btn-secondary {
            background: white;
            color: var(--dark);
            border: 1px solid var(--border);
        }

        .btn-secondary:hover {
            border-color: var(--primary);
            background: var(--light-gray);
            transform: translateY(-2px);
        }

        .error-code {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid var(--border);
            color: #999;
            font-size: 0.9em;
        }

        @media (max-width: 768px) {
            .error-container {
                margin: 40px auto 60px;
            }

            .error-header {
                padding: 40px 25px;
            }

            .error-header h1 {
                font-size: 1.8em;
            }

            .error-icon {
                font-size: 3em;
            }

            .error-content {
                padding: 30px 25px;
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
                <div class="error-icon"></div>
                <h1>Ops! Qualcosa è andato storto</h1>
                <p>Si è verificato un errore durante l'operazione</p>
            </div>

            <div class="error-content">
                <!-- Messaggio di errore -->
                <div class="error-message">
                    <div class="error-message-title">
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
                    <h3>Cosa puoi fare:</h3>
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
                        Vai alla Home
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