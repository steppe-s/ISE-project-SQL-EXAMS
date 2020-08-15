package nl.han.ise.SERVICES;

        import nl.han.ise.DAO.CijferDAO_sqlserver;
        import nl.han.ise.DTO.CijferDTO;
        import nl.han.ise.DTO.CijferlijstDTO;

        import javax.inject.Inject;
        import java.util.List;

public class CijferService {
    @Inject
    CijferDAO_sqlserver cijferDAO;
    @Inject
    CijferlijstDTO cijferlijstDTO;

    public CijferlijstDTO serviceAllCijfers() {
        List<CijferDTO> returnList = cijferDAO.findAll();

        setLists(returnList);

        return cijferlijstDTO;
    }

    private void setLists(List<CijferDTO> returnList) {
        returnList.forEach(cijferDTO -> cijferlijstDTO.addCijferlijst(cijferDTO));
    }

}