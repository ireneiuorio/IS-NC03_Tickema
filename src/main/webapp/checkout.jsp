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
            box-shadow: 0 10px 40px var(--shadow);
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
            font-weight: 300;
            margin-bottom: 10px;
            letter-spacing: 2px;
        }

        .checkout-header p {
            font-size: 1.1em;
            opacity: 0.9;
        }

        .checkout-content {
            padding: 40px 30px;
        }

        /* Film Info Section */
        .film-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            border-left: 5px solid var(--primary);
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 30px;
        }

        .film-section h2 {
            color: var(--dark);
            font-size: 1.8em;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .film-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px;
            background: var(--white);
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .detail-icon {
            font-size: 1.5em;
        }

        .detail-content {
            flex: 1;
        }

        .detail-label {
            font-size: 0.85em;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .detail-value {
            font-size: 1.1em;
            color: var(--dark);
            font-weight: 600;
        }

        /* Form Section */
        .form-section {
            background: var(--white);
            border: 2px solid var(--border);
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
            margin-bottom: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .input-group {
            margin-bottom: 25px;
        }

        .input-group label {
            display: block;
            margin-bottom: 10px;
            color: var(--dark);
            font-weight: 600;
            font-size: 1.05em;
        }

        .input-group input[type="number"] {
            width: 100%;
            padding: 15px;
            border: 2px solid var(--border);
            border-radius: 10px;
            font-size: 1.1em;
            transition: all 0.3s ease;
            font-family: 'Inter', sans-serif;
        }

        .input-group input[type="number"]:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(109, 93, 110, 0.1);
        }

        .update-button {
            background: var(--primary);
            color: var(--white);
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .update-button:hover {
            background: var(--dark);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(79, 69, 87, 0.3);
        }

        /* Price Summary */
        .price-summary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: var(--white);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            font-size: 1.15em;
        }

        .price-divider {
            border-top: 2px solid rgba(255,255,255,0.2);
            margin: 15px 0;
        }

        .price-total {
            font-size: 2em;
            font-weight: 700;
            padding-top: 15px;
        }

        /* Checkbox Section */
        .checkbox-wrapper {
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            border: 2px solid var(--border);
            border-radius: 12px;
            padding: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }

        .checkbox-wrapper:hover {
            border-color: var(--primary);
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
        }

        .checkbox-wrapper input[type="checkbox"] {
            width: 24px;
            height: 24px;
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
            font-size: 1.2em;
            color: var(--dark);
        }

        .checkbox-label small {
            display: block;
            color: #666;
            margin-top: 5px;
        }

        .saldo-badge {
            background: var(--primary);
            color: var(--white);
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 600;
            display: inline-block;
            margin-bottom: 15px;
        }

        /* Payment Preview */
        .payment-preview {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            border-left: 4px solid #2196F3;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
        }

        .payment-preview h4 {
            color: #1976d2;
            margin-bottom: 15px;
            font-size: 1.2em;
        }

        .payment-preview p {
            margin: 10px 0;
            color: #333;
            font-size: 1.05em;
        }

        .payment-preview strong {
            color: #1565c0;
        }

        .preview-success {
            background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
            border-left-color: #4caf50;
        }

        .preview-success h4 {
            color: #2e7d32;
        }

        .preview-warning {
            background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
            border-left-color: #ff9800;
        }

        .preview-warning h4 {
            color: #e65100;
        }

        /* Alert */
        .alert {
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .alert-warning {
            background: linear-gradient(135deg, #fff3cd 0%, #ffe69c 100%);
            border-left: 5px solid #ffc107;
            color: #856404;
        }

        .alert-icon {
            font-size: 2em;
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

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(109, 93, 110, 0.4);
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
        }
    </style>
</head>
<body>
<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Main Content -->
<main>
    <div class="checkout-container">
        <div class="checkout-card">
            <!-- Header -->
            <div class="checkout-header">
                <h1>🎬 Checkout</h1>
                <p>Completa il tuo acquisto in pochi semplici passi</p>
            </div>

            <div class="checkout-content">
                <!-- Film Info -->
                <div class="film-section">
                    <h2>${programmazione.film.titolo}</h2>
                    <div class="film-details">
                        <div class="detail-item">
                            <span class="detail-icon"></span>
                            <div class="detail-content">
                                <div class="detail-label">Data</div>
                                <div class="detail-value">
                                    <fmt:formatDate value="${programmazione.dataProgrammazione}" pattern="dd/MM/yyyy" />
                                </div>
                            </div>
                        </div>
                        <div class="detail-item">
                            <span class="detail-icon"></span>
                            <div class="detail-content">
                                <div class="detail-label">Orario</div>
                                <div class="detail-value">${programmazione.orarioInizio}</div>
                            </div>
                        </div>
                        <div class="detail-item">
                            <span class="detail-icon"></span>
                            <div class="detail-content">
                                <div class="detail-label">Sala</div>
                                <div class="detail-value">${programmazione.sala.nome}</div>
                            </div>
                        </div>
                        <div class="detail-item">
                            <span class="detail-icon"></span>
                            <div class="detail-content">
                                <div class="detail-label">Durata</div>
                                <div class="detail-value">${programmazione.film.durata} min</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Form -->
                <form id="checkoutForm" method="POST" action="${pageContext.request.contextPath}/acquisto">
                    <input type="hidden" name="idProgrammazione" value="${programmazione.idProgrammazione}">

                    <!-- Numero Biglietti -->
                    <div class="form-section">
                        <h3>Numero Biglietti</h3>
                        <div class="input-group">
                            <label for="numeroBiglietti">Quanti biglietti vuoi acquistare?</label>
                            <input type="number"
                                   id="numeroBiglietti"
                                   name="numeroBiglietti"
                                   value="${numeroBiglietti}"
                                   min="1"
                                   max="10"
                                   required>
                            <button type="button" class="update-button" onclick="aggiornaPrezzo()">
                                Aggiorna Prezzo
                            </button>
                        </div>
                    </div>

                    <!-- Riepilogo Prezzi -->
                    <div class="price-summary">
                        <div class="price-row">
                            <span>Prezzo unitario</span>
                            <span>€<fmt:formatNumber value="${prezzoTotale / numeroBiglietti}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="price-row">
                            <span>Numero biglietti</span>
                            <span id="displayNumBiglietti">${numeroBiglietti}</span>
                        </div>
                        <div class="price-divider"></div>
                        <div class="price-row price-total">
                            <span>TOTALE</span>
                            <span id="displayTotale">€<fmt:formatNumber value="${prezzoTotale}" pattern="#,##0.00"/></span>
                        </div>
                    </div>

                    <!-- Metodo Pagamento -->
                    <div class="form-section">
                        <h3>💳 Metodo di Pagamento</h3>

                        <div class="saldo-badge">
                            💰 Saldo disponibile: €<fmt:formatNumber value="${saldoDisponibile}" pattern="#,##0.00"/>
                        </div>

                        <div class="checkbox-wrapper" onclick="toggleSaldo()">
                            <div class="checkbox-content">
                                <input type="checkbox"
                                       id="usaSaldo"
                                       name="usaSaldo"
                                       value="true"
                                       onchange="calcolaAnteprima()">
                                <div class="checkbox-label">
                                    <strong>Usa il mio saldo</strong>
                                    <small>Se il saldo non è sufficiente, la differenza verrà pagata con carta</small>
                                </div>
                            </div>
                        </div>

                        <!-- Anteprima Pagamento -->
                        <div id="paymentPreview" class="payment-preview" style="display: none;">
                            <!-- Popolato via JavaScript -->
                        </div>

                        <c:if test="${saldoDisponibile < prezzoTotale}">
                            <div class="alert alert-warning">
                                <span class="alert-icon"></span>
                                <div>
                                    <strong>Attenzione:</strong> Il tuo saldo non è sufficiente per coprire l'intero importo.
                                    Se scegli di usare il saldo, la differenza verrà pagata con carta.
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Bottoni -->
                    <div class="button-group">
                        <a href="${pageContext.request.contextPath}/programmazioni" class="btn btn-secondary">
                            ← Annulla
                        </a>
                        <button type="submit" class="btn btn-primary">
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
    // Dati passati dal server
    const saldoDisponibile = ${saldoDisponibile};
    const prezzoUnitario = ${prezzoTotale / numeroBiglietti};
    const idProgrammazione = ${programmazione.idProgrammazione};

    // Toggle checkbox saldo
    function toggleSaldo() {
        const checkbox = document.getElementById('usaSaldo');
        checkbox.checked = !checkbox.checked;
        calcolaAnteprima();
    }

    // Calcola anteprima pagamento
    function calcolaAnteprima() {
        const usaSaldo = document.getElementById('usaSaldo').checked;
        const preview = document.getElementById('paymentPreview');
        const numBiglietti = parseInt(document.getElementById('numeroBiglietti').value);
        const totale = prezzoUnitario * numBiglietti;

        if (usaSaldo) {
            preview.style.display = 'block';

            if (saldoDisponibile >= totale) {
                // Saldo sufficiente
                preview.className = 'payment-preview preview-success';
                preview.innerHTML = `
                        <h4> Pagamento con Saldo</h4>
                        <p><strong>Saldo utilizzato:</strong> €${totale.toFixed(2)}</p>
                        <p><strong>Carta:</strong> €0.00</p>
                        <p style="color: #2e7d32; font-weight: 600; margin-top: 10px;">
                            Il pagamento verrà effettuato interamente con il saldo
                        </p>
                    `;
            } else if (saldoDisponibile > 0) {
                // Saldo insufficiente - pagamento misto
                preview.className = 'payment-preview preview-warning';
                const differenza = totale - saldoDisponibile;
                preview.innerHTML = `
                        <h4>⚠Pagamento Misto</h4>
                        <p><strong>Saldo utilizzato:</strong> €${saldoDisponibile.toFixed(2)}</p>
                        <p><strong>Carta (differenza):</strong> €${differenza.toFixed(2)}</p>
                        <p style="color: #e65100; font-weight: 600; margin-top: 10px;">
                            Utilizzerai tutto il tuo saldo + integrazione con carta
                        </p>
                    `;
            } else {
                // Saldo zero
                preview.className = 'payment-preview';
                preview.innerHTML = `
                        <h4>💳 Pagamento con Carta</h4>
                        <p><strong>Saldo:</strong> €0.00</p>
                        <p><strong>Carta:</strong> €${totale.toFixed(2)}</p>
                    `;
            }
        } else {
            preview.style.display = 'none';
        }
    }

    // Aggiorna prezzo quando cambia numero biglietti
    function aggiornaPrezzo() {
        const numBiglietti = document.getElementById('numeroBiglietti').value;

        // Redirect alla stessa pagina con nuovo numero
        window.location.href = `${pageContext.request.contextPath}/acquisto?idProgrammazione=${idProgrammazione}&numeroBiglietti=` + numBiglietti;
    }

    // Aggiorna display in tempo reale (senza refresh)
    document.getElementById('numeroBiglietti').addEventListener('input', function() {
        const numBiglietti = parseInt(this.value) || 1;
        const totale = prezzoUnitario * numBiglietti;

        document.getElementById('displayNumBiglietti').textContent = numBiglietti;
        document.getElementById('displayTotale').textContent = '€' + totale.toFixed(2);

        calcolaAnteprima();
    });

    // Calcola anteprima al caricamento
    window.onload = function() {
        calcolaAnteprima();
    };
</script>
</body>
</html>
