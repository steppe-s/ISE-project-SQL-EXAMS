from unittest import TestCase

import mock
from starlette.testclient import TestClient

from controller.controller import ControllerData
from view.view import app


class TestViewResults(TestCase):
    """test_get_gebeurtenissen test of get_gebeurtenissen de correcte status code teruggeeft"""

    @mock.patch.object(ControllerData, '__init__', return_value=[])
    @mock.patch.object(ControllerData, 'update_data', return_value=[])
    def test_refresh_results(self, mocked_controller_init, mocked_controller_update):
        client = TestClient(app)
        response = client.get("/refresh")
        assert response.status_code == 200

