<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.sgu.Utente" %>

<%
  // SIMULA UN UTENTE LOGGATO PER TESTARE
  Utente utenteTest = new Utente();
  utenteTest.setIdAccount(1);
  utenteTest.setNome("Mario");
  utenteTest.setCognome("Rossi");
  utenteTest.setEmail("mario.rossi@test.it");
  utenteTest.setSaldo(50.00);
  utenteTest.setTipoAccount("Utente Autenticato");

  // Mette l'utente in sessione
  session.setAttribute("utente", utenteTest);

  // Redirect al checkout
  response.sendRedirect(request.getContextPath() + "/acquisto?idProgrammazione=1&numeroBiglietti=2");
%>