from repository.mongo_repository import MongoRepository
from repository.sql_repository import SQLRepository


class ControllerData(object):

    def __init__(self):
        self.sql_repository = SQLRepository()
        self.mongo_repository = MongoRepository()
        self.index = ['exam_id']

    def update_data(self):
        # get SQL results
        sql_results = self.sql_repository.get_data()
        # insert into mongoDB
        for document in sql_results:
            if self.mongo_repository.exists_document(self.index, document):
                self.mongo_repository.update_document(document, self.index)
            else:
                self.mongo_repository.insert_document(document)
        return [len(sql_results)]
