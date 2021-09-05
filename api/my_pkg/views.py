from flask import Blueprint, render_template, request, url_for

from my_pkg import decimal_to_str
from my_pkg.dao import DAO

views = Blueprint('views', __name__)


@views.route('/', methods=['GET', 'POST'])
def home():
    result = None
    if request.method == "POST":
        dao = DAO.get_instance()
        if request.form.get('submit') == 'Submit':
            result = True
            dao.reset()

            query = str(request.form.get('query', None))
            pagination_by = request.form.get('pagination', None)

            if pagination_by:
                dao.pagination_by = abs(int(pagination_by))
            if query is None or query == '':
                dao.query = "SELECT USER FROM DUAL"
            else:
                dao.query = query
        json = dao.execute_query(dao.get_query())
        amount = len(json["data"])
        how_many = dao.pagination_by
        start = dao.start_pg
        pages_amount = int(amount / how_many) + 1
        data = json["data"]
        cols = json["cols"]

        for i in range(0, pages_amount):
            if request.form.get(f"page{i}") == f"{i}":
                result = True
                new_start = start + how_many * i
                new_how_many = how_many

                if new_start + how_many > amount:
                    new_how_many = abs(amount - (new_start + how_many))
                # Pagination render
                return render_template('home.html', result=result, headers=cols, data=data, start=new_start, how_many=new_how_many, pages_amount=pages_amount)
        # Submit render
        return render_template('home.html', result=result, headers=cols, data=data, start=start, how_many=how_many, pages_amount=pages_amount)
    # Welcoming render
    return render_template('home.html', result=result)


@views.route('json/<query>', methods=["GET"])
def json(query):
    dao = DAO.get_instance()
    dao.query = str(query)
    data = dao.execute_query(dao.get_query())
    return decimal_to_str(data)
