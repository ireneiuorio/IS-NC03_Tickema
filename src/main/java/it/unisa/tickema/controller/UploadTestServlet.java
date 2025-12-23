package it.unisa.tickema.controller;

import com.cloudinary.utils.ObjectUtils;
import it.unisa.tickema.model.CloudinaryConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.util.Map;

@WebServlet("/upload-test")
@MultipartConfig // Serve per gestire i file inviati dal form
public class UploadTestServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Prendi il file dal form
        Part filePart = request.getPart("foto");

        if (filePart != null && filePart.getSize() > 0) {
            try {
                // Trasforma il file in un formato che Cloudinary capisce
                byte[] fileBytes = filePart.getInputStream().readAllBytes();

                // MANDA IL FILE SU CLOUDINARY!
                Map uploadResult = CloudinaryConfig.getCloudinary().uploader().upload(fileBytes, ObjectUtils.emptyMap());

                // Prendi l'URL della foto caricata
                String urlFoto = (String) uploadResult.get("url");

                response.getWriter().println("<h1>CARICAMENTO RIUSCITO!</h1>");
                response.getWriter().println("<p>La tua foto e' online qui: <a href='" + urlFoto + "'>" + urlFoto + "</a></p>");
                response.getWriter().println("<img src='" + urlFoto + "' width='300'>");

            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("Errore durante l'upload: " + e.getMessage());
            }
        } else {
            response.getWriter().println("Nessun file selezionato.");
        }
    }
}