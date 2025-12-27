<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Modifica Programmazione #${programmazione.idProgrammazione}</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-style.css">
</head>
<body>

<div class="admin-container">
  <div class="admin-card">

    <div class="admin-header">
      <h1>Modifica Programmazione</h1>
      <p>ID: #${programmazione.idProgrammazione} - ${programmazione.film.titolo}</p>
    </div>

    <div class="admin-content">

      <!-- MESSAGGI -->
      <c:if test="${not empty messaggioErrore}">
        <div class="alert alert-danger">
          <span class="alert-icon">✕</span>
          <span>${messaggioErrore}</span>
        </div>
      </c:if>

      <div class="alert alert-warning mb-30">
        <div>
          <strong>Attenzione</strong>
          <p>Modificando slot o sala, il vecchio slot verrà liberato e il nuovo occupato automaticamente.</p>
        </div>
      </div>

      <form method="POST" action="${pageContext.request.contextPath}/admin/programmazione"
            id="formModifica" onsubmit="return validaFormModifica()">

        <input type="hidden" name="action" value="modifica">
        <input type="hidden" name="idProgrammazione" value="${programmazione.idProgrammazione}">
        <input type="hidden" name="idFilm" value="${programmazione.idFilm}">

        <!-- SEZIONE DATA E ORA -->
        <div class="form-section">
          <h3>Data e Orario</h3>

          <div class="form-row">
            <div class="input-group">
              <label for="data">Data Programmazione *</label>
              <input type="date" id="data" name="data"
                     value="<fmt:formatDate value='${programmazione.dataProgrammazione}' pattern='yyyy-MM-dd' type='date'/>"
                     required>
            </div>

            <div class="input-group">
              <label for="oraInizio">Ora Inizio *</label>
              <input type="time" id="oraInizio" name="oraInizio"
                     value="<fmt:formatDate value='${programmazione.slotOrari.oraInizio}' pattern='HH:mm' type='time'/>"
                     required>
            </div>
          </div>
        </div>

        <!-- SEZIONE SALA E SLOT -->
        <div class="form-section">
          <h3>Sala e Slot Orario</h3>

          <div class="form-row">
            <div class="input-group">
              <label for="idSala">Sala *</label>
              <select id="idSala" name="idSala" required>
                <c:forEach var="sala" items="${sale}">
                  <option value="${sala.idSala}"
                    ${sala.idSala == programmazione.idSala ? 'selected' : ''}>
                    Sala ${sala.nome} - ${sala.capienza} posti
                  </option>
                </c:forEach>
              </select>
            </div>

            <div class="input-group">
              <label for="idSlotOrario">Slot Orario *</label>
              <select id="idSlotOrario" name="idSlotOrario" required>
                <option value="${programmazione.idSlotOrario}">
                  Slot Corrente:
                  <fmt:formatDate value="${programmazione.slotOrari.oraInizio}" pattern="HH:mm" type="time"/> -
                  <fmt:formatDate value="${programmazione.slotOrari.oraFine}" pattern="HH:mm" type="time"/>
                </option>
                <c:forEach var="slot" items="${slotDisponibili}">
                  <option value="${slot.idSlotOrario}">
                    <fmt:formatDate value="${slot.oraInizio}" pattern="HH:mm" type="time"/> -
                    <fmt:formatDate value="${slot.oraFine}" pattern="HH:mm" type="time"/>
                    (${slot.stato})
                  </option>
                </c:forEach>
              </select>
              <small>Slot attualmente selezionato + altri disponibili</small>
            </div>
          </div>
        </div>

        <!-- SEZIONE PREZZI E STATO -->
        <div class="form-section">
          <h3>💰 Prezzi, Tipo e Stato</h3>

          <div class="form-row">
            <div class="input-group">
              <label for="prezzoBase">Prezzo Base (€) *</label>
              <input type="number" id="prezzoBase" name="prezzoBase"
                     step="0.01" min="0.01"
                     value="<fmt:formatNumber value='${programmazione.prezzoBase}' pattern='#.00'/>"
                     required>
            </div>

            <div class="input-group">
              <label for="tipo">Tipo Programmazione *</label>
              <select id="tipo" name="tipo" required>
                <option value="STANDARD" ${programmazione.tipo == 'STANDARD' ? 'selected' : ''}>STANDARD</option>
                <option value="3D" ${programmazione.tipo == '3D' ? 'selected' : ''}>3D</option>
                <option value="IMAX" ${programmazione.tipo == 'IMAX' ? 'selected' : ''}>IMAX</option>
                <option value="DOLBY_ATMOS" ${programmazione.tipo == 'DOLBY_ATMOS' ? 'selected' : ''}>DOLBY ATMOS</option>
              </select>
            </div>
          </div>

          <div class="form-row">
            <div class="input-group">
              <label for="stato">Stato *</label>
              <select id="stato" name="stato" required>
                <option value="DISPONIBILE" ${programmazione.stato == 'DISPONIBILE' ? 'selected' : ''}>DISPONIBILE</option>
                <option value="ANNULLATA" ${programmazione.stato == 'ANNULLATA' ? 'selected' : ''}>ANNULLATA</option>
                <option value="IN CORSO" ${programmazione.stato == 'IN CORSO' ? 'selected' : ''}>IN CORSO</option>
                <option value="CONCLUSA" ${programmazione.stato == 'CONCLUSA' ? 'selected' : ''}>CONCLUSA</option>
              </select>
            </div>

            <div class="input-group">
              <label for="idTariffa">Tariffa Speciale (opzionale)</label>
              <select id="idTariffa" name="idTariffa">
                <option value="">Nessuna tariffa</option>
                <c:forEach var="tariffa" items="${tariffe}">
                  <option value="${tariffa.idTariffa}"
                    ${tariffa.idTariffa == programmazione.idTariffa ? 'selected' : ''}>
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
          <button type="submit" class="btn btn-success">✓ Salva Modifiche</button>
          <a href="${pageContext.request.contextPath}/admin/programmazione?action=dettaglio&id=${programmazione.idProgrammazione}"
             class="btn btn-secondary">
            ✕ Annulla
          </a>
        </div>

      </form>

    </div>
  </div>
</div>

<script>
  function validaFormModifica() {
    const prezzoBase = parseFloat(document.getElementById('prezzoBase').value);

    if (prezzoBase <= 0) {
      alert('Il prezzo base deve essere maggiore di zero!');
      return false;
    }

    // Conferma se sta cambiando slot/sala
    const salaOriginale = ${programmazione.idSala};
    const slotOriginale = ${programmazione.idSlotOrario};

    const salaNuova = parseInt(document.getElementById('idSala').value);
    const slotNuovo = parseInt(document.getElementById('idSlotOrario').value);

    if (salaNuova !== salaOriginale || slotNuovo !== slotOriginale) {
      return confirm(
              'ATTENZIONE!\n\n' +
              'Stai modificando sala o slot orario.\n\n' +
              '• Il vecchio slot verrà LIBERATO\n' +
              '• Il nuovo slot verrà OCCUPATO\n\n' +
              'Confermi la modifica?'
      );
    }

    return true;
  }
</script>

</body>
</html>