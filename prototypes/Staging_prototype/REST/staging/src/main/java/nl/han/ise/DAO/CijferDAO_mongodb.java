package nl.han.ise.DAO;

import com.mongodb.*;
import nl.han.ise.REPOSITORY.PropertiesLoader;

import java.io.IOException;
import java.net.UnknownHostException;
import java.util.logging.Logger;

public class CijferDAO_mongodb {
    private Logger logger = Logger.getLogger(getClass().getName());
    private PropertiesLoader propertiesLoader;

    public CijferDAO_mongodb() throws IOException {
        propertiesLoader = new PropertiesLoader();
    }

    public void writeCijfers(String json) throws UnknownHostException {
        System.out.println("Hello world!");

            MongoClient mongoClient = new MongoClient(new MongoClientURI("mongodb://localhost:27017"));
            DB database = mongoClient.getDB("tutorialDB");
            DBCollection collection = database.getCollection("cijfers");

        // 1. BasicDBObject example
        System.out.println("BasicDBObject example...");
        BasicDBObject document = new BasicDBObject();
        document.put("database", "CijferlijstenDB");
        document.put("table",  json);
        collection.insert(document);

        DBCursor cursorDoc = collection.find();
        while (cursorDoc.hasNext()) {
            System.out.println(cursorDoc.next());
        }

        // Removes and closes the connection !
        collection.remove(new BasicDBObject());
        mongoClient.close();
    }

    public void readCijfers() {

    }

}
