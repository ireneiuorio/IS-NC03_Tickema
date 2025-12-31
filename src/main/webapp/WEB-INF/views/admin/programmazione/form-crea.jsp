<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nuova Programmazione - ${film.titolo}</title>

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
            max-width: 900px;
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

        /* Messaggi */
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

        /* Form Groups */
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 25px;
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

        /* Form Actions */
        .form-actions {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            padding-top: 40px;
            border-top: 2px solid #f0f0f0;
        }

        .btn {
            padding: 18px 40px;
            border: none;
            border-radius: 12px;
            font-size: 1.2em;
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
            flex: 1;
            box-shadow: 0 5px 20px rgba(109, 93, 110, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(109, 93, 110, 0.4);
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

        /* Loading State */
        .loading-state {
            color: #666;
            font-style: italic;
        }

        .success-state {
            color: var(--primary);
        }

        .error-state {
            color: #f44336;
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
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Hero Section -->
<section class="hero">
    <div class="hero-content">
        <h1>Nuova Programmazione</h1>
        <p>Film: ${film.titolo}</p>
        <div class="film-badge">Durata: ${film.durata} minuti</div>
    </div>
</section>

<!-- Main Content -->
<main>
    <div class="form-container">

        <!-- Messaggi di Errore -->
        <c:if test="${not empty messaggioErrore}">
            <div class="alert alert-danger">
                    ${messaggioErrore}
            </div>
        </c:if>

        <!-- Form Card -->
        <div class="form-card">
            <form method="POST"
                  action="${pageContext.request.contextPath}/admin/programmazione"
                  id="formCreaProgrammazione"
                  onsubmit="return validaFormCreazione()">

                <input type="hidden" name="action" value="crea">
                <input type="hidden" name="idFilm" value="${film.idFilm}">

                <!-- SEZIONE DATA E SALA -->
                <div class="form-section">
                    <h3>Data e Sala</h3>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="data">
                                Data Programmazione <span>*</span>
                            </label>
                            <input type="date"
                                   id="data"
                                   name="data"
                                   class="form-input"
                                   value="${dataDefault}"
                                   min="${dataDefault}"
                                   required
                                   onchange="caricaSlotDisponibili()">
                            <small class="form-help">Non è possibile creare programmazioni nel passato</small>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="idSala">
                                Sala <span>*</span>
                            </label>
                            <select id="idSala"
                                    name="idSala"
                                    class="form-select"
                                    required
                                    onchange="caricaSlotDisponibili()">
                                <option value="">Seleziona una sala</option>
                                <c:forEach var="sala" items="${sale}">
                                    <option value="${sala.idSala}">
                                        Sala ${sala.nome} - ${sala.capienza} posti
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- SEZIONE SLOT ORARIO -->
                <div class="form-section">
                    <h3>Slot Orario</h3>

                    <div class="form-group">
                        <label class="form-label" for="idSlotOrario">
                            Fascia Oraria <span>*</span>
                        </label>
                        <select id="idSlotOrario"
                                name="idSlotOrario"
                                class="form-select"
                                required>
                            <option value="">Prima seleziona sala e data</option>
                        </select>
                        <small class="form-help" id="slotInfo">Gli slot disponibili verranno caricati automaticamente</small>
                    </div>
                </div>

                <!-- SEZIONE PREZZI -->
                <div class="form-section">
                    <h3>Prezzi e Tariffe</h3>

                    <div class="form-row">
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
                            <small class="form-help">Prezzo standard del biglietto</small>
                        </div>

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
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="idTariffa">
                            Tariffa Speciale
                        </label>
                        <select id="idTariffa" name="idTariffa" class="form-select">
                            <option value="">Nessuna tariffa</option>
                            <c:forEach var="tariffa" items="${tariffe}">
                                <option value="${tariffa.idTariffa}">
                                        ${tariffa.nome} (<fmt:formatNumber value="${tariffa.percentualeSconto}" pattern="#,##0"/>% sconto)
                                </option>
                            </c:forEach>
                        </select>
                        <small class="form-help">Applicata automaticamente a biglietti qualificati</small>
                    </div>
                </div>

                <!-- PULSANTI -->
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        Crea Programmazione
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
    function validaFormCreazione() {
        const prezzoBase = parseFloat(document.getElementById('prezzoBase').value);

        if (prezzoBase <= 0) {
            alert('Il prezzo base deve essere maggiore di zero');
            return false;
        }

        const data = new Date(document.getElementById('data').value);
        const oggi = new Date();
        oggi.setHours(0, 0, 0, 0);

        if (data < oggi) {
            alert('Non è possibile creare programmazioni nel passato');
            return false;
        }

        const idSlot = document.getElementById('idSlotOrario').value;
        if (!idSlot) {
            alert('Seleziona uno slot orario valido');
            return false;
        }

        return true;
    }

    // Carica slot disponibili per una specifica riga
    function caricaSlotPerRiga(rowId) {
        console.log('=== INIZIO caricaSlotPerRiga ===');
        console.log('rowId:', rowId);

        const dataInput = document.querySelector('#row-' + rowId + ' input[name="date[]"]');
        const salaSelect = document.querySelector('#row-' + rowId + ' select[name="idSale[]"]');
        const slotSelect = document.querySelector('#row-' + rowId + ' select[name="idSlot[]"]');
        const slotInfo = document.querySelector('#row-' + rowId + ' .slot-info');

        console.log('Elementi trovati:', {
            dataInput: dataInput,
            salaSelect: salaSelect,
            slotSelect: slotSelect,
            slotInfo: slotInfo
        });

        const dataValue = dataInput.value;
        const idSala = salaSelect.value;

        console.log('Valori:', {
            data: dataValue,
            idSala: idSala
        });

        if (!dataValue || !idSala) {
            console.log('Data o sala mancante, esco');
            slotSelect.innerHTML = '<option value="">Prima seleziona sala e data</option>';
            slotInfo.innerHTML = 'Seleziona sala e data per caricare gli slot';
            slotInfo.className = 'form-help';
            return;
        }

        const url = contextPath + '/admin/programmazione?action=slotDisponibili&idSala=' + idSala + '&data=' + dataValue;
        console.log('URL fetch:', url);
        console.log('contextPath:', contextPath);

        slotSelect.disabled = true;
        slotSelect.innerHTML = '<option value="">Caricamento slot in corso</option>';
        slotInfo.innerHTML = 'Caricamento in corso';
        slotInfo.className = 'form-help loading-state';

        console.log('Inizio fetch...');

        fetch(url)
            .then(function(response) {
                console.log('Response ricevuta:', response);
                console.log('Response status:', response.status);
                console.log('Response ok:', response.ok);

                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(function(jsonData) {
                console.log('JSON ricevuto:', jsonData);
                console.log('Slots:', jsonData.slots);
                console.log('Numero slots:', jsonData.slots ? jsonData.slots.length : 0);

                slotSelect.innerHTML = '';

                if (jsonData.slots && jsonData.slots.length > 0) {
                    console.log('Popolamento select con', jsonData.slots.length, 'slot');
                    slotSelect.innerHTML = '<option value="">Seleziona uno slot</option>';

                    for (let i = 0; i < jsonData.slots.length; i++) {
                        const slot = jsonData.slots[i];
                        console.log('Slot', i, ':', slot);

                        const option = document.createElement('option');
                        option.value = slot.idSlotOrario;
                        option.textContent = slot.oraInizio + ' - ' + slot.oraFine;

                        if (slot.stato === 'OCCUPATO') {
                            option.disabled = true;
                            option.textContent += ' (Occupato)';
                        }

                        slotSelect.appendChild(option);
                    }

                    slotInfo.innerHTML = jsonData.slots.length + ' slot disponibili';
                    slotInfo.className = 'form-help success-state';
                    console.log('Popolamento completato');

                } else {
                    console.log('Nessuno slot disponibile');
                    slotSelect.innerHTML = '<option value="">Nessuno slot disponibile</option>';
                    slotInfo.innerHTML = 'Nessuno slot disponibile per questa combinazione';
                    slotInfo.className = 'form-help error-state';
                }

                slotSelect.disabled = false;
                console.log('=== FINE caricaSlotPerRiga (SUCCESS) ===');
            })
            .catch(function(error) {
                console.error('=== ERRORE CATCH ===');
                console.error('Tipo errore:', error.name);
                console.error('Messaggio:', error.message);
                console.error('Stack:', error.stack);
                console.error('Error completo:', error);

                slotSelect.innerHTML = '<option value="">Errore nel caricamento</option>';
                slotInfo.innerHTML = 'Errore nel caricamento degli slot';
                slotInfo.className = 'form-help error-state';
                slotSelect.disabled = false;

                console.log('=== FINE caricaSlotPerRiga (ERROR) ===');
            });
    }
</script>

</body>
</html>