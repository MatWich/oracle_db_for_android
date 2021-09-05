import cx_Oracle
import sqlalchemy


class SingletonException(Exception):
    """If somebody will try to create second verision of DAO I will appear"""
    pass


class DAO:
    _instance = None

    @staticmethod
    def get_instance():
        if DAO._instance == None:
            DAO()
        return DAO._instance

    def __init__(self):
        if DAO._instance != None:
            raise SingletonException("This is a singleton class you can't create another instance of this class")
        else:
            DAO._instance = self

        self.conn = cx_Oracle.connect('mat', "123", "XEPDB1")
        self.query = "SELECT SYSDATE FROM DUAL"
        self.page_no = 0
        self.start_pg = 0
        self.pagination_by = 10

    def reset(self):
        """ Reset pagination when user types a new query """
        self.query = "SELECT SYSDATE FROM DUAL"
        self.start_pg = 0
        self.page_no = 0
        self.pagination_by = 10

    def execute_query(self, query: str) -> dict:
        """ Executes a SQL query returns dict """
        c = self.conn.cursor()
        c.execute(query)
        data = {"data": []}

        # insert data into lists
        for row in c:
            data["data"].append(list(row))

        # insert all column names
        data["cols"] = [row[0] for row in c.description]

        return data

    def get_query(self):
        return self.query if len(self.query) > 10 else "SELECT SYSDATE FROM DUAL"

    def end_connection(self) -> None:
        """ ENDS CONNECTION WITH DATABASE """
        self.conn.close()


if __name__ == '__main__':
    dao = DAO.get_instance()
    result = dao.execute_query("SELECT USER, SYSDATE FROM DUAL")
    dao.end_connection()

    print(result)
