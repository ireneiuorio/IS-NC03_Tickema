<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="footer">
  <div class="footer-container">
    <!-- About Section -->
    <div class="footer-section">
      <h3>Tickema</h3>
      <p>
        Il tuo cinema preferito, sempre a portata di click.
        Compra i tuoi biglietti online in modo semplice e veloce.
      </p>
    </div>

    <!-- Quick Links -->
    <div class="footer-section">
      <h3>Link Rapidi</h3>
      <ul>
        <li><a href="${pageContext.request.contextPath}/">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/programmazioni">Programmazione</a></li>
        <li><a href="${pageContext.request.contextPath}/i-miei-biglietti">I Miei Biglietti</a></li>
        <li><a href="${pageContext.request.contextPath}/faq">FAQ</a></li>
      </ul>
    </div>

    <!-- Info -->
    <div class="footer-section">
      <h3>Informazioni</h3>
      <ul>
        <li><a href="${pageContext.request.contextPath}/chi-siamo">Chi Siamo</a></li>
        <li><a href="${pageContext.request.contextPath}/contatti">Contatti</a></li>
        <li><a href="${pageContext.request.contextPath}/privacy">Privacy Policy</a></li>
        <li><a href="${pageContext.request.contextPath}/termini">Termini e Condizioni</a></li>
      </ul>
    </div>

    <!-- Contatti -->
    <div class="footer-section">
      <h3>Contattaci</h3>
      <p>📍 Via Cinema 123, Fisciano (SA)</p>
      <p>📞 +39 089 1234567</p>
      <p>✉️ info@tickema.it</p>
      <p>🕒 Lun-Dom: 10:00 - 23:00</p>
    </div>
  </div>

  <div class="footer-bottom">
    <p>&copy; 2025 Tickema. Tutti i diritti riservati.</p>
    <p style="font-size: 0.9em; opacity: 0.8; margin-top: 5px;">
      Progetto Universitario - Ingegneria del Software | Università di Salerno
    </p>
  </div>
</footer>


