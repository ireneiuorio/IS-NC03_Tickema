<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifica Profilo - Tickema</title>

    <!-- CSS Base -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* Contenitore principale della modifica profilo */
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

        /* Hint sotto i campi */
        .field-hint {
            font-size: 0.85em;
            color: #666;
            margin-top: 5px;
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
        <h1 class="edit-title">Modifica Profilo</h1>
        <p class="edit-subtitle">Aggiorna i tuoi dati personali</p>

        <!-- Messaggio di errore (si mostra solo se c'è un errore) -->
        <c:if test="${not empty errore}">
            <div class="error-message">
                <span>⚠️</span>
                <span>${errore}</span>
            </div>
        </c:if>

        <!-- Form di modifica profilo -->
        <form id="form-modifica-profilo"
              class="auth-form"
              action="${pageContext.request.contextPath}/utente/modifica-profilo"
              method="post">

            <!-- Nome e Cognome sulla stessa riga -->
            <div class="form-row">
                <!-- Campo Nome -->
                <div class="form-group">
                    <label for="nome">Nome</label>
                    <input type="text"
                           id="nome"
                           name="nome"
                           placeholder="Il tuo nome"
                           value="${utente.nome}"
                           required>
                </div>

                <!-- Campo Cognome -->
                <div class="form-group">
                    <label for="cognome">Cognome</label>
                    <input type="text"
                           id="cognome"
                           name="cognome"
                           placeholder="Il tuo cognome"
                           value="${utente.cognome}"
                           required>
                </div>
            </div>

            <!-- Campo Telefono -->
            <div class="form-group">
                <label for="numeroDiTelefono">Numero di Telefono</label>
                <input type="tel"
                       id="numeroDiTelefono"
                       name="numeroDiTelefono"
                       placeholder="3331234567"
                       value="${utente.numeroDiTelefono}"
                       pattern="[0-9]{10}"
                       title="Inserisci un numero di telefono valido (10 cifre)"
                       required>
                <span class="field-hint">Inserisci 10 cifre senza spazi</span>
            </div>

            <!-- Info non modificabili -->
            <div class="form-group">
                <label>Email (non modificabile)</label>
                <input type="email"
                       value="${utente.email}"
                       disabled
                       style="background: #f5f5f5; cursor: not-allowed;">
                <span class="field-hint">Per modificare l'email, vai su "Modifica Credenziali"</span>
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

</body>
</html>