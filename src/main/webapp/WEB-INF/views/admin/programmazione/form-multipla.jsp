<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Creazione Multipla - ${film.titolo} - Tickema</title>

    <!-- CSS Base -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        /* Hero Section */
        .hero {
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: white;
            padding: 60px 30px;
            text-align: center;
            margin-bottom: 40px;
        }

        .hero h1 {
            font-size: 2.5em;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .hero p {
            font-size: 1.1em;
            opacity: 0.95;
        }

        /* Container */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 30px 80px;
        }

        /* Form Card */
        .form-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        /* Alert */
        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        /* Form Section */
        .form-section {
            margin-bottom: 35px;
            padding-bottom: 35px;
            border-bottom: 2px solid #e9ecef;
        }

        .form-section:last-of-type {
            border-bottom: none;
        }

        .form-section h3 {
            font-size: 1.3em;
            color: var(--dark);
            margin-bottom: 20px;
            font-weight: 600;
        }

        /* Form Row */
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        /* Input Group */
        .input-group {
            display: flex;
            flex-direction: column;
        }

        .input-group label {
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 8px;
            font-size: 0.95em;
        }

        .input-group input,
        .input-group select {
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1em;
            transition: all 0.3s ease;
        }

        .input-group input:focus,
        .input-group select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(109, 93, 110, 0.1);
        }

        .input-group small {
            color: #6c757d;
            font-size: 0.85em;
            margin-top: 5px;
        }

        /* Programmazione Row */
        .programmazione-row {
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 30px 20px 20px;
            margin-bottom: 20px;
            position: relative;
            transition: all 0.3s ease;
        }

        .programmazione-row:hover {
            border-color: var(--primary);
            box-shadow: 0 5px 20px rgba(109, 93, 110, 0.15);
        }

        .programmazione-numero {
            position: absolute;
            top: -12px;
            left: 15px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9em;
        }

        .btn-rimuovi-row {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            cursor: pointer;
            font-size: 1.2em;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .btn-rimuovi-row:hover {
            transform: scale(1.1);
            box-shadow: 0 3px 10px rgba(220, 53, 69, 0.4);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: #f8f9fa;
            border-radius: 12px;
            border: 2px dashed #dee2e6;
        }

        .empty-state h3 {
            font-size: 1.5em;
            color: var(--dark);
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #6c757d;
            font-size: 1em;
        }

        /* Section Header */
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        /* Button Group */
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 40px;
        }

        .btn {
            padding: 14px 30px;
            border: none;
            border-radius: 8px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20874a 100%);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }

        .btn-success:disabled {
            background: #6c757d;
            cursor: not-allowed;
            opacity: 0.6;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .btn-small {
            padding: 10px 20px;
            font-size: 0.9em;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 1.8em;
            }

            .form-card {
                padding: 25px;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .btn-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }

            .section-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .section-header .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Hero Section -->
<section class="hero">
    <h1>Creazione Multipla Programmazioni</h1>
    <p>Film: <strong>${film.titolo}</strong> (${film.durata} min)</p>
</section>

<!-- Main Content -->
<main>
    <div class="container">

        <!-- MESSAGGI -->
        <c:if test="${not empty messaggioErrore}">
            <div class="alert alert-danger">
                <span>✕ ${messaggioErrore}</span>
            </div>
        </c:if>

        <div class="alert alert-info">
            <div>
                <strong>ℹ️ Creazione in batch</strong>
                <p style="margin: 5px 0 0 0;">Aggiungi più programmazioni contemporaneamente. Ogni riga rappresenta una programmazione separata.</p>
            </div>
        </div>

        <!-- FORM -->
        <div class="form-card">
            <form method="POST" action="${pageContext.request.contextPath}/admin/programmazione"
                  id="formCreaMultipla" onsubmit="return validaFormMultipla()">

                <input type="hidden" name="action" value="creaMultipla">
                <input type="hidden" name="idFilm" value="${film.idFilm}">

                <!-- PARAMETRI COMUNI -->
                <div class="form-section">
                    <h3>⚙️ Parametri Comuni</h3>

                    <div class="form-row">
                        <div class="input-group">
                            <label for="tipo">Tipo Programmazione *</label>
                            <select id="tipo" name="tipo" required>
                                <option value="STANDARD">STANDARD</option>
                                <option value="3D">3D</option>
                                <option value="IMAX">IMAX</option>
                                <option value="DOLBY_ATMOS">DOLBY ATMOS</option>
                            </select>
                        </div>

                        <div class="input-group">
                            <label for="prezzoBase">Prezzo Base (€) *</label>
                            <input type="number" id="prezzoBase" name="prezzoBase"
                                   step="0.01" min="0.01" value="8.00" required>
                        </div>
                    </div>
                </div>

                <!-- CONTAINER PROGRAMMAZIONI DINAMICHE -->
                <div class="form-section">
                    <div class="section-header">
                        <h3>🎬 Programmazioni</h3>
                        <button type="button" onclick="aggiungiProgrammazione()" class="btn btn-success btn-small">
                            + Aggiungi Programmazione
                        </button>
                    </div>

                    <div id="containerProgrammazioni">
                        <!-- Le righe verranno aggiunte dinamicamente via JavaScript -->
                    </div>

                    <div class="empty-state" id="emptyState">
                        <h3>📋 Nessuna programmazione aggiunta</h3>
                        <p>Clicca "Aggiungi Programmazione" per iniziare</p>
                    </div>
                </div>

                <!-- PULSANTI -->
                <div class="btn-group">
                    <button type="submit" class="btn btn-success" id="btnSubmit" disabled>
                        ✓ Crea Tutte le Programmazioni
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/programmazione?action=lista&idFilm=${film.idFilm}"
                       class="btn btn-secondary">
                        ✕ Annulla
                    </a>
                </div>

            </form>
        </div>

    </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

<!-- JAVASCRIPT -->
<script>
    // Dati disponibili dal backend
    const sale = [
        <c:forEach var="sala" items="${sale}" varStatus="status">
        {
            id: ${sala.idSala},
            nome: '${sala.nome}',
            capienza: ${sala.capienza}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    const tariffe = [
        <c:forEach var="tariffa" items="${tariffe}" varStatus="status">
        {
            id: ${tariffa.idTariffa},
            nome: '${tariffa.nome}',
            sconto: <fmt:formatNumber value="${tariffa.percentualeSconto}" pattern="#,##0"/>
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    const duratFilm = ${film.durata};
    let contatoreProgrammazioni = 0;

    // Aggiungi nuova riga programmazione
    function aggiungiProgrammazione() {
        contatoreProgrammazioni++;

        const container = document.getElementById('containerProgrammazioni');
        const emptyState = document.getElementById('emptyState');

        // Nascondi empty state
        if (emptyState) {
            emptyState.style.display = 'none';
        }

        // Crea nuova riga
        const row = document.createElement('div');
        row.className = 'programmazione-row';
        row.id = 'row-' + contatoreProgrammazioni;

        row.innerHTML = `
        <div class="programmazione-numero">#${contatoreProgrammazioni}</div>
        <button type="button" class="btn-rimuovi-row" onclick="rimuoviProgrammazione(${contatoreProgrammazioni})" title="Rimuovi">
            ✕
        </button>

        <div class="row-fields">
            <div class="form-row">
                <div class="input-group">
                    <label>Data *</label>
                    <input type="date" name="date[]"
                           min="${getDataOggi()}"
                           required>
                </div>

                <div class="input-group">
                    <label>Ora Inizio *</label>
                    <input type="time" name="ore[]" required>
                </div>

                <div class="input-group">
                    <label>Sala *</label>
                    <select name="idSale[]" required>
                        <option value="">Seleziona una sala...</option>
                        ${sale.map(s => '<option value="' + s.id + '">Sala ' + s.nome + ' - ' + s.capienza + ' posti</option>').join('')}
                    </select>
                </div>

                <div class="input-group">
                    <label>Slot Orario *</label>
                    <input type="number" name="idSlot[]" placeholder="ID Slot" min="1" required>
                    <small>Inserisci ID slot manualmente</small>
                </div>

                <div class="input-group">
                    <label>Tariffa (opzionale)</label>
                    <select name="idTariffa[]">
                        <option value="">Nessuna tariffa</option>
                        ${tariffe.map(t => '<option value="' + t.id + '">' + t.nome + ' (' + t.sconto + '% sconto)</option>').join('')}
                    </select>
                </div>
            </div>
        </div>
    `;

        container.appendChild(row);

        // Abilita pulsante submit
        document.getElementById('btnSubmit').disabled = false;

        // Scroll alla nuova riga
        row.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

    // Rimuovi riga programmazione
    function rimuoviProgrammazione(id) {
        const row = document.getElementById('row-' + id);
        if (row) {
            row.style.opacity = '0';
            row.style.transform = 'translateX(-20px)';
            setTimeout(function() {
                row.remove();

                // Se non ci sono più righe, mostra empty state
                const container = document.getElementById('containerProgrammazioni');
                if (container.children.length === 0) {
                    document.getElementById('emptyState').style.display = 'block';
                    document.getElementById('btnSubmit').disabled = true;
                }
            }, 300);
        }
    }

    // Validazione form
    function validaFormMultipla() {
        const container = document.getElementById('containerProgrammazioni');
        const righe = container.getElementsByClassName('programmazione-row');

        if (righe.length === 0) {
            alert('Devi aggiungere almeno una programmazione!');
            return false;
        }

        // Valida prezzo base
        const prezzoBase = parseFloat(document.getElementById('prezzoBase').value);
        if (prezzoBase <= 0) {
            alert('Il prezzo base deve essere maggiore di zero!');
            return false;
        }

        // Valida ogni riga
        const oggi = new Date();
        oggi.setHours(0, 0, 0, 0);

        const date = document.getElementsByName('date[]');
        for (let i = 0; i < date.length; i++) {
            const data = new Date(date[i].value);
            if (data < oggi) {
                alert('La programmazione #' + (i+1) + ' ha una data nel passato!');
                return false;
            }
        }

        // Valida slot orari
        const slot = document.getElementsByName('idSlot[]');
        for (let i = 0; i < slot.length; i++) {
            const idSlot = parseInt(slot[i].value);
            if (!idSlot || idSlot <= 0) {
                alert('La programmazione #' + (i+1) + ' ha uno slot orario non valido!');
                return false;
            }
        }

        // Conferma finale
        const tipo = document.getElementById('tipo').value;
        const conferma = confirm(
            '🎬 Stai per creare ' + righe.length + ' programmazioni.\n\n' +
            'Film: ${film.titolo}\n' +
            'Tipo: ' + tipo + '\n' +
            'Prezzo: €' + prezzoBase.toFixed(2) + '\n\n' +
            'Confermi l\'operazione?'
        );

        return conferma;
    }

    // Helper: ottieni data odierna formato yyyy-MM-dd
    function getDataOggi() {
        const oggi = new Date();
        return oggi.toISOString().split('T')[0];
    }

    // Aggiungi automaticamente la prima riga all'apertura
    window.addEventListener('DOMContentLoaded', function() {
        aggiungiProgrammazione();
    });
</script>

</body>
</html>