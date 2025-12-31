<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Tickema</title>

    <!-- CSS Base -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* Stili specifici per checkout */
        .checkout-container {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .checkout-card {
            background: var(--white);
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .checkout-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: var(--white);
            padding: 40px 30px;
            text-align: center;
        }

        .checkout-header h1 {
            font-size: 2.5em;
            font-weight: 700;
            margin-bottom: 10px;
            letter-spacing: 1px;
        }

        .checkout-header p {
            font-size: 1.1em;
            opacity: 0.95;
            font-weight: 300;
        }

        .checkout-content {
            padding: 40px 30px;
        }

        /* Timer Box */
        .timer-box {
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            border: 2px solid var(--primary);
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: 0 4px 15px rgba(109, 93, 110, 0.15);
        }

        .timer-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            font-size: 1.8em;
            font-weight: 700;
            flex-shrink: 0;
        }

        .timer-text {
            flex: 1;
        }

        .timer-text span:first-child {
            display: block;
            font-size: 0.95em;
            color: var(--dark);
            margin-bottom: 8px;
            font-weight: 600;
        }

        .timer-countdown {
            font-size: 2em;
            font-weight: 700;
            color: var(--primary);
            display: block;
            font-family: 'Courier New', monospace;
        }

        .timer-expired {
            background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
            border-color: #d32f2f;
        }

        .timer-expired .timer-icon {
            background: linear-gradient(135deg, #d32f2f 0%, #b71c1c 100%);
        }

        .timer-warning .timer-countdown {
            color: #d32f2f;
            animation: blink 1s infinite;
        }

        @keyframes blink {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }

        /* Film Info Section */
        .film-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            border-left: 4px solid var(--primary);
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .film-section h2 {
            color: var(--dark);
            font-size: 1.8em;
            margin-bottom: 25px;
            font-weight: 600;
        }

        .film-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .detail-item {
            display: flex;
            flex-direction: column;
            padding: 15px;
            background: var(--white);
            border-radius: 8px;
            border: 1px solid #e0e0e0;
            transition: all 0.3s ease;
        }

        .detail-item:hover {
            border-color: var(--primary);
            box-shadow: 0 3px 12px rgba(109, 93, 110, 0.1);
            transform: translateY(-2px);
        }

        .detail-label {
            font-size: 0.8em;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .detail-value {
            font-size: 1.15em;
            color: var(--dark);
            font-weight: 600;
        }

        /* Form Section */
        .form-section {
            background: var(--white);
            border: 2px solid #e0e0e0;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 25px;
            transition: all 0.3s ease;
        }

        .form-section:hover {
            border-color: var(--primary);
            box-shadow: 0 5px 20px rgba(109, 93, 110, 0.1);
        }

        .form-section h3 {
            color: var(--primary);
            font-size: 1.5em;
            margin-bottom: 25px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-section h3:before {
            content: '';
            width: 4px;
            height: 28px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            border-radius: 2px;
        }

        /* Price Summary */
        .price-summary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: var(--white);
            padding: 35px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 8px 25px rgba(109, 93, 110, 0.25);
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            font-size: 1.1em;
        }

        .price-divider {
            border-top: 2px solid rgba(255,255,255,0.3);
            margin: 20px 0;
        }

        .price-total {
            font-size: 2em;
            font-weight: 700;
            padding-top: 15px;
        }

        /* Checkbox Section */
        .checkbox-wrapper {
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            padding: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }

        .checkbox-wrapper:hover {
            border-color: var(--primary);
            box-shadow: 0 3px 15px rgba(109, 93, 110, 0.1);
        }

        .checkbox-wrapper input[type="checkbox"] {
            width: 22px;
            height: 22px;
            cursor: pointer;
            margin-right: 15px;
            accent-color: var(--primary);
        }

        .checkbox-content {
            display: flex;
            align-items: center;
        }

        .checkbox-label {
            flex: 1;
        }

        .checkbox-label strong {
            font-size: 1.15em;
            color: var(--dark);
            font-weight: 600;
        }

        .checkbox-label small {
            display: block;
            color: #666;
            margin-top: 6px;
            font-size: 0.95em;
        }

        .saldo-badge {
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: var(--white);
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: 600;
            display: inline-block;
            margin-bottom: 20px;
            box-shadow: 0 3px 10px rgba(109, 93, 110, 0.2);
            font-size: 1.05em;
        }

        /* Payment Preview */
        .payment-preview {
            background: linear-gradient(135deg, #f3f0f4 0%, #e8e4e9 100%);
            border-left: 4px solid var(--primary);
            padding: 25px;
            border-radius: 12px;
            margin-top: 20px;
            box-shadow: 0 2px 10px rgba(109, 93, 110, 0.08);
        }

        .payment-preview h4 {
            color: var(--primary);
            margin-bottom: 18px;
            font-size: 1.25em;
            font-weight: 600;
        }

        .payment-preview p {
            margin: 12px 0;
            color: var(--dark);
            font-size: 1.05em;
        }

        .payment-preview strong {
            color: var(--primary);
            font-weight: 600;
        }

        .preview-success {
            background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
            border-left-color: #4caf50;
        }

        .preview-success h4 {
            color: #2e7d32;
        }

        .preview-success strong {
            color: #2e7d32;
        }

        .preview-warning {
            background: linear-gradient(135deg, #fef3e8 0%, #fce8d0 100%);
            border-left-color: var(--primary);
        }

        .preview-warning h4 {
            color: var(--dark);
        }

        .preview-warning strong {
            color: var(--primary);
        }

        .payment-preview p {
            margin: 12px 0;
            color: #2c2c2c !important;
            font-size: 1.05em;
        }

        .payment-preview strong {
            color: #1a1a1a !important;
            font-weight: 600;
        }

        .preview-warning {
            background: linear-gradient(135deg, #fef3e8 0%, #fce8d0 100%);
            border-left-color: var(--primary);
        }

        .preview-warning h4 {
            color: #3e2723;
        }

        /* Alert - Info Style */
        .alert-info {
            padding: 20px 25px;
            border-radius: 12px;
            margin-bottom: 20px;
            display: flex;
            align-items: flex-start;
            gap: 15px;
            background: linear-gradient(135deg, #f0ecf1 0%, #e6e0e7 100%);
            border-left: 4px solid var(--primary);
            box-shadow: 0 2px 8px rgba(109, 93, 110, 0.1);
        }

        .alert-info-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            font-size: 1.3em;
            font-weight: 700;
            flex-shrink: 0;
        }

        .alert-info div {
            flex: 1;
            color: var(--dark);
        }

        .alert-info strong {
            color: var(--primary);
            font-weight: 600;
        }

        /* STILI PER FORM CARTA */
        .card-form-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            border: 2px solid var(--primary);
            border-radius: 15px;
            padding: 30px;
            margin-top: 25px;
            box-shadow: 0 5px 20px rgba(109, 93, 110, 0.1);
        }

        .card-form-section h4 {
            color: var(--primary);
            font-size: 1.4em;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 600;
        }

        .card-form-section h4:before {
            content: '';
            width: 4px;
            height: 28px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            border-radius: 2px;
        }

        .form-group {
            margin-bottom: 22px;
        }

        .form-group label {
            display: block;
            color: var(--dark);
            font-weight: 600;
            margin-bottom: 10px;
            font-size: 0.95em;
        }

        .form-group label .required {
            color: #d32f2f;
            margin-left: 4px;
            font-weight: 700;
        }

        .form-group input {
            width: 100%;
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
            transition: all 0.3s ease;
            font-family: 'Inter', sans-serif;
            box-sizing: border-box;
            background: var(--white);
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(109, 93, 110, 0.1);
            background: #fafafa;
        }

        .form-group input.error {
            border-color: #d32f2f;
            background: #ffebee;
        }

        .form-group .error-message {
            color: #d32f2f;
            font-size: 0.85em;
            margin-top: 6px;
            display: none;
            font-weight: 500;
        }

        .form-group input.error + .error-message {
            display: block;
        }

        .form-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
        }

        .card-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.5em;
            color: var(--primary);
            font-weight: 600;
        }

        .input-with-icon {
            position: relative;
        }

        .input-with-icon input {
            padding-right: 55px;
        }

        /* Buttons */
        .button-group {
            display: flex;
            gap: 20px;
            margin-top: 40px;
        }

        .btn {
            flex: 1;
            padding: 18px 40px;
            border: none;
            border-radius: 12px;
            font-size: 1.2em;
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
            box-shadow: 0 5px 20px rgba(109, 93, 110, 0.3);
        }

        .btn-primary:hover:not(:disabled) {
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(109, 93, 110, 0.4);
        }

        .btn-primary:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .btn-secondary {
            background: var(--white);
            color: var(--dark);
            border: 2px solid var(--primary);
        }

        .btn-secondary:hover {
            background: #f5f5f5;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(109, 93, 110, 0.2);
        }

        @media (max-width: 768px) {
            .checkout-header h1 {
                font-size: 1.8em;
            }

            .film-details {
                grid-template-columns: 1fr;
            }

            .button-group {
                flex-direction: column;
            }

            .price-total {
                font-size: 1.5em;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .timer-box {
                flex-direction: column;
                text-align: center;
            }
        }
    </style>
</head>
<body>
<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Main Content -->
<main>
    <div class="checkout-container">

        <!-- Timer Prenotazione -->
        <c:if test="${not empty scadenzaCheckout}">
            <div class="timer-box" id="timerBox">
                <div class="timer-icon">⏱</div>
                <div class="timer-text">
                    <span>Tempo rimanente per completare l'acquisto</span>
                    <span class="timer-countdown" id="countdown">5:00</span>
                </div>
            </div>
        </c:if>

        <div class="checkout-card">
            <!-- Header -->
            <div class="checkout-header">
                <h1>Checkout</h1>
                <p>Completa il tuo acquisto in pochi semplici passi</p>
            </div>

            <div class="checkout-content">
                <!-- Film Info -->
                <div class="film-section">
                    <h2>${programmazione.film.titolo}</h2>
                    <div class="film-details">
                        <div class="detail-item">
                            <div class="detail-label">Data</div>
                            <div class="detail-value">
                                ${programmazione.dataProgrammazione}
                            </div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Orario</div>
                            <div class="detail-value">${programmazione.slotOrari.oraInizio}</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Sala</div>
                            <div class="detail-value">${programmazione.sala.nome}</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Durata</div>
                            <div class="detail-value">${programmazione.film.durata} min</div>
                        </div>
                    </div>
                </div>

                <!-- Form -->
                <form id="checkoutForm" method="POST" action="${pageContext.request.contextPath}/acquisto">
                    <input type="hidden" name="idProgrammazione" value="${programmazione.idProgrammazione}">
                    <input type="hidden" name="numeroBiglietti" value="${numeroBiglietti}">

                    <!-- Riepilogo Prezzi -->
                    <div class="price-summary">
                        <div class="price-row">
                            <span>Prezzo unitario</span>
                            <span>€<fmt:formatNumber value="${prezzoTotale / numeroBiglietti}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="price-row">
                            <span>Numero biglietti</span>
                            <span>${numeroBiglietti}</span>
                        </div>
                        <div class="price-divider"></div>
                        <div class="price-row price-total">
                            <span>TOTALE</span>
                            <span>€<fmt:formatNumber value="${prezzoTotale}" pattern="#,##0.00"/></span>
                        </div>
                    </div>

                    <!-- Metodo Pagamento -->
                    <div class="form-section">
                        <h3>Metodo di Pagamento</h3>

                        <div class="saldo-badge">
                            Saldo disponibile: €<fmt:formatNumber value="${saldoDisponibile}" pattern="#,##0.00"/>
                        </div>

                        <div class="checkbox-wrapper">
                            <div class="checkbox-content">
                                <input type="checkbox"
                                       id="usaSaldo"
                                       name="usaSaldo"
                                       value="true">
                                <label for="usaSaldo" class="checkbox-label" style="cursor: pointer; margin: 0;">
                                    <strong>Usa il mio saldo</strong>
                                    <small>Se il saldo non è sufficiente, la differenza verrà pagata con carta</small>
                                </label>
                            </div>
                        </div>

                        <!-- Anteprima Pagamento -->
                        <div id="paymentPreview" class="payment-preview" style="display: none;">
                            <!-- Popolato via JavaScript -->
                        </div>

                        <!-- Alert Info - Separato -->
                        <c:if test="${saldoDisponibile < prezzoTotale}">
                            <div class="alert-info" id="alertInfo" style="display: none;">
                                <div>
                                    Informazione: Il tuo saldo non è sufficiente per coprire l'intero importo.
                                    Verrà utilizzato tutto il saldo disponibile e la differenza sarà addebitata sulla carta.
                                </div>

                        </c:if>
                    </div>

                    <!-- FORM DATI CARTA (Mostra quando necessario) -->
                    <div class="card-form-section" id="cardFormSection" style="display: none;">
                        <h4>Dati Carta di Credito/Debito</h4>

                        <div class="form-group">
                            <label for="cardNumber">Numero Carta <span class="required">*</span></label>
                            <div class="input-with-icon">
                                <input type="text"
                                       id="cardNumber"
                                       name="cardNumber"
                                       placeholder="1234 5678 9012 3456"
                                       maxlength="19">
                                <span class="card-icon">●●●●</span>
                            </div>
                            <span class="error-message">Inserisci un numero di carta valido</span>
                        </div>

                        <div class="form-group">
                            <label for="cardHolder">Intestatario Carta <span class="required">*</span></label>
                            <input type="text"
                                   id="cardHolder"
                                   name="cardHolder"
                                   placeholder="NOME COGNOME">
                            <span class="error-message">Inserisci il nome dell'intestatario</span>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="expiryDate">Scadenza <span class="required">*</span></label>
                                <input type="text"
                                       id="expiryDate"
                                       name="expiryDate"
                                       placeholder="MM/AA"
                                       maxlength="5">
                                <span class="error-message">Formato: MM/AA</span>
                            </div>

                            <div class="form-group">
                                <label for="cvv">CVV <span class="required">*</span></label>
                                <input type="text"
                                       id="cvv"
                                       name="cvv"
                                       placeholder="123"
                                       maxlength="3">
                                <span class="error-message">3 cifre</span>
                            </div>
                        </div>
                    </div>

                    <!-- Bottoni -->
                    <div class="button-group">
                        <a href="${pageContext.request.contextPath}/dettaglio-film?idFilm=${programmazione.film.idFilm}" class="btn btn-secondary">
                            Annulla
                        </a>

                        <button type="submit" class="btn btn-primary" id="submitBtn">
                            Conferma Acquisto
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script>
    // ========== VARIABILI GLOBALI ==========
    var prezzoTotale = ${prezzoTotale};
    var saldoDisponibile = ${saldoDisponibile};

    console.log("Prezzi caricati - Totale:", prezzoTotale, "Saldo:", saldoDisponibile);

    // ========== GESTIONE FORM CARTA ==========
    function toggleCardForm() {
        var usaSaldo = document.getElementById('usaSaldo').checked;
        var cardFormSection = document.getElementById('cardFormSection');
        var alertInfo = document.getElementById('alertInfo');

        var needsCard = !usaSaldo || (usaSaldo && saldoDisponibile < prezzoTotale);

        console.log('Toggle Card Form - usaSaldo:', usaSaldo, 'needsCard:', needsCard);

        if (needsCard) {
            cardFormSection.style.display = 'block';
            document.getElementById('cardNumber').required = true;
            document.getElementById('cardHolder').required = true;
            document.getElementById('expiryDate').required = true;
            document.getElementById('cvv').required = true;

            // Mostra alert info solo se usa saldo ma non è sufficiente
            if (alertInfo && usaSaldo && saldoDisponibile < prezzoTotale) {
                alertInfo.style.display = 'flex';
            } else if (alertInfo) {
                alertInfo.style.display = 'none';
            }
        } else {
            cardFormSection.style.display = 'none';
            if (alertInfo) {
                alertInfo.style.display = 'none';
            }
            document.getElementById('cardNumber').required = false;
            document.getElementById('cardHolder').required = false;
            document.getElementById('expiryDate').required = false;
            document.getElementById('cvv').required = false;
            var inputs = cardFormSection.querySelectorAll('input');
            for (var i = 0; i < inputs.length; i++) {
                inputs[i].classList.remove('error');
            }
        }
    }

    // ========== CALCOLA ANTEPRIMA PAGAMENTO ==========
    function calcolaAnteprima() {
        var usaSaldo = document.getElementById('usaSaldo').checked;
        var preview = document.getElementById('paymentPreview');

        console.log('Calcola Anteprima - usaSaldo:', usaSaldo);

        toggleCardForm();

        if (!usaSaldo) {
            preview.innerHTML = '<h4>Riepilogo Pagamento</h4>' +
                '<p><strong>Pagamento con Carta:</strong> €' + prezzoTotale.toFixed(2) + '</p>';
            preview.className = 'payment-preview';
            preview.style.display = 'block';
        } else if (saldoDisponibile >= prezzoTotale) {
            preview.innerHTML = '<h4>Riepilogo Pagamento</h4>' +
                '<p><strong>Pagamento con Saldo:</strong> €' + prezzoTotale.toFixed(2) + '</p>' +
                '<p style="color: #2e7d32; font-weight: 600;">Il tuo saldo è sufficiente!</p>';
            preview.className = 'payment-preview preview-success';
            preview.style.display = 'block';
        } else {
            var differenza = prezzoTotale - saldoDisponibile;
            preview.innerHTML = '<h4>Riepilogo Pagamento Misto</h4>' +
                '<p style="color: #3e2723;"><strong style="color: #3e2723;">Saldo utilizzato:</strong> €' + saldoDisponibile.toFixed(2) + '</p>' +
                '<p style="color: #3e2723;"><strong style="color: #3e2723;">Resto con Carta:</strong> €' + differenza.toFixed(2) + '</p>';
            preview.className = 'payment-preview preview-warning';
            preview.style.display = 'block';
        }
    }

    // ========== FORMATTAZIONE AUTOMATICA CAMPI CARTA ==========
    function formatCardNumber(input) {
        var value = input.value.replace(/\s/g, '');
        value = value.replace(/[^0-9]/g, '');

        var formatted = '';
        for (var i = 0; i < value.length; i++) {
            if (i > 0 && i % 4 === 0) {
                formatted += ' ';
            }
            formatted += value[i];
        }

        input.value = formatted;
    }

    function formatExpiryDate(input) {
        var value = input.value.replace(/\D/g, '');

        if (value.length >= 2) {
            value = value.substring(0, 2) + '/' + value.substring(2, 4);
        }

        input.value = value;
    }

    // ========== VALIDAZIONE FORM ==========
    function validateForm(event) {
        var cardFormSection = document.getElementById('cardFormSection');

        if (cardFormSection.style.display === 'none') {
            return true;
        }

        var isValid = true;

        var cardNumber = document.getElementById('cardNumber');
        var cardValue = cardNumber.value.replace(/\s/g, '');
        if (cardValue.length < 13 || cardValue.length > 19 || !/^\d+$/.test(cardValue)) {
            cardNumber.classList.add('error');
            isValid = false;
        } else {
            cardNumber.classList.remove('error');
        }

        var cardHolder = document.getElementById('cardHolder');
        if (cardHolder.value.trim().length < 3) {
            cardHolder.classList.add('error');
            isValid = false;
        } else {
            cardHolder.classList.remove('error');
        }

        var expiryDate = document.getElementById('expiryDate');
        var expiryRegex = /^(0[1-9]|1[0-2])\/\d{2}$/;
        if (!expiryRegex.test(expiryDate.value)) {
            expiryDate.classList.add('error');
            isValid = false;
        } else {
            var parts = expiryDate.value.split('/');
            var month = parseInt(parts[0]);
            var year = parseInt(parts[1]);
            var expiry = new Date(2000 + year, month - 1);
            var now = new Date();

            if (expiry < now) {
                expiryDate.classList.add('error');
                alert('La carta è scaduta');
                isValid = false;
            } else {
                expiryDate.classList.remove('error');
            }
        }

        var cvv = document.getElementById('cvv');
        if (!/^\d{3}$/.test(cvv.value)) {
            cvv.classList.add('error');
            isValid = false;
        } else {
            cvv.classList.remove('error');
        }

        if (!isValid) {
            alert('Compila correttamente tutti i campi della carta');
            event.preventDefault();
            return false;
        }

        return true;
    }

    // ========== EVENT LISTENERS ==========
    document.addEventListener('DOMContentLoaded', function() {
        console.log('DOM Caricato - Inizializzo...');

        var usaSaldoCheckbox = document.getElementById('usaSaldo');
        if (usaSaldoCheckbox) {
            usaSaldoCheckbox.addEventListener('change', calcolaAnteprima);
        }

        var checkoutForm = document.getElementById('checkoutForm');
        if (checkoutForm) {
            checkoutForm.addEventListener('submit', validateForm);
        }

        var cardNumber = document.getElementById('cardNumber');
        if (cardNumber) {
            cardNumber.addEventListener('input', function() {
                formatCardNumber(this);
            });
        }

        var cardHolder = document.getElementById('cardHolder');
        if (cardHolder) {
            cardHolder.addEventListener('input', function() {
                this.value = this.value.toUpperCase();
            });
        }

        var expiryDate = document.getElementById('expiryDate');
        if (expiryDate) {
            expiryDate.addEventListener('input', function() {
                formatExpiryDate(this);
            });
        }

        var cvv = document.getElementById('cvv');
        if (cvv) {
            cvv.addEventListener('input', function() {
                this.value = this.value.replace(/[^0-9]/g, '');
            });
        }

        calcolaAnteprima();

        console.log('Inizializzazione completata');
    });
</script>

<!-- Timer JavaScript -->
<c:if test="${not empty scadenzaCheckout}">
    <script>
        console.log("=== TIMER START ===");

        var scadenzaStr = "${scadenzaCheckout}";
        console.log("Scadenza:", scadenzaStr);

        var timerScaduto = false;
        var timerId = null;

        if (scadenzaStr && scadenzaStr.trim() !== "") {
            var scadenza = new Date(scadenzaStr);
            console.log("Scadenza Date:", scadenza);

            function aggiornaTimer() {
                var ora = new Date();
                var diff = scadenza - ora;

                if (diff <= 0 && !timerScaduto) {
                    timerScaduto = true;
                    clearInterval(timerId);

                    console.log("TEMPO SCADUTO!");

                    var countdownElement = document.getElementById('countdown');
                    if (countdownElement) {
                        countdownElement.textContent = "SCADUTO";
                        countdownElement.style.color = '#d32f2f';
                    }

                    var timerBox = document.getElementById('timerBox');
                    if (timerBox) {
                        timerBox.classList.add('timer-expired');
                    }

                    setTimeout(function() {
                        alert("Il tempo per completare l'acquisto è scaduto. I posti sono stati liberati.");
                        window.location.href = "${pageContext.request.contextPath}/programmazioni";
                    }, 1000);

                    return;
                }

                var minuti = Math.floor(diff / 1000 / 60);
                var secondi = Math.floor((diff / 1000) % 60);

                var countdownElement = document.getElementById('countdown');
                if (countdownElement) {
                    countdownElement.textContent = minuti + ':' + (secondi < 10 ? '0' : '') + secondi;

                    if (minuti < 1) {
                        countdownElement.style.color = '#d32f2f';

                        var timerBox = document.getElementById('timerBox');
                        if (timerBox) {
                            timerBox.classList.add('timer-warning');
                        }
                    }
                }
            }

            console.log("Avvio timer...");
            timerId = setInterval(aggiornaTimer, 1000);
            aggiornaTimer();

            console.log("=== TIMER INIZIALIZZATO ===");
        }
    </script>
</c:if>

</body>
</html>