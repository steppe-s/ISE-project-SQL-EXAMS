import configparser

from pymongo import MongoClient


class MongoRepository(object):
    def __init__(self):
        self.db = None
        self.collection_name = ''

    def mongo_connect(self):
        config = configparser.ConfigParser()
        config.read('config.ini')
        client = MongoClient(config.get('MongoDatabaseSection', 'database.connection_uri'))
        self.db = client[config.get('MongoDatabaseSection', 'database.dbname')]
        self.collection_name = config.get('MongoDatabaseSection', 'database.collection')

    def insert_document(self, document):
        self.mongo_connect()
        collection = self.db[self.collection_name]
        collection.insert_one(document)

    def delete_all_documents_within_collection(self):
        self.mongo_connect()
        collection = self.db[self.collection_name]
        collection.delete_many({})

    def get_document_count(self):
        self.mongo_connect()
        collection = self.db[self.collection_name]
        collection.count_documents({})

    def exists_document(self, index, document):
        self.mongo_connect()
        collection = self.db[self.collection_name]
        query = {}
        for key in index:
            query[key] = document[key]
        if collection.find_one(query) is None:
            return False
        else:
            return True

    def update_document(self, document, index):
        self.mongo_connect()
        collection = self.db[self.collection_name]
        query = {}
        for key in index:
            query[key] = document[key]
        collection.update_one(query, {"$set": document})
