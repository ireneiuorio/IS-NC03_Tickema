<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gestione Programmazioni - Tickema</title>

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
    .container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 0 30px 80px;
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

    .alert-success {
      background: #d4edda;
      color: #155724;
      border: 1px solid #c3e6cb;
    }

    .alert-danger {
      background: #f8d7da;
      color: #721c24;
      border: 1px solid #f5c6cb;
    }

    /* Toolbar Migliorata */
    .toolbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
      flex-wrap: wrap;
      gap: 20px;
      background: white;
      padding: 25px 30px;
      border-radius: 15px;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
    }

    .toolbar-left {
      display: flex;
      align-items: center;
      gap: 15px;
      flex-wrap: wrap;
    }

    .toolbar-title {
      font-size: 1.8em;
      color: var(--dark);
      font-weight: 700;
      margin: 0;
    }

    .toolbar-actions {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
      align-items: center;
    }

    .badge {
      padding: 8px 16px;
      border-radius: 20px;
      font-size: 0.9em;
      font-weight: 600;
    }

    .badge-info {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
    }

    .btn {
      padding: 12px 24px;
      border: none;
      border-radius: 8px;
      font-size: 1em;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      text-align: center;
    }

    .btn-primary {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
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

    .btn-outline {
      background: white;
      color: var(--dark);
      border: 2px solid var(--border);
    }

    .btn-outline:hover {
      border-color: var(--primary);
      background: var(--light-gray);
    }

    /* Modal */
    .modal-overlay {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(0, 0, 0, 0.7);
      z-index: 9998;
      animation: fadeIn 0.3s ease;
    }

    .modal-overlay.active {
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .modal-content {
      background: white;
      border-radius: 20px;
      padding: 40px;
      max-width: 600px;
      width: 90%;
      max-height: 80vh;
      overflow-y: auto;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
      animation: slideUp 0.3s ease;
    }

    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }

    @keyframes slideUp {
      from {
        opacity: 0;
        transform: translateY(50px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .modal-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 25px;
      padding-bottom: 20px;
      border-bottom: 2px solid #e9ecef;
    }

    .modal-header h3 {
      font-size: 1.8em;
      color: var(--dark);
      margin: 0;
    }

    .modal-close {
      background: none;
      border: none;
      font-size: 2em;
      color: #999;
      cursor: pointer;
      padding: 0;
      width: 40px;
      height: 40px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 50%;
      transition: all 0.3s ease;
    }

    .modal-close:hover {
      background: #f8f9fa;
      color: var(--dark);
    }

    .film-search {
      margin-bottom: 20px;
    }

    .film-search input {
      width: 100%;
      padding: 12px 20px;
      border: 2px solid #e9ecef;
      border-radius: 10px;
      font-size: 1em;
      transition: border-color 0.3s ease;
    }

    .film-search input:focus {
      outline: none;
      border-color: var(--primary);
    }

    .film-list {
      display: flex;
      flex-direction: column;
      gap: 10px;
      max-height: 400px;
      overflow-y: auto;
    }

    .film-item {
      padding: 15px 20px;
      border: 2px solid #e9ecef;
      border-radius: 10px;
      cursor: pointer;
      transition: all 0.3s ease;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .film-item:hover {
      border-color: var(--primary);
      background: #f8f9fa;
      transform: translateX(5px);
    }

    .film-item-info h4 {
      margin: 0 0 5px 0;
      color: var(--dark);
      font-size: 1.1em;
    }

    .film-item-info p {
      margin: 0;
      color: #666;
      font-size: 0.9em;
    }

    .film-item-arrow {
      color: var(--primary);
      font-size: 1.5em;
    }

    /* Table */
    .table-wrapper {
      background: white;
      border-radius: 15px;
      padding: 30px;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
      overflow-x: auto;
    }

    .programmazioni-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }

    .programmazioni-table thead {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
    }

    .programmazioni-table th {
      padding: 15px;
      text-align: left;
      font-weight: 600;
      font-size: 0.9em;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .programmazioni-table td {
      padding: 15px;
      border-bottom: 1px solid #e9ecef;
    }

    .programmazioni-table tbody tr {
      transition: background 0.3s ease;
    }

    .programmazioni-table tbody tr:hover {
      background: #f8f9fa;
    }

    /* Badge Stati */
    .badge-status {
      padding: 6px 12px;
      border-radius: 12px;
      font-size: 0.85em;
      font-weight: 600;
      display: inline-block;
    }

    .badge-success {
      background: var(--primary);
      color: white;
    }

    .badge-danger {
      background: #f8d7da;
      color: #721c24;
    }

    .badge-warning {
      background: #fff3cd;
      color: #856404;
    }

    .badge-secondary {
      background: #e9ecef;
      color: #495057;
    }

    /* Action Buttons */
    .action-buttons {
      display: flex;
      gap: 8px;
    }

    .btn-small {
      padding: 8px 14px;
      font-size: 0.85em;
      border-radius: 6px;
      border: none;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-block;
      font-weight: 600;
    }

    .btn-small-primary {
      background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
      color: white;
    }

    .btn-small-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 3px 10px rgba(109, 93, 110, 0.3);
    }

    .btn-small-secondary {
      background: #6c757d;
      color: white;
    }

    .btn-small-secondary:hover {
      background: #5a6268;
      transform: translateY(-2px);
    }

    .btn-small-danger {
      background: #dc3545;
      color: white;
    }

    .btn-small-danger:hover {
      background: #c82333;
      transform: translateY(-2px);
    }

    /* Empty State */
    .empty-state {
      text-align: center;
      padding: 60px 20px;
      background: white;
      border-radius: 15px;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
    }

    .empty-state h3 {
      font-size: 2em;
      color: var(--dark);
      margin-bottom: 10px;
    }

    .empty-state p {
      font-size: 1.1em;
      color: #666;
      margin-bottom: 20px;
    }

    /* Responsive */
    @media (max-width: 768px) {
      .hero h1 {
        font-size: 1.8em;
      }

      .toolbar {
        flex-direction: column;
        align-items: flex-start;
      }

      .toolbar-left {
        width: 100%;
      }

      .toolbar-actions {
        width: 100%;
        justify-content: flex-start;
      }

      .programmazioni-table {
        font-size: 0.9em;
      }

      .programmazioni-table th,
      .programmazioni-table td {
        padding: 10px 8px;
      }
    }
  </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Hero Section -->
<section class="hero">
  <h1>Gestione Programmazioni</h1>
  <c:choose>
    <c:when test="${not empty film}">
      <p>Film: <strong>${film.titolo}</strong> (${film.durata} min)</p>
    </c:when>
    <c:otherwise>
      <p>Crea, modifica ed elimina le programmazioni cinematografiche</p>
    </c:otherwise>
  </c:choose>
</section>

<!-- Main Content -->
<main>
  <div class="container">

    <!-- MESSAGGI -->
    <c:if test="${not empty sessionScope.messaggioSuccesso}">
      <div class="alert alert-success">
        <span>${sessionScope.messaggioSuccesso}</span>
      </div>
      <c:remove var="messaggioSuccesso" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.messaggioErrore}">
      <div class="alert alert-danger">
        <span>${sessionScope.messaggioErrore}</span>
      </div>
      <c:remove var="messaggioErrore" scope="session"/>
    </c:if>

    <!-- TOOLBAR MIGLIORATA -->
    <div class="toolbar">
      <div class="toolbar-left">
        <h2 class="toolbar-title">
          <c:choose>
            <c:when test="${not empty film}">
              ${film.titolo}
            </c:when>
            <c:otherwise>
              Tutte le Programmazioni
            </c:otherwise>
          </c:choose>
        </h2>
        <span class="badge badge-info">
          ${programmazioni.size()} Programmazioni
        </span>
      </div>

      <div class="toolbar-actions">
        <!-- Bottone Nuova Programmazione -->
        <button onclick="mostraModalSelezionaFilm(false)" class="btn btn-primary">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="12" y1="5" x2="12" y2="19"></line>
            <line x1="5" y1="12" x2="19" y2="12"></line>
          </svg>
          Nuova Programmazione
        </button>

        <!-- Bottone Creazione Multipla -->
        <button onclick="mostraModalSelezionaFilm(true)" class="btn btn-secondary">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="3" width="7" height="7"></rect>
            <rect x="14" y="3" width="7" height="7"></rect>
            <rect x="3" y="14" width="7" height="7"></rect>
            <rect x="14" y="14" width="7" height="7"></rect>
          </svg>
          Creazione Multipla
        </button>

        <!-- Link per rimuovere filtro film -->
        <c:if test="${not empty param.idFilm}">
          <a href="?action=lista" class="btn btn-outline">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
            Rimuovi Filtro
          </a>
        </c:if>
      </div>
    </div>

    <!-- TABELLA PROGRAMMAZIONI -->
    <c:choose>
      <c:when test="${empty programmazioni}">
        <div class="empty-state">
          <h3>Nessuna programmazione trovata</h3>
          <p>Non ci sono programmazioni nel sistema</p>
          <button onclick="mostraModalSelezionaFilm(false)" class="btn btn-primary">
            Crea la prima programmazione
          </button>
        </div>
      </c:when>

      <c:otherwise>
        <div class="table-wrapper">
          <table class="programmazioni-table">
            <thead>
            <tr>
              <th>ID</th>
              <th>Data</th>
              <th>Film</th>
              <th>Sala</th>
              <th>Orario</th>
              <th>Prezzo</th>
              <th>Tipo</th>
              <th>Stato</th>
              <th>Azioni</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="prog" items="${programmazioni}">
              <tr>
                <td><strong>#${prog.idProgrammazione}</strong></td>
                <td>${prog.dataProgrammazione}</td>
                <td>${prog.film.titolo}</td>
                <td>Sala ${prog.sala.nome}</td>
                <td>${prog.slotOrari.oraInizio} - ${prog.slotOrari.oraFine}</td>
                <td><strong>€ <fmt:formatNumber value="${prog.prezzoBase}" pattern="#,##0.00"/></strong></td>
                <td>${prog.tipo}</td>
                <td>
                  <c:choose>
                    <c:when test="${prog.stato == 'Disponibile'}">
                      <span class="badge-status badge-success">Disponibile</span>
                    </c:when>
                    <c:when test="${prog.stato == 'Annullata'}">
                      <span class="badge-status badge-danger">Annullata</span>
                    </c:when>
                    <c:when test="${prog.stato == 'In Corso'}">
                      <span class="badge-status badge-warning">In Corso</span>
                    </c:when>
                    <c:when test="${prog.stato == 'Conclusa'}">
                      <span class="badge-status badge-secondary">Conclusa</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge-status badge-warning">${prog.stato}</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <div class="action-buttons">
                    <a href="?action=dettaglio&id=${prog.idProgrammazione}"
                       class="btn-small btn-small-primary">
                      Dettagli
                    </a>
                    <c:if test="${prog.stato == 'Disponibile'}">
                      <a href="?action=formModifica&id=${prog.idProgrammazione}"
                         class="btn-small btn-small-secondary">
                        Modifica
                      </a>
                    </c:if>
                    <c:if test="${prog.stato != 'Conclusa'}">
                      <button onclick="confermaEliminazione(${prog.idProgrammazione}, ${prog.idFilm})"
                              class="btn-small btn-small-danger">
                        Elimina
                      </button>
                    </c:if>
                  </div>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </c:otherwise>
    </c:choose>

  </div>
</main>

<!-- MODAL SELEZIONE FILM -->
<div id="modalSelezionaFilm" class="modal-overlay" onclick="chiudiModalSeClickFuori(event, 'modalSelezionaFilm')">
  <div class="modal-content" onclick="event.stopPropagation()">
    <div class="modal-header">
      <h3>Seleziona Film</h3>
      <button class="modal-close" onclick="chiudiModal('modalSelezionaFilm')">&times;</button>
    </div>

    <div class="film-search">
      <input type="text" id="searchFilm" placeholder="Cerca film per titolo..." onkeyup="filtraFilm()">
    </div>

    <div class="film-list" id="filmList">
      <p style="text-align: center; color: #999;">Caricamento film...</p>
    </div>
  </div>
</div>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

<!-- JAVASCRIPT -->
<script>
  // Variabile globale con il context path
  const CONTEXT_PATH = '${pageContext.request.contextPath}';

  // Variabile globale per sapere se stiamo creando multipla o singola
  let creazioneMultipla = false;

  // Funzione per mostrare il modal
  function mostraModalSelezionaFilm(isMultipla) {
    console.log('=== APERTURA MODAL ===');
    console.log('isMultipla:', isMultipla);
    console.log('======================');

    creazioneMultipla = isMultipla;
    document.getElementById('modalSelezionaFilm').classList.add('active');
    caricaFilm();
  }

  // Funzione per chiudere il modal
  function chiudiModal(modalId) {
    document.getElementById(modalId).classList.remove('active');
  }

  // Funzione per chiudere se si clicca fuori dal modal
  function chiudiModalSeClickFuori(event, modalId) {
    if (event.target.id === modalId) {
      chiudiModal(modalId);
    }
  }

  // Carica lista film dal server
  function caricaFilm() {
    const filmList = document.getElementById('filmList');
    filmList.innerHTML = '<p style="text-align: center; color: #999;">Caricamento...</p>';

    fetch(CONTEXT_PATH + '/film?action=api-lista')
            .then(response => {
              console.log('Response status:', response.status);
              console.log('Response headers:', response.headers);

              if (!response.ok) {
                throw new Error('HTTP error ' + response.status);
              }

              return response.json();
            })
            .then(films => {
              console.log('Films ricevuti:', films);

              if (films.length === 0) {
                filmList.innerHTML = '<p style="text-align: center; color: #999;">Nessun film disponibile</p>';
                return;
              }

              filmList.innerHTML = '';
              films.forEach(film => {
                const filmItem = document.createElement('div');
                filmItem.className = 'film-item';
                filmItem.dataset.titolo = film.titolo.toLowerCase();
                filmItem.dataset.idFilm = film.idFilm;

                filmItem.innerHTML = `
            <div class="film-item-info">
              <h4>\${film.titolo}</h4>
              <p>\${film.anno} • \${film.genere} • \${film.durata} min</p>
            </div>
            <div class="film-item-arrow">→</div>
          `;

                // Aggiungi evento click
                filmItem.onclick = function() {
                  selezionaFilm(this.dataset.idFilm);
                };

                filmList.appendChild(filmItem);
              });
            })
            .catch(error => {
              console.error('Errore nel caricamento dei film:', error);
              filmList.innerHTML = '<p style="text-align: center; color: #dc3545;">Errore nel caricamento: ' + error.message + '</p>';
            });
  }

  // Filtra film durante la digitazione
  function filtraFilm() {
    const searchTerm = document.getElementById('searchFilm').value.toLowerCase();
    const filmItems = document.querySelectorAll('.film-item');

    filmItems.forEach(item => {
      const titolo = item.dataset.titolo;
      if (titolo.includes(searchTerm)) {
        item.style.display = 'flex';
      } else {
        item.style.display = 'none';
      }
    });
  }

  // Seleziona film e vai alla pagina appropriata
  function selezionaFilm(idFilm) {
    console.log('=== SELEZIONE FILM ===');
    console.log('idFilm ricevuto:', idFilm);
    console.log('tipo di idFilm:', typeof idFilm);

    if (!idFilm || idFilm === 'undefined') {
      console.error('❌ idFilm non valido!');
      alert('Errore: ID film non valido');
      return;
    }

    const action = creazioneMultipla ? 'formMultipla' : 'formCrea';
    const url = `?action=\${action}&idFilm=\${idFilm}`;

    console.log('creazioneMultipla:', creazioneMultipla);
    console.log('action:', action);
    console.log('URL finale:', url);
    console.log('URL completo:', window.location.origin + window.location.pathname + url);
    console.log('======================');

    window.location.href = url;
  }

  // Funzione per confermare eliminazione
  function confermaEliminazione(idProgrammazione, idFilm) {
    if (confirm('ATTENZIONE!\n\nSei sicuro di voler eliminare questa programmazione?\n\n• Tutti i biglietti venduti verranno RIMBORSATI automaticamente\n• Lo slot orario verrà liberato\n• Questa azione NON può essere annullata')) {
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = '${pageContext.request.contextPath}/admin/programmazione';

      const params = {
        'action': 'elimina',
        'id': idProgrammazione,
        'idFilm': idFilm,
        'conferma': 'true'
      };

      for (let key in params) {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = key;
        input.value = params[key];
        form.appendChild(input);
      }

      document.body.appendChild(form);
      form.submit();
    }
  }

  // Chiudi modal con tasto ESC
  document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
      chiudiModal('modalSelezionaFilm');
    }
  });
</script>

</body>
</html>