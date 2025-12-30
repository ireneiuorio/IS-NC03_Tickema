<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${azione == 'crea' ? 'Nuovo Film' : 'Modifica Film'} - Tickema</title>

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
      max-width: 800px;
      margin: 0 auto;
      padding: 0 30px 80px;
    }

    /* Card Form */
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

    /* Form Groups */
    .form-group {
      margin-bottom: 25px;
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
    .form-select,
    .form-textarea {
      width: 100%;
      padding: 12px 15px;
      border: 2px solid var(--border);
      border-radius: 8px;
      font-size: 1em;
      transition: all 0.3s ease;
      font-family: inherit;
    }

    .form-input:focus,
    .form-select:focus,
    .form-textarea:focus {
      outline: none;
      border-color: var(--primary);
      box-shadow: 0 0 0 3px rgba(109, 93, 110, 0.1);
    }

    .form-textarea {
      resize: vertical;
      min-height: 120px;
    }

    .form-help {
      font-size: 0.85em;
      color: #666;
      margin-top: 5px;
    }

    /* File Upload */
    .file-upload-wrapper {
      position: relative;
      overflow: hidden;
      display: inline-block;
      width: 100%;
    }

    .file-upload-input {
      font-size: 1em;
      position: absolute;
      left: 0;
      top: 0;
      opacity: 0;
      cursor: pointer;
      width: 100%;
      height: 100%;
    }

    .file-upload-label {
      display: block;
      padding: 12px 15px;
      border: 2px dashed var(--border);
      border-radius: 8px;
      text-align: center;
      cursor: pointer;
      transition: all 0.3s ease;
      background: #f8f9fa;
    }

    .file-upload-label:hover {
      border-color: var(--primary);
      background: #e9ecef;
    }

    .file-upload-text {
      color: var(--dark);
      font-weight: 500;
    }

    .file-name {
      margin-top: 10px;
      font-size: 0.9em;
      color: #666;
      font-style: italic;
    }

    /* Preview Immagine */
    .image-preview {
      margin-top: 15px;
      text-align: center;
    }

    .image-preview img {
      max-width: 100%;
      max-height: 400px;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
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
  <h1>${azione == 'crea' ? 'Nuovo Film' : 'Modifica Film'}</h1>
  <p>${azione == 'crea' ? 'Aggiungi un nuovo film al catalogo' : 'Modifica le informazioni del film'}</p>
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
            action="${pageContext.request.contextPath}/film"
            enctype="multipart/form-data">

        <input type="hidden" name="action" value="${azione}">
        <c:if test="${azione == 'modifica'}">
          <input type="hidden" name="idFilm" value="${film.idFilm}">
        </c:if>

        <!-- Titolo -->
        <div class="form-group">
          <label class="form-label" for="titolo">
            Titolo <span>*</span>
          </label>
          <input type="text"
                 id="titolo"
                 name="titolo"
                 class="form-input"
                 value="${film != null ? film.titolo : ''}"
                 required
                 placeholder="es. Il Padrino">
        </div>

        <!-- Regista -->
        <div class="form-group">
          <label class="form-label" for="regista">
            Regista <span>*</span>
          </label>
          <input type="text"
                 id="regista"
                 name="regista"
                 class="form-input"
                 value="${film != null ? film.regista : ''}"
                 required
                 placeholder="es. Francis Ford Coppola">
        </div>

        <!-- Anno e Durata -->
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
          <!-- Anno -->
          <div class="form-group">
            <label class="form-label" for="anno">
              Anno <span>*</span>
            </label>
            <input type="number"
                   id="anno"
                   name="anno"
                   class="form-input"
                   value="${film != null ? film.anno : ''}"
                   min="1888"
                   max="2030"
                   required
                   placeholder="es. 1972">
          </div>

          <!-- Durata -->
          <div class="form-group">
            <label class="form-label" for="durata">
              Durata (minuti) <span>*</span>
            </label>
            <input type="number"
                   id="durata"
                   name="durata"
                   class="form-input"
                   value="${film != null ? film.durata : ''}"
                   min="1"
                   required
                   placeholder="es. 175">
          </div>
        </div>

        <!-- Genere -->
        <div class="form-group">
          <label class="form-label" for="genere">
            Genere <span>*</span>
          </label>
          <select id="genere" name="genere" class="form-select" required>
            <option value="">Seleziona un genere</option>
            <option value="Azione" ${film != null && film.genere == 'Azione' ? 'selected' : ''}>Azione</option>
            <option value="Commedia" ${film != null && film.genere == 'Commedia' ? 'selected' : ''}>Commedia</option>
            <option value="Dramma" ${film != null && film.genere == 'Dramma' ? 'selected' : ''}>Dramma</option>
            <option value="Horror" ${film != null && film.genere == 'Horror' ? 'selected' : ''}>Horror</option>
            <option value="Fantascienza" ${film != null && film.genere == 'Fantascienza' ? 'selected' : ''}>Fantascienza</option>
            <option value="Thriller" ${film != null && film.genere == 'Thriller' ? 'selected' : ''}>Thriller</option>
            <option value="Animazione" ${film != null && film.genere == 'Animazione' ? 'selected' : ''}>Animazione</option>
            <option value="Avventura" ${film != null && film.genere == 'Avventura' ? 'selected' : ''}>Avventura</option>
            <option value="Documentario" ${film != null && film.genere == 'Documentario' ? 'selected' : ''}>Documentario</option>
          </select>
        </div>

        <!-- Trama -->
        <div class="form-group">
          <label class="form-label" for="trama">
            Trama
          </label>
          <textarea id="trama"
                    name="trama"
                    class="form-textarea"
                    placeholder="Descrivi brevemente la trama del film...">${film != null ? film.trama : ''}</textarea>
          <div class="form-help">Opzionale - massimo 500 caratteri</div>
        </div>

        <!-- Upload Locandina -->
        <div class="form-group">
          <label class="form-label" for="locandina">
            Locandina <span>*</span>
          </label>

          <div class="file-upload-wrapper">
            <input type="file"
                   id="locandina"
                   name="locandina"
                   class="file-upload-input"
                   accept="image/*"
            ${azione == 'crea' ? 'required' : ''}
                   onchange="previewImage(event)">
            <label for="locandina" class="file-upload-label">
              <span class="file-upload-text">Clicca per caricare la locandina</span>
            </label>
          </div>

          <div id="fileName" class="file-name"></div>
          <div class="form-help">Formati supportati: JPG, PNG, WEBP - Max 5MB</div>

          <!-- Preview Immagine -->
          <div id="imagePreview" class="image-preview" style="display: none;">
            <img id="preview" src="" alt="Anteprima locandina">
          </div>

          <!-- Locandina esistente (solo in modifica) -->
          <c:if test="${azione == 'modifica' && not empty film.locandina}">
            <div class="image-preview">
              <p style="margin-bottom: 10px; font-weight: 600;">Locandina attuale:</p>
              <img src="${film.locandina}" alt="${film.titolo}">
              <input type="hidden" name="locandinaEsistente" value="${film.locandina}">
            </div>
          </c:if>
        </div>

        <!-- Azioni -->
        <div class="form-actions">
          <button type="submit" class="btn btn-primary">
            ${azione == 'crea' ? 'Crea Film' : 'Salva Modifiche'}
          </button>
          <a href="${pageContext.request.contextPath}/film?action=admin-lista"
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
  // Preview dell'immagine selezionata
  function previewImage(event) {
    const file = event.target.files[0];
    const fileName = document.getElementById('fileName');
    const preview = document.getElementById('preview');
    const imagePreview = document.getElementById('imagePreview');

    if (file) {
      // Mostra nome file
      fileName.textContent = 'File selezionato: ' + file.name;

      // Mostra preview
      const reader = new FileReader();
      reader.onload = function(e) {
        preview.src = e.target.result;
        imagePreview.style.display = 'block';
      };
      reader.readAsDataURL(file);
    } else {
      fileName.textContent = '';
      imagePreview.style.display = 'none';
    }
  }
</script>

</body>
</html>