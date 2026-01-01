<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrazione - Tickema</title>

    <!-- CSS Base -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* Contenitore principale della registrazione */
        .register-container {
            min-height: calc(100vh - 300px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        /* Card del form di registrazione */
        .register-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(109, 93, 110, 0.2);
            padding: 50px;
            max-width: 600px;
            width: 100%;
        }

        /* Titolo del form */
        .register-title {
            font-size: 2.5em;
            color: var(--dark);
            text-align: center;
            margin-bottom: 15px;
            font-weight: 700;
            letter-spacing: 2px;
        }

        /* Sottotitolo */
        .register-subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 40px;
            font-size: 1.1em;
        }

        /* Form */
        .auth-form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        /* Layout a 2 colonne per Nome e Cognome */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
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

        /* Input quando ha il focus */
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

        /* Password Strength Indicator */
        .password-strength {
            margin-top: 8px;
            font-size: 0.85em;
            font-weight: 600;
            padding: 8px 12px;
            border-radius: 8px;
            text-align: center;
            transition: all 0.3s ease;
            display: none; /* Nascosto di default */
        }

        .password-strength.weak {
            display: block;
            background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
            color: #c62828;
            border-left: 4px solid #c62828;
        }

        .password-strength.medium {
            display: block;
            background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
            color: #f57c00;
            border-left: 4px solid #f57c00;
        }

        .password-strength.strong {
            display: block;
            background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
            color: #2e7d32;
            border-left: 4px solid #2e7d32;
        }

        .password-hint {
            font-size: 0.85em;
            color: #666;
            margin-top: 5px;
            display: block;
        }

        /* Bottone di submit */
        .btn-register {
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

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(109, 93, 110, 0.3);
        }

        /* Link al login */
        .login-link {
            text-align: center;
            margin-top: 25px;
            color: #666;
            font-size: 0.95em;
        }

        .login-link a {
            color: var(--primary);
            font-weight: 600;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .login-link a:hover {
            color: var(--dark);
            text-decoration: underline;
        }

        /* Responsive per mobile */
        @media (max-width: 768px) {
            .register-card {
                padding: 35px 25px;
            }

            .register-title {
                font-size: 2em;
            }

            /* Su mobile i campi vanno in colonna */
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Contenitore principale della registrazione -->
<div class="register-container">
    <div class="register-card">

        <!-- Titolo -->
        <h1 class="register-title">Registrati</h1>
        <p class="register-subtitle">Crea il tuo account Tickema</p>

        <!-- Messaggio di errore (si mostra solo se c'è un errore) -->
        <c:if test="${not empty errore}">
            <div class="error-message">
                <span>${errore}</span>
            </div>
        </c:if>

        <!-- Form di registrazione -->
        <form id="form-registrazione"
              class="auth-form"
              action="${pageContext.request.contextPath}/utente/registrazione"
              method="post">

            <!-- Nome e Cognome sulla stessa riga -->
            <div class="form-row">
                <!-- Campo Nome -->
                <div class="form-group">
                    <label for="nome">Nome *</label>
                    <input type="text"
                           id="nome"
                           name="nome"
                           placeholder="Mario"
                           value="${param.nome}"
                           required>
                </div>

                <!-- Campo Cognome -->
                <div class="form-group">
                    <label for="cognome">Cognome *</label>
                    <input type="text"
                           id="cognome"
                           name="cognome"
                           placeholder="Rossi"
                           value="${param.cognome}"
                           required>
                </div>
            </div>

            <!-- Campo Email -->
            <div class="form-group">
                <label for="email">Email *</label>
                <input type="email"
                       id="email"
                       name="email"
                       placeholder="tua@email.com"
                       value="${param.email}"
                       required>
            </div>

            <!-- Campo Telefono -->
            <div class="form-group">
                <label for="telefono">Numero di Telefono *</label>
                <input type="tel"
                       id="telefono"
                       name="telefono"
                       placeholder="3331234567"
                       value="${param.telefono}"
                       pattern="[0-9]{10}"
                       title="Inserisci un numero di telefono valido (10 cifre)"
                       required>
                <span class="password-hint">Inserisci 10 cifre senza spazi</span>
            </div>

            <!-- Campo Password -->
            <div class="form-group">
                <label for="password">Password *</label>
                <input type="password"
                       id="password"
                       name="password"
                       placeholder="Crea una password sicura"
                       minlength="6"
                       required>
                <div class="password-strength" id="passwordStrength"></div>
                <span class="password-hint">Almeno 6 caratteri, una maiuscola e un carattere speciale</span>
            </div>

            <!-- Campo Conferma Password -->
            <div class="form-group">
                <label for="confermaPassword">Conferma Password *</label>
                <input type="password"
                       id="confermaPassword"
                       name="confermaPassword"
                       placeholder="Reinserisci la password"
                       minlength="6"
                       required>
            </div>

            <!-- Bottone di submit -->
            <button type="submit" class="btn-register">
                Registrati
            </button>

        </form>

        <!-- Link per login -->
        <div class="login-link">
            Hai già un account?
            <a href="${pageContext.request.contextPath}/utente/login">Accedi qui</a>
        </div>

    </div>
</div>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script>
    // Validazione password in tempo reale
    const passwordInput = document.getElementById('password');
    const passwordStrength = document.getElementById('passwordStrength');
    const confermaPasswordInput = document.getElementById('confermaPassword');
    const form = document.getElementById('form-registrazione');

    // Controlla la forza della password mentre l'utente digita
    passwordInput.addEventListener('input', function() {
        const password = this.value;
        const strength = calcolaForzaPassword(password);

        // Rimuovi tutte le classi precedenti
        passwordStrength.className = 'password-strength';

        // Aggiungi la classe appropriata
        if (password.length > 0) {
            if (strength < 2) {
                passwordStrength.classList.add('weak');
                passwordStrength.textContent = 'Debole';
            } else if (strength < 3) {
                passwordStrength.classList.add('medium');
                passwordStrength.textContent = 'Media';
            } else {
                passwordStrength.classList.add('strong');
                passwordStrength.textContent = 'Forte';
            }
        } else {
            passwordStrength.textContent = '';
        }
    });

    // Calcola un punteggio di forza della password
    function calcolaForzaPassword(password) {
        let strength = 0;

        // Lunghezza minima 6 caratteri
        if (password.length >= 6) strength++;

        // Contiene almeno una lettera maiuscola
        if (/[A-Z]/.test(password)) strength++;

        // Contiene almeno un carattere speciale
        if (/[^a-zA-Z0-9]/.test(password)) strength++;

        return strength;
    }

    // Validazione form prima dell'invio
    form.addEventListener('submit', function(e) {
        const password = passwordInput.value;
        const confermaPassword = confermaPasswordInput.value;

        // Controlla lunghezza minima password
        if (password.length < 6) {
            e.preventDefault();
            alert('La password deve essere di almeno 6 caratteri!');
            passwordInput.focus();
            return false;
        }

        // Controlla lettera maiuscola
        if (!/[A-Z]/.test(password)) {
            e.preventDefault();
            alert('La password deve contenere almeno una lettera maiuscola!');
            passwordInput.focus();
            return false;
        }

        // Controllo carattere speciale
        if (!/[^a-zA-Z0-9]/.test(password)) {
            e.preventDefault();
            alert('La password deve contenere almeno un carattere speciale (es: !@#$%^&*)!');
            passwordInput.focus();
            return false;
        }

        // Controlla che le password corrispondano
        if (password !== confermaPassword) {
            e.preventDefault();
            alert('Le password non corrispondono!');
            confermaPasswordInput.focus();
            return false;
        }

        return true;
    });
</script>

</body>
</html>