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
            font-style: italic;
            margin-bottom: 10px;
            letter-spacing: 2px;
        }

        .hero p {
            font-size: 1.1em;
            opacity: 0.95;
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
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        /* Messaggi */
        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Form Sections */
        .form-section {
            margin-bottom: 35px;
            padding-bottom: 25px;
            border-bottom: 2px solid #e9ecef;
        }

        .form-section:last-of-type {
            border-bottom: none;
        }

        .form-section h3 {
            font-size: 1.4em;
            color: var(--dark);
            margin-bottom: 20px;
            font-weight: 600;
        }

        /* Form Groups */
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
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
            margin-bottom: 8px;
            font-size: 0.95em;
        }

        .form-label span {
            color: #dc3545;
        }

        .form-input,
        .form-select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid var(--border);
            border-radius: 8px;
            font-size: 1em;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .form-input:focus,
        .form-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(109, 93, 110, 0.1);
        }

        .form-help {
            font-size: 0.85em;
            color: #666;
            margin-top: 5px;
            display: block;
        }

        /* Form Actions */
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 30px;
            border-top: 2px solid var(--border);
        }

        .btn {
            padding: 12px 30px;
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

        .btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: white;
            flex: 1;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(109, 93, 110, 0.3);
        }

        .btn-secondary {
            background: white;
            color: var(--dark);
            border: 2px solid var(--border);
        }

        .btn-secondary:hover {
            border-color: var(--primary);
            background: var(--light-gray);
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
    <h1>Nuova Programmazione</h1>
    <p>Film: <strong>${film.titolo}</strong> (${film.durata} min)</p>
</section>

<!-- Main Content -->
<main>
    <div class="form-container">

        <!-- Messaggi di Errore -->
        <c:if test="${not empty messaggioErrore}">
            <div class="alert alert-danger">
                <span>${messaggioErrore}</span>
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
                                <option value="">Seleziona una sala...</option>
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
                            <option value="">Prima seleziona sala e data...</option>
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
                                Prezzo Base (€) <span>*</span>
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
                                <option value="STANDARD">STANDARD</option>
                                <option value="3D">3D</option>
                                <option value="IMAX">IMAX</option>
                                <option value="DOLBY_ATMOS">DOLBY ATMOS</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="idTariffa">
                            Tariffa Speciale (opzionale)
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
    // Validazione form
    function validaFormCreazione() {
        const prezzoBase = parseFloat(document.getElementById('prezzoBase').value);

        if (prezzoBase <= 0) {
            alert('Il prezzo base deve essere maggiore di zero!');
            return false;
        }

        const data = new Date(document.getElementById('data').value);
        const oggi = new Date();
        oggi.setHours(0, 0, 0, 0);

        if (data < oggi) {
            alert('Non è possibile creare programmazioni nel passato!');
            return false;
        }

        const idSlot = document.getElementById('idSlotOrario').value;
        if (!idSlot) {
            alert('Seleziona uno slot orario valido!');
            return false;
        }

        return true;
    }

    // Caricamento dinamico slot disponibili
    function caricaSlotDisponibili() {
        const idSala = document.getElementById('idSala').value;
        const data = document.getElementById('data').value;
        const selectSlot = document.getElementById('idSlotOrario');
        const slotInfo = document.getElementById('slotInfo');

        if (!idSala || !data) {
            selectSlot.innerHTML = '<option value="">Prima seleziona sala e data...</option>';
            slotInfo.innerHTML = 'Gli slot disponibili verranno caricati automaticamente';
            return;
        }

        // Disabilita select durante caricamento
        selectSlot.disabled = true;
        selectSlot.innerHTML = '<option value="">Caricamento slot...</option>';
        slotInfo.innerHTML = '<em>Caricamento in corso...</em>';

        // AJAX per caricare slot disponibili
        fetch('${pageContext.request.contextPath}/admin/programmazione?action=slotDisponibili&idSala=' + idSala + '&data=' + data)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Errore nel caricamento degli slot');
                }
                return response.json();
            })
            .then(data => {
                selectSlot.innerHTML = '';

                if (data.slots && data.slots.length > 0) {
                    selectSlot.innerHTML = '<option value="">Seleziona uno slot...</option>';
                    data.slots.forEach(slot => {
                        const option = document.createElement('option');
                        option.value = slot.idSlotOrario;
                        option.textContent = slot.oraInizio + ' - ' + slot.oraFine;
                        if (slot.stato === 'OCCUPATO') {
                            option.disabled = true;
                            option.textContent += ' (Occupato)';
                        }
                        selectSlot.appendChild(option);
                    });
                    slotInfo.innerHTML = '<em style="color: green;">' + data.slots.length + ' slot trovati</em>';
                } else {
                    selectSlot.innerHTML = '<option value="">Nessuno slot disponibile</option>';
                    slotInfo.innerHTML = '<em style="color: orange;">Nessuno slot disponibile per questa combinazione</em>';
                }

                selectSlot.disabled = false;
            })
            .catch(error => {
                console.error('Errore:', error);
                selectSlot.innerHTML = '<option value="">Errore nel caricamento</option>';
                slotInfo.innerHTML = '<em style="color: red;">Errore nel caricamento degli slot. Riprova.</em>';
                selectSlot.disabled = false;
            });
    }
</script>

</body>
</html>