<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nuova Programmazione - ${film.titolo}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="admin-container">
    <div class="admin-card">

        <div class="admin-header">
            <h1> Nuova Programmazione</h1>
            <p>Film: <strong>${film.titolo}</strong> (${film.durata} min)</p>
        </div>

        <div class="admin-content">

            <!-- MESSAGGI -->
            <c:if test="${not empty messaggioErrore}">
                <div class="alert alert-danger">
                    <span class="alert-icon">✕</span>
                    <span>${messaggioErrore}</span>
                </div>
            </c:if>

            <form method="POST" action="${pageContext.request.contextPath}/admin/programmazione"
                  id="formCreaProgrammazione" onsubmit="return validaFormCreazione()">

                <input type="hidden" name="action" value="crea">
                <input type="hidden" name="idFilm" value="${film.idFilm}">

                <!-- SEZIONE DATA E ORA -->
                <div class="form-section">
                    <h3>Data e Orario</h3>

                    <div class="form-row">
                        <div class="input-group">
                            <label for="data">Data Programmazione *</label>
                            <input type="date" id="data" name="data"
                                   value="<fmt:formatDate value='${dataDefault}' pattern='yyyy-MM-dd' type='date'/>"
                                   min="<fmt:formatDate value='${dataDefault}' pattern='yyyy-MM-dd' type='date'/>"
                                   required>
                            <small>Non è possibile creare programmazioni nel passato</small>
                        </div>

                        <div class="input-group">
                            <label for="oraInizio">Ora Inizio *</label>
                            <input type="time" id="oraInizio" name="oraInizio" required>
                            <small>Formato 24h (es. 14:30)</small>
                        </div>
                    </div>
                </div>

                <!-- SEZIONE SALA E SLOT -->
                <div class="form-section">
                    <h3>Sala e Slot Orario</h3>

                    <div class="form-row">
                        <div class="input-group">
                            <label for="idSala">Sala *</label>
                            <select id="idSala" name="idSala" required onchange="caricaSlotDisponibili()">
                                <option value="">Seleziona una sala...</option>
                                <c:forEach var="sala" items="${sale}">
                                    <option value="${sala.idSala}">
                                        Sala ${sala.nome} - ${sala.capienza} posti
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="input-group">
                            <label for="idSlotOrario">Slot Orario *</label>
                            <select id="idSlotOrario" name="idSlotOrario" required>
                                <option value="">Prima seleziona sala e data...</option>
                            </select>
                            <small id="slotInfo">Gli slot disponibili verranno caricati automaticamente</small>
                        </div>
                    </div>
                </div>

                <!-- SEZIONE PREZZI -->
                <div class="form-section">
                    <h3>Prezzi e Tariffe</h3>

                    <div class="form-row">
                        <div class="input-group">
                            <label for="prezzoBase">Prezzo Base (€) *</label>
                            <input type="number" id="prezzoBase" name="prezzoBase"
                                   step="0.01" min="0.01" value="8.00" required>
                            <small>Prezzo standard del biglietto</small>
                        </div>

                        <div class="input-group">
                            <label for="tipo">Tipo Programmazione *</label>
                            <select id="tipo" name="tipo" required>
                                <option value="STANDARD">STANDARD</option>
                                <option value="3D">3D</option>
                                <option value="IMAX">IMAX</option>
                                <option value="DOLBY_ATMOS">DOLBY ATMOS</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="input-group">
                            <label for="idTariffa">Tariffa Speciale (opzionale)</label>
                            <select id="idTariffa" name="idTariffa">
                                <option value="">Nessuna tariffa</option>
                                <c:forEach var="tariffa" items="${tariffe}">
                                    <option value="${tariffa.idTariffa}">
                                            ${tariffa.nome} (<fmt:formatNumber value="${tariffa.percentualeSconto}" pattern="#,##0"/>% sconto)
                                    </option>
                                </c:forEach>
                            </select>
                            <small>Applicata automaticamente a biglietti qualificati</small>
                        </div>
                    </div>
                </div>

                <!-- PULSANTI -->
                <div class="btn-group">
                    <button type="submit" class="btn btn-success">✓ Crea Programmazione</button>
                    <a href="${pageContext.request.contextPath}/admin/programmazione?action=lista&idFilm=${film.idFilm}"
                       class="btn btn-secondary">
                        ✕ Annulla
                    </a>
                </div>

            </form>

        </div>
    </div>
</div>

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
                        option.textContent = slot.oraInizio + ' - ' + slot.oraFine + ' (' + slot.stato + ')';
                        if (slot.stato === 'OCCUPATO') {
                            option.disabled = true;
                        }
                        selectSlot.appendChild(option);
                    });
                    slotInfo.innerHTML = '<em style="color: green;">✓ ' + data.slots.length + ' slot trovati</em>';
                } else {
                    selectSlot.innerHTML = '<option value="">Nessuno slot disponibile</option>';
                    slotInfo.innerHTML = '<em style="color: orange;">⚠ Nessuno slot disponibile per questa combinazione</em>';
                }

                selectSlot.disabled = false;
            })
            .catch(error => {
                console.error('Errore:', error);
                selectSlot.innerHTML = '<option value="">Errore nel caricamento</option>';
                slotInfo.innerHTML = '<em style="color: red;">✕ Errore nel caricamento degli slot. Riprova.</em>';
                selectSlot.disabled = false;
            });
    }

    // Aggiorna info slot quando cambia la data
    document.getElementById('data').addEventListener('change', caricaSlotDisponibili);
</script>

</body>
</html>