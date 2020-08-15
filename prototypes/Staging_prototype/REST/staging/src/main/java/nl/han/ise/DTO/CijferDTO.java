package nl.han.ise.DTO;

import java.sql.Date;

public class CijferDTO {
    private String datum;
    private int cijfer;

    public void setDate(String datum) {
        this.datum = datum;
    }

    public String getDatum() {
        return datum;
    }

    public void setCijfer(int cijfer) {
        this.cijfer = cijfer;
    }

    public int getCijfer() {
        return cijfer;
    }
}
