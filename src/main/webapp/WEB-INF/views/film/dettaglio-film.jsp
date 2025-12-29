<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${film.titolo} - Tickema</title>

    <!-- CSS Base -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        /* Hero Section */
        /* Hero Section - PIÙ COMPATTO */
        .hero {
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: white;
            padding: 60px 30px;
            margin-bottom: 60px;
        }

        .hero-container {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 240px 1fr;
            gap: 40px;
            align-items: start;
        }

        .film-poster-large {
            width: 240px;
            height: 360px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .film-poster-large img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .film-poster-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 5em;
            background: rgba(255, 255, 255, 0.05);
        }

        .hero-info h1 {
            font-size: 2.8em;
            font-weight: bold;
            font-style: italic;
            margin-bottom: 20px;
            letter-spacing: 1px;
            line-height: 1.1;
        }

        .hero-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
        }

        .meta-tag {
            background: rgba(255, 255, 255, 0.15);
            padding: 8px 14px;
            border-radius: 20px;
            font-size: 0.9em;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            font-weight: 500;
        }

        .hero-info p {
            font-size: 1.05em;
            line-height: 1.7;
            opacity: 0.95;
            font-weight: 300;
        }
        /* Main Container */
        .dettaglio-container {
            max-width: 1200px;
            margin: 0 auto 100px;
            padding: 0 30px;
        }

        /* Section */
        .section {
            background: white;
            border-radius: 16px;
            padding: 45px;
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.04);
        }

        .section-title {
            font-size: 1.8em;
            color: var(--dark);
            margin-bottom: 35px;
            font-weight: 600;
            letter-spacing: 0.3px;
        }

        /* Programmazioni Grid */
        .programmazioni-grid {
            display: grid;
            gap: 20px;
        }

        .prog-card {
            background: white;
            border: 1px solid #e8e8e8;
            border-radius: 12px;
            padding: 28px;
            transition: all 0.3s ease;
        }

        .prog-card:hover {
            border-color: var(--primary);
            box-shadow: 0 4px 20px rgba(109, 93, 110, 0.1);
            transform: translateY(-2px);
        }

        .prog-info-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 20px;
            margin-bottom: 25px;
            padding-bottom: 25px;
            border-bottom: 1px solid #f0f0f0;
        }

        .prog-info-item {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .prog-label {
            font-size: 0.7em;
            color: #aaa;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }

        .prog-value {
            font-size: 1.15em;
            color: var(--dark);
            font-weight: 600;
        }

        .prog-price {
            font-size: 1.8em;
            color: var(--primary);
            font-weight: 700;
        }

        /* Badge Minimalista */
        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.75em;
            font-weight: 600;
            display: inline-block;
            letter-spacing: 0.3px;
        }

        .badge-available {
            background: var(--primary);
            color: white;
        }

        .badge-unavailable {
            background: #f0f0f0;
            color: #aaa;
        }

        /* Form Acquisto */
        .prog-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }

        .form-group {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .form-label {
            font-weight: 600;
            color: var(--dark);
            font-size: 0.95em;
            white-space: nowrap;
        }

        .form-input {
            padding: 10px 16px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1.05em;
            font-weight: 600;
            width: 80px;
            text-align: center;
            transition: all 0.3s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(109, 93, 110, 0.1);
        }

        .btn {
            padding: 12px 35px;
            border: none;
            border-radius: 8px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            white-space: nowrap;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--dark) 100%);
            color: white;
        }

        .btn-primary:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(109, 93, 110, 0.25);
        }

        .btn:disabled {
            background: #f0f0f0;
            color: #bbb;
            cursor: not-allowed;
            transform: none;
        }

        /* No Results */
        .no-results {
            text-align: center;
            padding: 60px 20px;
        }

        .no-results h3 {
            font-size: 1.4em;
            color: var(--dark);
            margin-bottom: 12px;
            font-weight: 600;
        }

        .no-results p {
            color: #999;
            font-size: 1.05em;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .section {
                padding: 30px 20px;
            }

            .prog-info-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
            }

            .prog-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .form-group {
                justify-content: space-between;
            }

            .form-input {
                width: 100px;
            }
        }
    </style>
</head>
<body>
<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Hero Section -->
<section class="hero">
    <div class="hero-container">
        <div class="film-poster-large">
            <c:choose>
                <c:when test="${not empty film.locandina}">
                    <img src="${film.locandina}"
                         alt="${film.titolo}"
                         onerror="this.parentElement.innerHTML='<div class=\'film-poster-placeholder\'></div>'">
                </c:when>
                <c:otherwise>
                    <div class="film-poster-placeholder">🎬</div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="hero-info">
            <h1>${film.titolo}</h1>

            <div class="hero-meta">
                <span class="meta-tag">${film.durata} minuti</span>
                <span class="meta-tag">${film.genere}</span>
                <c:if test="${not empty film.anno && film.anno > 0}">
                    <span class="meta-tag">${film.anno}</span>
                </c:if>
                <c:if test="${not empty film.regista}">
                    <span class="meta-tag">${film.regista}</span>
                </c:if>
            </div>

            <c:if test="${not empty film.trama}">
                <p>${film.trama}</p>
            </c:if>
        </div>
    </div>
</section>

<!-- Main Content -->
<main>
    <div class="dettaglio-container">

        <!-- Programmazioni -->
        <div class="section">
            <h2 class="section-title">Programmazioni Disponibili</h2>

            <c:choose>
                <c:when test="${empty programmazioni}">
                    <div class="no-results">
                        <h3>Nessuna programmazione disponibile</h3>
                        <p>Al momento non ci sono proiezioni programmate per questo film</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="programmazioni-grid">
                        <c:forEach var="prog" items="${programmazioni}">
                            <div class="prog-card">
                                <div class="prog-info-grid">
                                    <div class="prog-info-item">
                                        <span class="prog-label">Data</span>
                                        <span class="prog-value">${prog.dataProgrammazione}</span>
                                    </div>
                                    <div class="prog-info-item">
                                        <span class="prog-label">Orario</span>
                                        <span class="prog-value">${prog.slotOrari.oraInizio}</span>
                                    </div>
                                    <div class="prog-info-item">
                                        <span class="prog-label">Sala</span>
                                        <span class="prog-value">${prog.sala.nome}</span>
                                    </div>
                                    <div class="prog-info-item">
                                        <span class="prog-label">Prezzo</span>
                                        <span class="prog-price">€<fmt:formatNumber value="${prog.prezzoBase}" pattern="#,##0.00"/></span>
                                    </div>
                                    <div class="prog-info-item">
                                        <span class="prog-label">Stato</span>
                                        <c:choose>
                                            <c:when test="${prog.stato == 'Disponibile'}">
                                                <span class="badge badge-available" style="text-align: center">Disponibile</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-unavailable">Esaurito</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <c:choose>
                                    <c:when test="${prog.stato == 'Disponibile'}">
                                        <form method="GET" action="${pageContext.request.contextPath}/acquisto" class="prog-actions">
                                            <input type="hidden" name="idProgrammazione" value="${prog.idProgrammazione}">

                                            <div class="form-group">
                                                <label class="form-label">Numero biglietti</label>
                                                <input type="number"
                                                       name="numeroBiglietti"
                                                       class="form-input"
                                                       min="1"
                                                       max="10"
                                                       value="1"
                                                       required>
                                            </div>

                                            <button type="submit" class="btn btn-primary">
                                                Acquista Biglietti
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="prog-actions">
                                            <div></div>
                                            <button class="btn" disabled>
                                                Non Disponibile
                                            </button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

</body>
</html>