<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Test Upload Cloudinary</title>
</head>
<body>
<h2>Prova a caricare una foto!</h2>
<form action="upload-test" method="post" enctype="multipart/form-data">
  <input type="file" name="foto" accept="image/*">
  <button type="submit">Carica su Cloudinary</button>
</form>
</body>
</html>