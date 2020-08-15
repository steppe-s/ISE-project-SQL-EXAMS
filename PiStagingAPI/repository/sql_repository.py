import configparser
import pyodbc
import json


class SQLRepository(object):

    def db_connect(self):
        config = configparser.ConfigParser()
        config.read('config.ini')

        # connection voor windows verification. Als je gebruikt maakt van SQL user en password gebruik andere
        # connection string/
        connection_string = 'Driver={' + config.get('SQLDatabaseSection', 'database.driver') + '};Server=' + config.get(
            'SQLDatabaseSection', 'database.host') + ';Database=' + config.get('SQLDatabaseSection',
                                                                            'database.dbname') + ';Trusted_Connection=yes;'
        # connection_string = 'Driver={'+config.get('DatabaseSection', 'database.driver')+'};Server='+config.get(
        # 'DatabaseSection', 'database.host')+';Database='+config.get('DatabaseSection',
        # 'database.dbname')+';UID='+config.get('DatabaseSection', 'database.user')+';PWD='+config.get(
        # 'DatabaseSection', 'database.password')+';'
        conn = pyodbc.connect(connection_string)
        return conn

    def execute_sql(self, statement):
        conn = self.db_connect()
        cursor = conn.cursor()
        cursor.execute(statement)
        return json.loads(cursor.fetchone()[0])

    def get_data(self):
        return self.execute_sql('EXECUTE pr_select_results_into_json')
