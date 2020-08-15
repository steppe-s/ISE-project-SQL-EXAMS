package nl.han.ise.DAO;

import nl.han.ise.DTO.CijferDTO;
import nl.han.ise.REPOSITORY.PropertiesLoader;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CijferDAO_sqlserver {
    private Logger logger = Logger.getLogger(getClass().getName());
    private PropertiesLoader propertiesLoader;

    public CijferDAO_sqlserver() throws IOException {
        propertiesLoader = new PropertiesLoader();
    }

    public List<CijferDTO> findAll() {
        List<CijferDTO> cijfers = new ArrayList<>();
        String query = "SELECT * FROM cijfers";

        getTestData(cijfers, query);
        return cijfers;
    }

    public void getTestData(List<CijferDTO> cijfers, String query) {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        String connectionUrl =
                "jdbc:sqlserver://localhost:1433;"
                        + "database=ise-p-test;"
                        + "user=sa;"
                        + "password=Boterbloem@666;";

        try (Connection connection = DriverManager.getConnection(connectionUrl);
             PreparedStatement preparedStatement = connection.prepareStatement(query);) {

            addNewItemsFromDatabase(cijfers, preparedStatement);

            preparedStatement.close();
            connection.close();

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "hier gaat iets mis " + connectionUrl, e);
        }
    }

    private void addNewItemsFromDatabase(List<CijferDTO> cijfers, PreparedStatement statement) throws SQLException {
        ResultSet resultSet = statement.executeQuery();
        while (resultSet.next()) {
            addNewItemFromResultSet(cijfers, resultSet);
        }
    }

    private void addNewItemFromResultSet(List<CijferDTO> cijfers, ResultSet resultSet) throws SQLException {
        CijferDTO cijfer = new CijferDTO();

        cijfer.setDate(resultSet.getString("datum"));
        cijfer.setCijfer(resultSet.getInt("cijfer"));

        // IMPORTANT
        cijfers.add(cijfer);
    }
}


