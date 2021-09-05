from flask import Flask


def create_app():
    app = Flask(__name__)
    app.config["SECRET_KEY"] = 'vnrwjcnjwenc'

    from .views import views
    from .auth import auth

    app.register_blueprint(views, url_prefix='/')
    app.register_blueprint(auth, url_prefix='/')

    return app


def decimal_to_str(data: dict) -> dict:
    for tab in data["data"]:
        for ind, item in enumerate(tab):
            tab[ind] = str(tab[ind])

    return data
