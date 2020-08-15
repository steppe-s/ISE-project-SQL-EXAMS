package nl.han.ise.REPOSITORY;

import java.io.FileInputStream;
import javax.enterprise.inject.Default;
import java.io.IOException;
import java.util.Properties;

@Default
public class PropertiesLoader {
    private String jdbcString;
    private String userName;
    private String password;

    public PropertiesLoader() throws IOException {
        Properties databaseProperties = new Properties();
        databaseProperties.load(new FileInputStream("C:\\Users\\soffe\\Documents\\POINTBREAK\\Instance Studio\\SITES\\staging\\src\\main\\resources\\database.properties"));
        jdbcString = databaseProperties.getProperty("jdbc.url");
        userName = databaseProperties.getProperty("jdbc.user");
        password = databaseProperties.getProperty("jdbc.pass");
    }

    public String getJdbcString() {
        return jdbcString;
    }

    public String getUserName() {
        return userName;
    }

    public String getPassword() {
        return password;
    }
}
