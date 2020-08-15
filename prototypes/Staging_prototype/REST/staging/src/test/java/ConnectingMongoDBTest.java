import com.mongodb.*;
import org.junit.Test;

import java.net.UnknownHostException;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.CoreMatchers.notNullValue;
import static org.junit.Assert.assertThat;

public class ConnectingMongoDBTest {
    @Test
    public void shouldCreateANewMongoClientConnectedToLocalhost() throws Exception {
        // When
        // TODO: get/create the MongoClient
        MongoClient mongoClient = new MongoClient(new MongoClientURI("mongodb://localhost:27017"));

        // Then
        assertThat(mongoClient, is(notNullValue()));
        mongoClient.close();
    }

    @Test
    public void shouldGetADatabaseFromTheMongoClient() throws Exception {
        // Given
        // TODO any setup
        MongoClient mongoClient = new MongoClient(new MongoClientURI("mongodb://localhost:27017"));

        // When
        //TODO get the database from the client
        DB database = mongoClient.getDB("tutorialDB");

        // Then
        assertThat(database, is(notNullValue()));
    }

    @Test
    public void shouldGetACollectionFromTheDatabase() throws Exception {
        // Given
        // TODO any setup
        MongoClient mongoClient = new MongoClient(new MongoClientURI("mongodb://localhost:27017"));
        DB database = mongoClient.getDB("tutorialDB");

        // When
        // TODO get collection
        DBCollection collection = database.getCollection("tutorialcollection");

        // Then
        assertThat(collection, is(notNullValue()));
    }

    @Test(expected = Exception.class)
    public void shouldNotBeAbleToUseMongoClientAfterItHasBeenClosed() throws UnknownHostException {
        // Given
        MongoClient mongoClient = new MongoClient();

        // When
        // TODO close the mongoClient
        mongoClient.close();

        // Then
        mongoClient.getDB("SomeDatabase").getCollection("coll").insert(new BasicDBObject("field", "value"));
    }
}

