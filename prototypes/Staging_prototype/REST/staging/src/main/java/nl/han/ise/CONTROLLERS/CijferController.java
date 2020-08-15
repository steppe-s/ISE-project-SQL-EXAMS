package nl.han.ise.CONTROLLERS;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;
import jdk.jfr.ContentType;
import nl.han.ise.DAO.CijferDAO_mongodb;
import nl.han.ise.DTO.CijferlijstDTO;
import nl.han.ise.SERVICES.CijferService;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.io.IOException;

@Path("/")
public class CijferController {
    private CijferService cijferService;

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response allPlaylists() throws IOException {

        CijferlijstDTO all = cijferService.serviceAllCijfers();

        CijferDAO_mongodb sut = new CijferDAO_mongodb();

        ObjectWriter objectMapper = new ObjectMapper().writer().withDefaultPrettyPrinter();
        String json = objectMapper.writeValueAsString(all);
        sut.writeCijfers(json);

        return Response.ok(all).build();
    }

    @Inject
    public void setCijferService(CijferService cijferService) {
        this.cijferService = cijferService;
    }

}