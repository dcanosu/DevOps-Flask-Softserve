from dotenv import load_dotenv
load_dotenv(".env")

from flask import Flask, request
from .config import Config
from .models import db
from .articles.routes import articles_bp
from .auth.routes import auth_bp


def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)
    db.init_app(app)
    app.register_blueprint(articles_bp)
    app.register_blueprint(auth_bp)

    @app.route("/about")
    def about():
        return "This is a notes app"

    @app.route("/contact", methods=["GET", "POST"])
    def contact():
        if request.method == "POST":
            return "Form submitted successfully", 201
        return "Contact page"

    return app
