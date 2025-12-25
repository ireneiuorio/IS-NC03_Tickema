package entity.sgu;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Utente {
    private int idAccount;
    private String nome;
    private String cognome;
    private String numeroDiTelefono;
    private String password;
    private String email;
    private double saldo;
    private String tipoAccount;

    public Utente( int idAccount,String nome, String cognome, String numeroDiTelefono, String password, String email, String tipoAccount) {
        this.idAccount=idAccount;
        this.nome = nome;
        this.cognome = cognome;
        this.numeroDiTelefono = numeroDiTelefono;
        this.password = password;
        this.email = email;
        this.tipoAccount = tipoAccount;
    }

    public Utente() {

    }


    public int getIdAccount() {
        return idAccount;
    }

    public void setIdAccount(int idAccount) {
        this.idAccount = idAccount;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCognome() {
        return cognome;
    }

    public void setCognome(String cognome) {
        this.cognome = cognome;
    }

    public String getNumeroDiTelefono() {
        return numeroDiTelefono;
    }

    public void setNumeroDiTelefono(String numeroDiTelefono) {
        this.numeroDiTelefono = numeroDiTelefono;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest digest=MessageDigest.getInstance("SHA-512");
        byte[] hashedPwd =digest.digest(password.getBytes(StandardCharsets.UTF_8));
        StringBuilder builder=new StringBuilder();
        for(byte bit:hashedPwd)
        {
            builder.append(String.format("%02x",bit));
        }
        this.password=builder.toString();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public double getSaldo() {
        return saldo;
    }

    public void setSaldo(double saldo) {
        this.saldo = saldo;
    }

    public String getTipoAccount() {
        return tipoAccount;
    }

    public void setTipoAccount(String tipoAccount) {
        this.tipoAccount = tipoAccount;
    }
}
