package it.unisa.tickema.model;

import com.cloudinary.Cloudinary;
import java.util.Properties;
import java.io.InputStream;

public class CloudinaryConfig {
    private static Cloudinary cloudinary;

    public static Cloudinary getCloudinary() {
        if (cloudinary == null) {
            try (InputStream input = CloudinaryConfig.class.getClassLoader().getResourceAsStream("db.properties")) {
                Properties prop = new Properties();
                if (input == null) throw new RuntimeException("File db.properties non trovato!");
                prop.load(input);

                // Inizializza l'oggetto con l'URL che hai messo nel file properties
                cloudinary = new Cloudinary(prop.getProperty("cloudinary.url"));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return cloudinary;
    }
}