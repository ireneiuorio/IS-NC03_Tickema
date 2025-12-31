<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Creazione Multipla - ${film.titolo}</title>

    <!-- CSS Base -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* Hero Section */
        .hero {
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: white;
            padding: 60px 30px;
            text-align: center;
            margin-bottom: 50px;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.1)" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,112C672,96,768,96,864,112C960,128,1056,160,1152,160C1248,160,1344,128,1392,112L1440,96L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>') no-repeat bottom;
            background-size: cover;
            opacity: 0.3;
        }

        .hero-content {
            position: relative;
            z-index: 1;
        }

        .hero h1 {
            font-size: 2.8em;
            font-weight: 700;
            margin-bottom: 15px;
            letter-spacing: 1px;
        }

        .hero p {
            font-size: 1.2em;
            opacity: 0.95;
        }

        .film-badge {
            display: inline-block;
            background: rgba(255, 255, 255, 0.2);
            padding: 8px 20px;
            border-radius: 20px;
            margin-top: 10px;
            backdrop-filter: blur(10px);
        }

        /* Container */
        .form-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 30px 80px;
        }

        /* Form Card */
        .form-card {
            background: white;
            border-radius: 20px;
            padding: 50px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
        }

        /* Alert */
        .alert {
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            border-left: 4px solid var(--primary);
        }

        .alert-danger {
            background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
            border-left-color: #f44336;
            color: #c62828;
        }

        .alert-info {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-left-color: var(--primary);
            color: var(--dark);
        }

        /* Form Sections */
        .form-section {
            margin-bottom: 40px;
            padding-bottom: 30px;
            border-bottom: 2px solid #f0f0f0;
        }

        .form-section:last-of-type {
            border-bottom: none;
        }

        .form-section h3 {
            font-size: 1.5em;
            color: var(--primary);
            margin-bottom: 25px;
            font-weight: 600;
            position: relative;
            padding-left: 15px;
        }

        .form-section h3::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 4px;
            height: 30px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            border-radius: 2px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        /* Form Groups */
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 10px;
            font-size: 1em;
        }

        .form-label span {
            color: var(--primary);
        }

        .form-input,
        .form-select {
            width: 100%;
            padding: 15px;
            border: 2px solid var(--border);
            border-radius: 10px;
            font-size: 1em;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .form-input:focus,
        .form-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(109, 93, 110, 0.1);
        }

        .form-help {
            font-size: 0.9em;
            color: #666;
            margin-top: 8px;
            display: block;
            font-style: italic;
        }

        .loading-state {
            color: #666;
        }

        .success-state {
            color: var(--primary);
        }

        .error-state {
            color: #f44336;
        }

        /* Programmazione Row */
        .programmazione-row {
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            border: 2px solid var(--border);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 25px;
            position: relative;
            transition: all 0.3s ease;
        }

        .programmazione-row:hover {
            border-color: var(--primary);
            box-shadow: 0 5px 20px rgba(109, 93, 110, 0.15);
        }

        .programmazione-numero {
            position: absolute;
            top: -15px;
            left: 20px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.95em;
            box-shadow: 0 3px 10px rgba(109, 93, 110, 0.3);
        }

        .btn-rimuovi-row {
            position: absolute;
            top: 15px;
            right: 15px;
            background: white;
            color: var(--primary);
            border: 2px solid var(--primary);
            border-radius: 8px;
            padding: 8px 15px;
            cursor: pointer;
            font-size: 0.9em;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-rimuovi-row:hover {
            background: var(--primary);
            color: white;
            transform: translateY(-2px);
        }

        .row-fields {
            margin-top: 15px;
        }

        /* Container Programmazioni */
        #containerProgrammazioni {
            min-height: 100px;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 15px;
            border: 2px dashed var(--border);
        }

        .empty-state h3 {
            color: var(--dark);
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #666;
        }

        /* Buttons */
        .btn {
            padding: 15px 35px;
            border: none;
            border-radius: 10px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: white;
            box-shadow: 0 5px 20px rgba(109, 93, 110, 0.3);
        }

        .btn-primary:hover:not(:disabled) {
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(109, 93, 110, 0.4);
        }

        .btn-primary:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .btn-secondary {
            background: white;
            color: var(--primary);
            border: 2px solid var(--primary);
        }

        .btn-secondary:hover {
            background: var(--light-gray);
            transform: translateY(-2px);
        }

        .btn-small {
            padding: 10px 20px;
            font-size: 0.95em;
        }

        /* Form Actions */
        .form-actions {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            padding-top: 40px;
            border-top: 2px solid #f0f0f0;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 2em;
            }

            .form-card {
                padding: 30px;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }

            .programmazione-row {
                padding: 25px 20px;
            }

            .btn-rimuovi-row {
                position: static;
                margin-top: 15px;
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
    <div class="hero-content">
        <h1>Creazione Multipla Programmazioni</h1>
        <p>Film: ${film.titolo}</p>
        <div class="film-badge">Durata: ${film.durata} minuti</div>
    </div>
</section>

<!-- Main Content -->
<main>
    <div class="form-container">

        <!-- Messaggi -->
        <c:if test="${not empty messaggioErrore}">
            <div class="alert alert-danger">
                    ${messaggioErrore}
            </div>
        </c:if>

        <div class="alert alert-info">
            <div>
                <strong>Creazione multipla</strong>
                <p>Aggiungi più programmazioni contemporaneamente. Gli slot orari disponibili vengono caricati automaticamente in base a sala e data.</p>
            </div>
        </div>

        <!-- Form Card -->
        <div class="form-card">
            <form method="POST"
                  action="${pageContext.request.contextPath}/admin/programmazione"
                  id="formCreaMultipla"
                  onsubmit="return validaFormMultipla()">

                <input type="hidden" name="action" value="creaMultipla">
                <input type="hidden" name="idFilm" value="${film.idFilm}">

                <!-- PARAMETRI COMUNI -->
                <div class="form-section">
                    <h3>Parametri Comuni</h3>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="tipo">
                                Tipo Programmazione <span>*</span>
                            </label>
                            <select id="tipo" name="tipo" class="form-select" required>
                                <option value="STANDARD">Standard</option>
                                <option value="3D">3D</option>
                                <option value="IMAX">IMAX</option>
                                <option value="DOLBY_ATMOS">Dolby Atmos</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="prezzoBase">
                                Prezzo Base <span>*</span>
                            </label>
                            <input type="number"
                                   id="prezzoBase"
                                   name="prezzoBase"
                                   class="form-input"
                                   step="0.01"
                                   min="0.01"
                                   value="8.00"
                                   required>
                        </div>
                    </div>
                </div>

                <!-- CONTAINER PROGRAMMAZIONI DINAMICHE -->
                <div class="form-section">
                    <div class="section-header">
                        <h3>Programmazioni</h3>
                        <button type="button"
                                onclick="aggiungiProgrammazione()"
                                class="btn btn-primary btn-small">
                            Aggiungi Programmazione
                        </button>
                    </div>

                    <div id="containerProgrammazioni">
                        <!-- Le righe verranno aggiunte dinamicamente via JavaScript -->
                    </div>

                    <div class="empty-state" id="emptyState">
                        <h3>Nessuna programmazione aggiunta</h3>
                        <p>Clicca "Aggiungi Programmazione" per iniziare</p>
                    </div>
                </div>

                <!-- PULSANTI -->
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary" id="btnSubmit" disabled>
                        Crea Tutte le Programmazioni
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/programmazione?action=lista&idFilm=${film.idFilm}"
                       class="btn btn-secondary">
                        Annulla
                    </a>
                </div>

            </form>
        </div>

    </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

<!-- JavaScript -->
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

    const dataOggi = '${dataOggi}';
    const contextPath = '${pageContext.request.contextPath}';
    let contatoreProgrammazioni = 0;

    // ✅ FUNZIONE UGUALE ALLA FORM SINGOLA
    function caricaSlotDisponibili(idSala, idData, idSlot, idInfo) {
        const dataInput = document.getElementById(idData);
        const salaSelect = document.getElementById(idSala);
        const slotSelect = document.getElementById(idSlot);
        const slotInfo = document.getElementById(idInfo);

        const data = dataInput.value;
        const sala = salaSelect.value;

        if (!data || !sala) {
            slotSelect.innerHTML = '<option value="">Prima seleziona sala e data</option>';
            slotInfo.innerHTML = 'Seleziona sala e data per caricare gli slot';
            slotInfo.className = 'form-help';
            return;
        }

        const url = contextPath + '/admin/programmazione?action=slotDisponibili&idSala=' + sala + '&data=' + data;

        slotSelect.disabled = true;
        slotSelect.innerHTML = '<option value="">Caricamento slot in corso</option>';
        slotInfo.innerHTML = 'Caricamento in corso';
        slotInfo.className = 'form-help loading-state';

        fetch(url)
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('Errore nel caricamento');
                }
                return response.json();
            })
            .then(function(data) {
                slotSelect.innerHTML = '';

                if (data.slots && data.slots.length > 0) {
                    slotSelect.innerHTML = '<option value="">Seleziona uno slot</option>';
                    for (let i = 0; i < data.slots.length; i++) {
                        const slot = data.slots[i];
                        const option = document.createElement('option');
                        option.value = slot.idSlotOrario;
                        option.textContent = slot.oraInizio + ' - ' + slot.oraFine;
                        if (slot.stato === 'OCCUPATO') {
                            option.disabled = true;
                            option.textContent += ' (Occupato)';
                        }
                        slotSelect.appendChild(option);
                    }
                    slotInfo.innerHTML = data.slots.length + ' slot disponibili';
                    slotInfo.className = 'form-help success-state';
                } else {
                    slotSelect.innerHTML = '<option value="">Nessuno slot disponibile</option>';
                    slotInfo.innerHTML = 'Nessuno slot disponibile';
                    slotInfo.className = 'form-help error-state';
                }

                slotSelect.disabled = false;
            })
            .catch(function(error) {
                console.error('Errore:', error);
                slotSelect.innerHTML = '<option value="">Errore nel caricamento</option>';
                slotInfo.innerHTML = 'Errore nel caricamento degli slot';
                slotInfo.className = 'form-help error-state';
                slotSelect.disabled = false;
            });
    }

    // Helper functions
    function generaOptionsSale() {
        let html = '';
        for (let i = 0; i < sale.length; i++) {
            html += '<option value="' + sale[i].id + '">Sala ' + sale[i].nome + ' (' + sale[i].capienza + ' posti)</option>';
        }
        return html;
    }

    function generaOptionsTariffe() {
        let html = '';
        for (let i = 0; i < tariffe.length; i++) {
            html += '<option value="' + tariffe[i].id + '">' + tariffe[i].nome + ' (' + tariffe[i].sconto + '% sconto)</option>';
        }
        return html;
    }

    // Aggiungi nuova riga programmazione
    function aggiungiProgrammazione() {
        contatoreProgrammazioni++;
        const rowId = contatoreProgrammazioni;

        const container = document.getElementById('containerProgrammazioni');
        const emptyState = document.getElementById('emptyState');

        if (emptyState) {
            emptyState.style.display = 'none';
        }

        const row = document.createElement('div');
        row.className = 'programmazione-row';
        row.id = 'row-' + rowId;

        // ✅ ID UNIVOCI PER OGNI ELEMENTO
        const idData = 'data-' + rowId;
        const idSala = 'sala-' + rowId;
        const idSlot = 'slot-' + rowId;
        const idInfo = 'info-' + rowId;

        row.innerHTML = '<div class="programmazione-numero">Programmazione ' + rowId + '</div>' +
            '<button type="button" class="btn-rimuovi-row" onclick="rimuoviProgrammazione(' + rowId + ')">' +
            'Rimuovi' +
            '</button>' +
            '<div class="row-fields">' +
            '<div class="form-row">' +
            '<div class="form-group">' +
            '<label class="form-label">Data <span>*</span></label>' +
            '<input type="date" name="date[]" id="' + idData + '" class="form-input" min="' + dataOggi + '" required ' +
            'onchange="caricaSlotDisponibili(\'' + idSala + '\', \'' + idData + '\', \'' + idSlot + '\', \'' + idInfo + '\')">' +
            '</div>' +
            '<div class="form-group">' +
            '<label class="form-label">Sala <span>*</span></label>' +
            '<select name="idSale[]" id="' + idSala + '" class="form-select" required ' +
            'onchange="caricaSlotDisponibili(\'' + idSala + '\', \'' + idData + '\', \'' + idSlot + '\', \'' + idInfo + '\')">' +
            '<option value="">Seleziona sala</option>' +
            generaOptionsSale() +
            '</select>' +
            '</div>' +
            '<div class="form-group">' +
            '<label class="form-label">Slot Orario <span>*</span></label>' +
            '<select name="idSlot[]" id="' + idSlot + '" class="form-select" required>' +
            '<option value="">Prima seleziona sala e data</option>' +
            '</select>' +
            '<small class="form-help" id="' + idInfo + '">Seleziona sala e data per caricare gli slot</small>' +
            '</div>' +
            '<div class="form-group">' +
            '<label class="form-label">Tariffa Speciale</label>' +
            '<select name="idTariffa[]" class="form-select">' +
            '<option value="">Nessuna tariffa</option>' +
            generaOptionsTariffe() +
            '</select>' +
            '</div>' +
            '</div>' +
            '</div>';

        container.appendChild(row);
        document.getElementById('btnSubmit').disabled = false;
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
            alert('Devi aggiungere almeno una programmazione');
            return false;
        }

        const prezzoBase = parseFloat(document.getElementById('prezzoBase').value);
        if (prezzoBase <= 0) {
            alert('Il prezzo base deve essere maggiore di zero');
            return false;
        }

        const oggi = new Date();
        oggi.setHours(0, 0, 0, 0);

        const date = document.getElementsByName('date[]');
        for (let i = 0; i < date.length; i++) {
            const data = new Date(date[i].value);
            if (data < oggi) {
                alert('La programmazione ' + (i+1) + ' ha una data nel passato');
                return false;
            }
        }

        const slot = document.getElementsByName('idSlot[]');
        for (let i = 0; i < slot.length; i++) {
            const idSlot = parseInt(slot[i].value);
            if (!idSlot || idSlot <= 0) {
                alert('La programmazione ' + (i+1) + ' non ha uno slot orario selezionato');
                return false;
            }
        }

        const tipo = document.getElementById('tipo').value;
        const conferma = confirm(
            'Stai per creare ' + righe.length + ' programmazioni.\n\n' +
            'Film: ${film.titolo}\n' +
            'Tipo: ' + tipo + '\n' +
            'Prezzo: €' + prezzoBase.toFixed(2) + '\n\n' +
            'Confermi l\'operazione?'
        );

        return conferma;
    }

    // Aggiungi automaticamente la prima riga all'apertura
    window.addEventListener('DOMContentLoaded', function() {
        aggiungiProgrammazione();
    });
</script>

</body>
</html>