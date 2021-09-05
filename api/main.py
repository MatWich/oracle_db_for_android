from my_pkg import create_app
from my_pkg.dao import DAO

app = create_app()

if __name__ == '__main__':
    app.run(debug=True)
    dao = DAO.get_instance()
    dao.end_connection()
