<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Modifica Programmazione #${programmazione.idProgrammazione} - Tickema</title>

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
      align-items: flex-start;
      gap: 10px;
    }

    .alert-danger {
      background: #f8d7da;
      color: #721c24;
      border: 1px solid #f5c6cb;
    }

    .alert-warning {
      background: #fff3cd;
      color: #856404;
      border: 1px solid #ffeaa7;
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

    .btn-success {
      background: linear-gradient(135deg, #28a745 0%, #20874a 100%);
      color: white;
      flex: 1;
    }

    .btn-success:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
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
  <h1>Modifica Programmazione</h1>
  <p>ID: #${programmazione.idProgrammazione} - ${programmazione.film.titolo}</p>
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

    <!-- Alert Warning -->
    <div class="alert alert-warning">
      <div>
        <strong>⚠️ Attenzione</strong>
        <p style="margin: 5px 0 0 0;">Modificando slot o sala, il vecchio slot verrà liberato e il nuovo occupato automaticamente.</p>
      </div>
    </div>

    <!-- Form Card -->
    <div class="form-card">
      <form method="POST"
            action="${pageContext.request.contextPath}/admin/programmazione"
            id="formModifica"
            onsubmit="return validaFormModifica()">

        <input type="hidden" name="action" value="modifica">
        <input type="hidden" name="idProgrammazione" value="${programmazione.idProgrammazione}">
        <input type="hidden" name="idFilm" value="${programmazione.idFilm}">

        <!-- SEZIONE DATA E SALA -->
        <div class="form-section">
          <h3>📅 Data e Sala</h3>

          <div class="form-row">
            <div class="form-group">
              <label class="form-label" for="data">
                Data Programmazione <span>*</span>
              </label>
              <input type="date"
                     id="data"
                     name="data"
                     class="form-input"
                     value="${programmazione.dataProgrammazione}"
                     required
                     onchange="caricaSlotDisponibili()">
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
                <c:forEach var="sala" items="${sale}">
                  <option value="${sala.idSala}"
                    ${sala.idSala == programmazione.idSala ? 'selected' : ''}>
                    Sala ${sala.nome} - ${sala.capienza} posti
                  </option>
                </c:forEach>
              </select>
            </div>
          </div>
        </div>

        <!-- SEZIONE SLOT ORARIO -->
        <div class="form-section">
          <h3>🎬 Slot Orario</h3>

          <div class="form-group">
            <label class="form-label" for="idSlotOrario">
              Fascia Oraria <span>*</span>
            </label>
            <select id="idSlotOrario"
                    name="idSlotOrario"
                    class="form-select"
                    required>
              <option value="${programmazione.idSlotOrari}">
                Slot Corrente: ${programmazione.slotOrari.oraInizio} - ${programmazione.slotOrari.oraFine}
              </option>
              <c:forEach var="slot" items="${slotDisponibili}">
                <option value="${slot.idSlotOrario}">
                    ${slot.oraInizio} - ${slot.oraFine} (${slot.stato})
                </option>
              </c:forEach>
            </select>
            <small class="form-help">Slot attualmente selezionato + altri disponibili</small>
          </div>
        </div>

        <!-- SEZIONE PREZZI E STATO -->
        <div class="form-section">
          <h3>💰 Prezzi, Tipo e Stato</h3>

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
                     value="${programmazione.prezzoBase}"
                     required>
              <small class="form-help">Prezzo standard del biglietto</small>
            </div>

            <div class="form-group">
              <label class="form-label" for="tipo">
                Tipo Programmazione <span>*</span>
              </label>
              <select id="tipo" name="tipo" class="form-select" required>
                <option value="STANDARD" ${programmazione.tipo == 'STANDARD' ? 'selected' : ''}>STANDARD</option>
                <option value="3D" ${programmazione.tipo == '3D' ? 'selected' : ''}>3D</option>
                <option value="IMAX" ${programmazione.tipo == 'IMAX' ? 'selected' : ''}>IMAX</option>
                <option value="DOLBY_ATMOS" ${programmazione.tipo == 'DOLBY_ATMOS' ? 'selected' : ''}>DOLBY ATMOS</option>
              </select>
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label class="form-label" for="stato">
                Stato <span>*</span>
              </label>
              <select id="stato" name="stato" class="form-select" required>
                <option value="Disponibile" ${programmazione.stato == 'Disponibile' ? 'selected' : ''}>Disponibile</option>
                <option value="Annullata" ${programmazione.stato == 'Annullata' ? 'selected' : ''}>Annullata</option>
                <option value="In Corso" ${programmazione.stato == 'In Corso' ? 'selected' : ''}>In Corso</option>
                <option value="Conclusa" ${programmazione.stato == 'Conclusa' ? 'selected' : ''}>Conclusa</option>
              </select>
            </div>

            <div class="form-group">
              <label class="form-label" for="idTariffa">
                Tariffa Speciale (opzionale)
              </label>
              <select id="idTariffa" name="idTariffa" class="form-select">
                <option value="">Nessuna tariffa</option>
                <c:forEach var="tariffa" items="${tariffe}">
                  <option value="${tariffa.idTariffa}"
                    ${tariffa.idTariffa == programmazione.idTariffa ? 'selected' : ''}>
                      ${tariffa.nome} (<fmt:formatNumber value="${tariffa.percentualeSconto}" pattern="#,##0"/>% sconto)
                  </option>
                </c:forEach>
              </select>
              <small class="form-help">Applicata automaticamente a biglietti qualificati</small>
            </div>
          </div>
        </div>

        <!-- PULSANTI -->
        <div class="form-actions">
          <button type="submit" class="btn btn-success">
            ✓ Salva Modifiche
          </button>
          <a href="${pageContext.request.contextPath}/admin/programmazione?action=dettaglio&id=${programmazione.idProgrammazione}"
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

<!-- JavaScript -->
<script>
  // Validazione form
  function validaFormModifica() {
    const prezzoBase = parseFloat(document.getElementById('prezzoBase').value);

    if (prezzoBase <= 0) {
      alert('Il prezzo base deve essere maggiore di zero!');
      return false;
    }

    // Conferma se sta cambiando slot/sala
    const salaOriginale = ${programmazione.idSala};
    const slotOriginale = ${programmazione.idSlotOrari};

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

  // Caricamento dinamico slot disponibili (opzionale per modifica)
  function caricaSlotDisponibili() {
    const idSala = document.getElementById('idSala').value;
    const data = document.getElementById('data').value;
    const selectSlot = document.getElementById('idSlotOrario');

    if (!idSala || !data) {
      return;
    }

    // AJAX per caricare slot disponibili
    fetch('${pageContext.request.contextPath}/admin/programmazione?action=slotDisponibili&idSala=' + idSala + '&data=' + data)
            .then(response => response.json())
            .then(data => {
              // Mantieni lo slot corrente come prima opzione
              const slotCorrente = selectSlot.options[0].value;
              const slotCorrenteTesto = selectSlot.options[0].text;

              selectSlot.innerHTML = '';

              // Aggiungi slot corrente
              const optionCorrente = document.createElement('option');
              optionCorrente.value = slotCorrente;
              optionCorrente.textContent = slotCorrenteTesto;
              selectSlot.appendChild(optionCorrente);

              // Aggiungi altri slot disponibili
              if (data.slots && data.slots.length > 0) {
                data.slots.forEach(slot => {
                  const option = document.createElement('option');
                  option.value = slot.idSlotOrario;
                  option.textContent = slot.oraInizio + ' - ' + slot.oraFine + ' (' + slot.stato + ')';
                  selectSlot.appendChild(option);
                });
              }
            })
            .catch(error => {
              console.error('Errore nel caricamento slot:', error);
            });
  }
</script>

</body>
</html>