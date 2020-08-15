from unittest import TestCase

import mock

from repository.sql_repository import SQLRepository


class TestSQLRepository(TestCase):
    def setUp(self):
        self.repository = SQLRepository()

    @mock.patch.object(SQLRepository, 'execute_sql', return_value=['test'])
    def test_get_answers(self, mocked_execute_sql):
        assert self.repository.get_data() == ['test']
