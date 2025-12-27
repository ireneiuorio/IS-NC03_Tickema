<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Creazione Multipla - ${film.titolo}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-style.css">
    <style>
        .programmazione-row {
            background: var(--white);
            border: 2px solid var(--border);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
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
            color: var(--white);
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9em;
        }

        .btn-rimuovi-row {
            position: absolute;
            top: 10px;
            right: 10px;
            background: var(--danger);
            color: var(--white);
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
            box-shadow: 0 3px 10px rgba(244, 67, 54, 0.4);
        }

        .row-fields {
            margin-top: 10px;
        }

        #containerProgrammazioni {
            min-height: 100px;
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: var(--text-light);
        }

        .empty-state-icon {
            font-size: 4em;
            margin-bottom: 15px;
        }

        .btn-small {
            padding: 8px 16px;
            font-size: 0.9em;
        }
    </style>
</head>
<body>

<div class="admin-container">
    <div class="admin-card">

        <div class="admin-header">
            <h1>Creazione Multipla Programmazioni</h1>
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

            <div class="alert alert-info mb-30">
                <div>
                    <strong>Creazione in batch</strong>
                    <p>Aggiungi più programmazioni contemporaneamente. Ogni riga rappresenta una programmazione separata.</p>
                </div>
            </div>

            <form method="POST" action="${pageContext.request.contextPath}/admin/programmazione"
                  id="formCreaMultipla" onsubmit="return validaFormMultipla()">

                <input type="hidden" name="action" value="creaMultipla">
                <input type="hidden" name="idFilm" value="${film.idFilm}">

                <!-- PARAMETRI COMUNI -->
                <div class="form-section">
                    <h3>Parametri Comuni</h3>

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
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h3>Programmazioni</h3>
                        <button type="button" onclick="aggiungiProgrammazione()" class="btn btn-success btn-small">
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
</div>

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