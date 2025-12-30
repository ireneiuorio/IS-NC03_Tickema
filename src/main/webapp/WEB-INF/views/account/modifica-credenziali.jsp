<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifica Credenziali - Tickema</title>

    <!-- CSS Base -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* Contenitore principale della modifica credenziali */
        .edit-container {
            min-height: calc(100vh - 300px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        /* Card del form di modifica */
        .edit-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(109, 93, 110, 0.2);
            padding: 50px;
            max-width: 600px;
            width: 100%;
        }

        /* Titolo del form */
        .edit-title {
            font-size: 2.5em;
            color: var(--dark);
            text-align: center;
            margin-bottom: 15px;
            font-weight: 300;
            letter-spacing: 2px;
        }

        /* Sottotitolo */
        .edit-subtitle {
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

        /* Bottoni */
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 10px;
        }

        .btn-save {
            flex: 1;
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: white;
            padding: 16px;
            border: none;
            border-radius: 10px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(109, 93, 110, 0.3);
        }

        .btn-cancel {
            flex: 1;
            background: white;
            color: var(--dark);
            padding: 16px;
            border: 2px solid var(--border);
            border-radius: 10px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
            display: inline-block;
        }

        .btn-cancel:hover {
            border-color: var(--primary);
            color: var(--primary);
        }

        /* Responsive per mobile */
        @media (max-width: 768px) {
            .edit-card {
                padding: 35px 25px;
            }

            .edit-title {
                font-size: 2em;
            }

            /* Su mobile i campi vanno in colonna */
            .form-row {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp"/>

<!-- Contenitore principale della modifica profilo -->
<div class="edit-container">
    <div class="edit-card">

        <!-- Titolo -->
        <h1 class="edit-title">Modifica Credenziali</h1>
        <p class="edit-subtitle">Aggiorna le tue credenziali</p>

        <!-- Messaggio di errore (si mostra solo se c'è un errore) -->
        <c:if test="${not empty errore}">
            <div class="error-message">
                <span>${errore}</span>
            </div>
        </c:if>

        <!-- Form di modifica credenziali -->
        <form id="form-modifica-credenziali"
              class="auth-form"
              action="${pageContext.request.contextPath}/utente/modifica-credenziali"
              method="post">

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

            <!-- Campo Password -->
            <div class="form-group">
                <label for="password">Password *</label>
                <input type="password"
                       id="password"
                       name="password"
                       placeholder="Crea una password sicura"
                       minlength="8"
                       required>
                <div class="password-strength" id="passwordStrength"></div>
                <span class="password-hint">Almeno 8 caratteri</span>
            </div>

            <!-- Campo Conferma Password -->
            <div class="form-group">
                <label for="confermaPassword">Conferma Password *</label>
                <input type="password"
                       id="confermaPassword"
                       name="confermaPassword"
                       placeholder="Reinserisci la password"
                       minlength="8"
                       required>
            </div>

            <!-- Bottoni di azione -->
            <div class="form-actions">
                <button type="submit" class="btn-save">
                    Salva Modifiche
                </button>

                <a href="${pageContext.request.contextPath}/utente/mostra-profilo"
                   class="btn-cancel">
                    Annulla
                </a>
            </div>

        </form>

    </div>
</div>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script>
    // Validazione password in tempo reale
    const passwordInput = document.getElementById('password');
    const passwordStrength = document.getElementById('passwordStrength');
    const confermaPasswordInput = document.getElementById('confermaPassword');
    const form = document.getElementById('form-modifica-credenziali');

    // Controlla la forza della password mentre l'utente digita
    passwordInput.addEventListener('input', function() {
        const password = this.value;
        const strength = calcolaForzaPassword(password);

        // Rimuovi tutte le classi precedenti
        passwordStrength.className = 'password-strength';

        // Aggiungi la classe appropriata
        if (password.length > 0) {
            if (strength < 3) {
                passwordStrength.classList.add('weak');
            } else if (strength < 5) {
                passwordStrength.classList.add('medium');
            } else {
                passwordStrength.classList.add('strong');
            }
        }
    });

    // Calcola un punteggio di forza della password
    function calcolaForzaPassword(password) {
        let strength = 0;

        if (password.length >= 8) strength++;
        if (password.length >= 12) strength++;
        if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
        if (/\d/.test(password)) strength++;
        if (/[^a-zA-Z0-9]/.test(password)) strength++;

        return strength;
    }

    // Validazione form prima dell'invio
    form.addEventListener('submit', function(e) {
        const password = passwordInput.value;
        const confermaPassword = confermaPasswordInput.value;

        // Controlla che le password corrispondano
        if (password !== confermaPassword) {
            e.preventDefault();
            alert('Le password non corrispondono!');
            confermaPasswordInput.focus();
            return false;
        }

        // Controlla lunghezza minima password
        if (password.length < 8) {
            e.preventDefault();
            alert('La password deve essere di almeno 8 caratteri!');
            passwordInput.focus();
            return false;
        }

        return true;
    });
</script>

</body>
</html>