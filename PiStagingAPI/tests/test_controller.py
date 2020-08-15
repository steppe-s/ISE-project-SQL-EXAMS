from unittest import TestCase

import mock

from controller.controller import ControllerData
from repository.mongo_repository import MongoRepository
from repository.sql_repository import SQLRepository


class TestControllerResults(TestCase):
    def setUp(self):
        self.controller = ControllerData()

    @mock.patch.object(SQLRepository, 'get_data', return_value=['test'])
    @mock.patch.object(MongoRepository, 'exists_document', return_value=True)
    @mock.patch.object(MongoRepository, 'update_document', return_value=[])
    @mock.patch.object(MongoRepository, 'insert_document', return_value=[])
    def test_update_answers_exists(self,
                            mocked_repo_insert_document,
                            mocked_repo_update_document,
                            mocked_repo_exists,
                            mocked_repo_get_answers):
        # Act
        assert self.controller.update_data() == [1]
        # Assert
        mocked_repo_get_answers.assert_called()
        mocked_repo_exists.assert_called_with(self.controller.index, 'test')
        mocked_repo_update_document.assert_called_with('test', self.controller.index)

    @mock.patch.object(SQLRepository, 'get_data', return_value=['test'])
    @mock.patch.object(MongoRepository, 'exists_document', return_value=False)
    @mock.patch.object(MongoRepository, 'update_document', return_value=[])
    @mock.patch.object(MongoRepository, 'insert_document', return_value=[])
    def test_update_answers_not_exists(self,
                            mocked_repo_insert_document,
                            mocked_repo_update_document,
                            mocked_repo_exists,
                            mocked_repo_get_answers):
        # Act
        assert self.controller.update_data() == [1]
        # Assert
        mocked_repo_get_answers.assert_called()
        mocked_repo_exists.assert_called_with(self.controller.index, 'test')
        mocked_repo_insert_document.assert_called_with('test')
