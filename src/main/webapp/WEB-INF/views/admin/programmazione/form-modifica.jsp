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

    .alert-warning {
      background: white;
      color: var(--primary);
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
    <h1>Modifica Programmazione</h1>
    <p>ID: #${programmazione.idProgrammazione} - ${programmazione.film.titolo}</p>
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

    <!-- Alert Warning -->
    <div class="alert alert-warning">
      <div>
        <strong>Attenzione</strong>
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
          <h3>Slot Orario</h3>

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
            <small class="form-help" id="slotInfo">Slot attualmente selezionato + altri disponibili</small>
          </div>
        </div>

        <!-- SEZIONE PREZZI E TIPO -->
        <div class="form-section">
          <h3>Prezzi e Tipo</h3>

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
                     value="${programmazione.prezzoBase}"
                     required>
              <small class="form-help">Prezzo standard del biglietto</small>
            </div>

            <div class="form-group">
              <label class="form-label" for="tipo">
                Tipo Programmazione <span>*</span>
              </label>
              <select id="tipo" name="tipo" class="form-select" required>
                <option value="STANDARD" ${programmazione.tipo == 'STANDARD' ? 'selected' : ''}>Standard</option>
                <option value="3D" ${programmazione.tipo == '3D' ? 'selected' : ''}>3D</option>
                <option value="IMAX" ${programmazione.tipo == 'IMAX' ? 'selected' : ''}>IMAX</option>
                <option value="DOLBY_ATMOS" ${programmazione.tipo == 'DOLBY_ATMOS' ? 'selected' : ''}>Dolby Atmos</option>
              </select>
            </div>
          </div>
        </div>

        <!-- SEZIONE STATO E TARIFFA -->
        <div class="form-section">
          <h3>Stato e Tariffa</h3>

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
              <small class="form-help">Cambiando a "Annullata" verranno rimborsati automaticamente tutti i biglietti</small>
            </div>

            <div class="form-group">
              <label class="form-label" for="idTariffa">
                Tariffa Speciale
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
          <button type="submit" class="btn btn-primary">
            Salva Modifiche
          </button>
          <a href="${pageContext.request.contextPath}/admin/programmazione?action=dettaglio&id=${programmazione.idProgrammazione}"
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
  const contextPath = '${pageContext.request.contextPath}';

  function validaFormModifica() {
    const prezzoBase = parseFloat(document.getElementById('prezzoBase').value);

    if (prezzoBase <= 0) {
      alert('Il prezzo base deve essere maggiore di zero');
      return false;
    }

    const salaOriginale = ${programmazione.idSala};
    const slotOriginale = ${programmazione.idSlotOrari};
    const statoOriginale = '${programmazione.stato}';

    const salaNuova = parseInt(document.getElementById('idSala').value);
    const slotNuovo = parseInt(document.getElementById('idSlotOrario').value);
    const statoNuovo = document.getElementById('stato').value;

    // Conferma annullamento
    if (statoNuovo === 'Annullata' && statoOriginale !== 'Annullata') {
      return confirm(
              'ATTENZIONE: Annullamento Programmazione\n\n' +
              'Confermando questa operazione:\n\n' +
              '• Tutti i biglietti venduti verranno RIMBORSATI automaticamente\n' +
              '• Gli importi verranno restituiti sul saldo degli utenti\n' +
              '• Lo slot orario verrà LIBERATO\n' +
              '• Lo stato diventerà ANNULLATA\n\n' +
              'Questa operazione è irreversibile.\n\n' +
              'Confermi l\'annullamento della programmazione?'
      );
    }

    // Conferma cambio slot/sala
    if (salaNuova !== salaOriginale || slotNuovo !== slotOriginale) {
      return confirm(
              'ATTENZIONE: Modifica Slot/Sala\n\n' +
              'Stai modificando sala o slot orario.\n\n' +
              '• Il vecchio slot verrà LIBERATO\n' +
              '• Il nuovo slot verrà OCCUPATO\n\n' +
              'Confermi la modifica?'
      );
    }

    return true;
  }

  function caricaSlotDisponibili() {
    const dataInput = document.getElementById('data');
    const salaSelect = document.getElementById('idSala');
    const slotSelect = document.getElementById('idSlotOrario');
    const slotInfo = document.getElementById('slotInfo');

    const data = dataInput.value;
    const sala = salaSelect.value;

    if (!data || !sala) {
      slotInfo.innerHTML = 'Seleziona sala e data per caricare gli slot';
      slotInfo.className = 'form-help';
      return;
    }

    const url = contextPath + '/admin/programmazione?action=slotDisponibili&idSala=' + sala + '&data=' + data;

    slotSelect.disabled = true;
    slotInfo.innerHTML = 'Caricamento in corso...';
    slotInfo.className = 'form-help loading-state';

    // Salva lo slot corrente
    const slotCorrente = slotSelect.options[0].value;
    const slotCorrenteTesto = slotSelect.options[0].text;

    fetch(url)
            .then(function(response) {
              if (!response.ok) {
                throw new Error('Errore nel caricamento');
              }
              return response.json();
            })
            .then(function(data) {
              slotSelect.innerHTML = '';

              // Ripristina slot corrente come prima opzione
              const optionCorrente = document.createElement('option');
              optionCorrente.value = slotCorrente;
              optionCorrente.textContent = slotCorrenteTesto;
              slotSelect.appendChild(optionCorrente);

              // Aggiungi altri slot disponibili
              if (data.slots && data.slots.length > 0) {
                for (let i = 0; i < data.slots.length; i++) {
                  const slot = data.slots[i];
                  const option = document.createElement('option');
                  option.value = slot.idSlotOrario;
                  option.textContent = slot.oraInizio + ' - ' + slot.oraFine + ' (' + slot.stato + ')';

                  if (slot.stato === 'OCCUPATO') {
                    option.disabled = true;
                  }

                  slotSelect.appendChild(option);
                }

                slotInfo.innerHTML = data.slots.length + ' slot disponibili';
                slotInfo.className = 'form-help success-state';
              } else {
                slotInfo.innerHTML = 'Nessun altro slot disponibile';
                slotInfo.className = 'form-help';
              }

              slotSelect.disabled = false;
            })
            .catch(function(error) {
              console.error('Errore:', error);
              slotInfo.innerHTML = 'Errore nel caricamento degli slot';
              slotInfo.className = 'form-help error-state';
              slotSelect.disabled = false;
            });
  }
</script>

</body>
</html>