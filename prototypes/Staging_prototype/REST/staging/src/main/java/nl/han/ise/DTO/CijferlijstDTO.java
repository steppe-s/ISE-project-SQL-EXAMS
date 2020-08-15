package nl.han.ise.DTO;

import java.util.ArrayList;
import java.util.List;

public class CijferlijstDTO {
    private List<CijferDTO> cijferlijsten = new ArrayList<>();

    public void addCijferlijst(CijferDTO cijferDTO) {
        cijferlijsten.add(cijferDTO);
    }

    public List<CijferDTO> getCijferlijst() {
        return cijferlijsten;
    }
}