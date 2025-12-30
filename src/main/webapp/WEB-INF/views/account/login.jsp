<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Tickema</title>

    <!-- CSS Base -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* Contenitore principale del login */
        .login-container {
            min-height: calc(100vh - 300px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        /* Card del form di login */
        .login-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(109, 93, 110, 0.2);
            padding: 50px;
            max-width: 500px;
            width: 100%;
        }

        /* Titolo del form */
        .login-title {
            font-size: 2.5em;
            color: var(--dark);
            text-align: center;
            margin-bottom: 15px;
            font-weight: 300;
            letter-spacing: 2px;
        }

        /* Sottotitolo */
        .login-subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 40px;
            font-size: 1.1em;
        }

        /* Form */
        .auth-form {
            display: flex;
            flex-direction: column;
            gap: 25px;
        }

        /* Gruppo di input (label + campo) */
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        /* Label dei campi */
        .form-group label {
            color: var(--dark);
            font-weight: 600;
            font-size: 0.95em;
        }

        /* Campi input */
        .form-group input {
            padding: 15px;
            border: 2px solid var(--border);
            border-radius: 10px;
            font-size: 1em;
            font-family: 'Inter', sans-serif;
            transition: all 0.3s ease;
        }

        /* Input quando ha il focus (quando ci clicchi dentro) */
        .form-group input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(109, 93, 110, 0.1);
        }

        /* Messaggio di errore */
        .error-message {
            background: #fee;
            color: #c33;
            padding: 15px;
            border-radius: 10px;
            border-left: 4px solid #c33;
            font-size: 0.95em;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Bottone di submit */
        .btn-login {
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: white;
            padding: 16px;
            border: none;
            border-radius: 10px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(109, 93, 110, 0.3);
        }

        /* Link alla registrazione */
        .register-link {
            text-align: center;
            margin-top: 25px;
            color: #666;
            font-size: 0.95em;
        }

        .register-link a {
            color: var(--primary);
            font-weight: 600;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .register-link a:hover {
            color: var(--dark);
            text-decoration: underline;
        }

        /* Responsive per mobile */
        @media (max-width: 768px) {
            .login-card {
                padding: 35px 25px;
            }

            .login-title {
                font-size: 2em;
            }
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Contenitore principale del login -->
<div class="login-container">
    <div class="login-card">

        <!-- Titolo -->
        <h1 class="login-title">Accedi</h1>
        <p class="login-subtitle">Bentornato su Tickema!</p>

        <!-- Messaggio di errore (si mostra solo se c'è un errore) -->
        <c:if test="${not empty errore}">
            <div class="error-message">
                <span>${errore}</span>
            </div>
        </c:if>

        <!-- Form di login -->
        <form id="form-login"
              class="auth-form"
              action="${pageContext.request.contextPath}/utente/login"
              method="post">

            <!-- Campo Email -->
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email"
                       id="email"
                       name="email"
                       placeholder="tua@email.com"
                       required>
            </div>

            <!-- Campo Password -->
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password"
                       id="password"
                       name="password"
                       placeholder="••••••••"
                       required>
            </div>

            <!-- Bottone di submit -->
            <button type="submit" class="btn-login">
                Accedi
            </button>

        </form>

        <!-- Link per registrarsi -->
        <div class="register-link">
            Non hai un account?
            <a href="${pageContext.request.contextPath}/utente/registrazione">Registrati qui</a>
        </div>

    </div>
</div>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

</body>
</html>