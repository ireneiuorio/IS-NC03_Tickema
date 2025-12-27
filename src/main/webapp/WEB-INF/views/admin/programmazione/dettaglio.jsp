<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dettaglio Programmazione #${programmazione.idProgrammazione}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="admin-container">
    <div class="admin-card">

        <div class="admin-header">
            <h1>Dettaglio Programmazione #${programmazione.idProgrammazione}</h1>
            <p>${programmazione.film.titolo}</p>
        </div>

        <div class="admin-content">

            <!-- MESSAGGI -->
            <c:if test="${not empty sessionScope.messaggioSuccesso}">
                <div class="alert alert-success">
                    <span class="alert-icon">✓</span>
                    <span>${sessionScope.messaggioSuccesso}</span>
                </div>
                <c:remove var="messaggioSuccesso" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.messaggioErrore}">
                <div class="alert alert-danger">
                    <span class="alert-icon">✕</span>
                    <span>${sessionScope.messaggioErrore}</span>
                </div>
                <c:remove var="messaggioErrore" scope="session"/>
            </c:if>

            <!-- CONFERMA ELIMINAZIONE -->
            <c:if test="${richiestaConferma}">
                <div class="alert alert-warning">
                    <div>
                        <strong>Conferma eliminazione richiesta</strong>
                        <p>Eliminando questa programmazione:</p>
                        <ul>
                            <li>Tutti i biglietti venduti verranno rimborsati automaticamente</li>
                            <li>Lo slot orario verrà liberato</li>
                            <li>L'operazione NON può essere annullata</li>
                        </ul>
                        <div class="btn-group mt-20">
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

            <!-- INFORMAZIONI PROGRAMMAZIONE -->
            <div class="admin-section">
                <h2>Informazioni Generali</h2>

                <div class="item-details">
                    <div class="detail-item">
                        <div class="detail-content">
                            <div class="detail-label">Film</div>
                            <div class="detail-value">${programmazione.film.titolo}</div>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-content">
                            <div class="detail-label">Data</div>
                            <div class="detail-value">
                                <fmt:formatDate value="${programmazione.dataProgrammazione}" pattern="dd/MM/yyyy" type="date"/>
                            </div>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-content">
                            <div class="detail-label">Orario</div>
                            <div class="detail-value">
                                <fmt:formatDate value="${programmazione.slotOrari.oraInizio}" pattern="HH:mm" type="time"/> -
                                <fmt:formatDate value="${programmazione.slotOrari.oraFine}" pattern="HH:mm" type="time"/>
                            </div>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-content">
                            <div class="detail-label">Sala</div>
                            <div class="detail-value">
                                ${programmazione.sala.nome}
                                (${programmazione.sala.capienza} posti - ${programmazione.sala.numeroDiFile} file x ${programmazione.sala.numeroPostiPerFila} posti)
                            </div>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-content">
                            <div class="detail-label">Tipo</div>
                            <div class="detail-value">${programmazione.tipo}</div>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-content">
                            <div class="detail-label">Prezzo Base</div>
                            <div class="detail-value">€ <fmt:formatNumber value="${programmazione.prezzoBase}" pattern="#,##0.00"/></div>
                        </div>
                    </div>

                    <c:if test="${not empty programmazione.tariffa}">
                        <div class="detail-item">
                            <div class="detail-content">
                                <div class="detail-label">Tariffa Applicata</div>
                                <div class="detail-value">
                                        ${programmazione.tariffa.nome}
                                    (${programmazione.tariffa.tipo} -
                                    <c:choose>
                                        <c:when test="${programmazione.tariffa.percentualeSconto > 0}">
                                            <fmt:formatNumber value="${programmazione.tariffa.percentualeSconto}" pattern="#,##0"/>% di sconto
                                        </c:when>
                                        <c:otherwise>
                                            Tariffa intera
                                        </c:otherwise>
                                    </c:choose>)
                                </div>
                            </div>
                        </div>

                        <c:if test="${programmazione.tariffa.percentualeSconto > 0}">
                            <div class="detail-item">
                                <div class="detail-content">
                                    <div class="detail-label">Prezzo Finale</div>
                                    <div class="detail-value">€ <fmt:formatNumber value="${programmazione.calcolaPrezzoFinale()}" pattern="#,##0.00"/></div>
                                </div>
                            </div>
                        </c:if>
                    </c:if>

                    <div class="detail-item">
                        <div class="detail-content">
                            <div class="detail-label">Stato</div>
                            <div class="detail-value">
                                <c:choose>
                                    <c:when test="${programmazione.stato == 'DISPONIBILE'}">
                                        <span class="badge badge-success">✓ Disponibile</span>
                                    </c:when>
                                    <c:when test="${programmazione.stato == 'ANNULLATA'}">
                                        <span class="badge badge-danger">✕ Annullata</span>
                                    </c:when>
                                    <c:when test="${programmazione.stato == 'IN CORSO'}">
                                        <span class="badge badge-info">▶ In Corso</span>
                                    </c:when>
                                    <c:when test="${programmazione.stato == 'CONCLUSA'}">
                                        <span class="badge badge-secondary">■ Conclusa</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-warning">${programmazione.stato}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- SLOT ORARIO -->
            <div class="admin-section">
                <div class="item-details">
                    <div class="detail-item">
                        <span class="detail-icon">#</span>
                        <div class="detail-content">
                            <div class="detail-label">ID Slot</div>
                            <div class="detail-value">${programmazione.slotOrari.idSlotOrario}</div>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-content">
                            <div class="detail-label">Data Slot</div>
                            <div class="detail-value">
                                <fmt:formatDate value="${programmazione.slotOrari.data}" pattern="dd/MM/yyyy" type="date"/>
                            </div>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-content">
                            <div class="detail-label">Stato Slot</div>
                            <div class="detail-value">
                                <c:choose>
                                    <c:when test="${programmazione.slotOrari.stato == 'DISPONIBILE'}">
                                        <span class="badge badge-success">✓ Disponibile</span>
                                    </c:when>
                                    <c:when test="${programmazione.slotOrari.stato == 'OCCUPATO'}">
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
            </div>

            <!-- AZIONI -->
            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/admin/programmazione?action=lista&idFilm=${programmazione.idFilm}"
                   class="btn btn-secondary">
                    ← Torna alla Lista
                </a>

                <c:if test="${programmazione.stato == 'DISPONIBILE'}">
                    <a href="?action=formModifica&id=${programmazione.idProgrammazione}"
                       class="btn btn-primary">
                        Modifica
                    </a>
                </c:if>

                <c:if test="${!richiestaConferma && programmazione.stato != 'CONCLUSA'}">
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
</div>

</body>
</html>