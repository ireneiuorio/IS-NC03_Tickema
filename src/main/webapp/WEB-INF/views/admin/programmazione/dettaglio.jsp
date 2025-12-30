<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dettaglio Programmazione #${programmazione.idProgrammazione} - Tickema</title>

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
            margin-bottom: 10px;
        }

        .hero p {
            font-size: 1.1em;
            opacity: 0.95;
        }

        /* Container */
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 30px 80px;
        }

        /* Alert */
        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }

        .alert-success {
            background: var(--primary);
            color: white;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background: var(--primary);
            color: white;
            border: 1px solid #f5c6cb;
        }

        .alert-warning {
            background: var(--primary);
            color: white;
            border: 1px solid #ffeaa7;
        }

        /* Detail Card */
        .detail-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .detail-section {
            margin-bottom: 35px;
            padding-bottom: 25px;
            border-bottom: 2px solid #e9ecef;
        }

        .detail-section:last-of-type {
            border-bottom: none;
        }

        .detail-section h2 {
            font-size: 1.4em;
            color: var(--dark);
            margin-bottom: 20px;
            font-weight: 600;
        }

        /* Detail Grid */
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .detail-item {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
        }

        .detail-label {
            font-size: 0.85em;
            color: #6c757d;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }

        .detail-value {
            font-size: 1.1em;
            color: var(--dark);
            font-weight: 600;
        }

        /* Badge */
        .badge {
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 0.9em;
            font-weight: 600;
            display: inline-block;
        }

        .badge-success {
            background: var(--primary);
            color: white;
        }

        .badge-danger {
            background: var(--primary);
            color: white;
        }

        .badge-warning {
            background: var(--primary);
            color: white;
        }

        .badge-secondary {
            background: #e9ecef;
            color: #495057;
        }

        .badge-info {
            background: #d1ecf1;
            color: #0c5460;
        }

        /* Button Group */
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 30px;
            border-top: 2px solid #e9ecef;
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
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(109, 93, 110, 0.3);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .btn-danger {
            background:var(--primary);
            color: white;
        }

        .btn-danger:hover {
            background:var(--primary);
            transform: translateY(-2px);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 1.8em;
            }

            .detail-card {
                padding: 25px;
            }

            .detail-grid {
                grid-template-columns: 1fr;
            }

            .btn-group {
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
    <h1>Dettaglio Programmazione #${programmazione.idProgrammazione}</h1>
    <p>${programmazione.film.titolo}</p>
</section>

<!-- Main Content -->
<main>
    <div class="container">

        <!-- MESSAGGI -->
        <c:if test="${not empty sessionScope.messaggioSuccesso}">
            <div class="alert alert-success">
                <span>✓ ${sessionScope.messaggioSuccesso}</span>
            </div>
            <c:remove var="messaggioSuccesso" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.messaggioErrore}">
            <div class="alert alert-danger">
                <span>✕ ${sessionScope.messaggioErrore}</span>
            </div>
            <c:remove var="messaggioErrore" scope="session"/>
        </c:if>

        <!-- CONFERMA ELIMINAZIONE -->
        <c:if test="${richiestaConferma}">
            <div class="alert alert-warning">
                <div>
                    <strong>Conferma eliminazione richiesta</strong>
                    <p style="margin: 10px 0;">Eliminando questa programmazione:</p>
                    <ul style="margin: 10px 0; padding-left: 20px;">
                        <li>Tutti i biglietti venduti verranno rimborsati automaticamente</li>
                        <li>Lo slot orario verrà liberato</li>
                        <li>L'operazione NON può essere annullata</li>
                    </ul>
                    <div style="display: flex; gap: 10px; margin-top: 15px;">
                        <form method="POST" action="${pageContext.request.contextPath}/admin/programmazione" style="display:inline;">
                            <input type="hidden" name="action" value="elimina">
                            <input type="hidden" name="id" value="${programmazione.idProgrammazione}">
                            <input type="hidden" name="idFilm" value="${programmazione.idFilm}">
                            <input type="hidden" name="conferma" value="true">
                            <button type="submit" class="btn btn-danger">Conferma Eliminazione</button>
                        </form>
                        <a href="?action=dettaglio&id=${programmazione.idProgrammazione}" class="btn btn-secondary">
                            Annulla
                        </a>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- DETAIL CARD -->
        <div class="detail-card">

            <!-- INFORMAZIONI GENERALI -->
            <div class="detail-section">
                <h2>Informazioni Generali</h2>

                <div class="detail-grid">
                    <div class="detail-item">
                        <div class="detail-label">Film</div>
                        <div class="detail-value">${programmazione.film.titolo}</div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Data</div>
                        <div class="detail-value">${programmazione.dataProgrammazione}</div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Orario</div>
                        <div class="detail-value">
                            ${programmazione.slotOrari.oraInizio} - ${programmazione.slotOrari.oraFine}
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Sala</div>
                        <div class="detail-value">
                            ${programmazione.sala.nome}
                            (${programmazione.sala.capienza} posti)
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Tipo</div>
                        <div class="detail-value">${programmazione.tipo}</div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Prezzo Base</div>
                        <div class="detail-value">€ <fmt:formatNumber value="${programmazione.prezzoBase}" pattern="#,##0.00"/></div>
                    </div>

                    <c:if test="${not empty programmazione.tariffa}">
                        <div class="detail-item">
                            <div class="detail-label">Tariffa Applicata</div>
                            <div class="detail-value">
                                    ${programmazione.tariffa.nome}
                                (<fmt:formatNumber value="${programmazione.tariffa.percentualeSconto}" pattern="#,##0"/>% sconto)
                            </div>
                        </div>
                    </c:if>

                    <div class="detail-item">
                        <div class="detail-label">Stato</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${programmazione.stato == 'Disponibile'}">
                                    <span class="badge badge-success">Disponibile</span>
                                </c:when>
                                <c:when test="${programmazione.stato == 'Annullata'}">
                                    <span class="badge badge-danger">Annullata</span>
                                </c:when>
                                <c:when test="${programmazione.stato == 'In Corso'}">
                                    <span class="badge badge-info">In Corso</span>
                                </c:when>
                                <c:when test="${programmazione.stato == 'Conclusa'}">
                                    <span class="badge badge-secondary">Conclusa</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-warning">${programmazione.stato}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- SLOT ORARIO -->
            <div class="detail-section">
                <h2>Dettagli Slot Orario</h2>

                <div class="detail-grid">
                    <div class="detail-item">
                        <div class="detail-label">ID Slot</div>
                        <div class="detail-value">#${programmazione.slotOrari.idSlotOrario}</div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Data Slot</div>
                        <div class="detail-value">${programmazione.slotOrari.data}</div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Stato Slot</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${programmazione.slotOrari.stato == 'Disponibile'}">
                                    <span class="badge badge-success">✓ Disponibile</span>
                                </c:when>
                                <c:when test="${programmazione.slotOrari.stato == 'Occupato'}">
                                    <span class="badge badge-warning">⊗ Occupato</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-secondary">${programmazione.slotOrari.stato}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- AZIONI -->
            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/admin/programmazione?action=lista&idFilm=${programmazione.idFilm}"
                   class="btn btn-secondary">
                    ← Torna alla Lista
                </a>

                <c:if test="${programmazione.stato == 'Disponibile'}">
                    <a href="?action=formModifica&id=${programmazione.idProgrammazione}"
                       class="btn btn-primary">
                        Modifica
                    </a>
                </c:if>

                <c:if test="${!richiestaConferma && programmazione.stato != 'Conclusa'}">
                    <form method="POST" action="${pageContext.request.contextPath}/admin/programmazione" style="display:inline;">
                        <input type="hidden" name="action" value="elimina">
                        <input type="hidden" name="id" value="${programmazione.idProgrammazione}">
                        <input type="hidden" name="idFilm" value="${programmazione.idFilm}">
                        <button type="submit" class="btn btn-danger">
                            Elimina
                        </button>
                    </form>
                </c:if>
            </div>

        </div>

    </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

</body>
</html>