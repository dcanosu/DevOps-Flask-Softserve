from . import app  # Import the app instance from __init__.py
from .models import db # Import db from models.py

if __name__ == "__main__":
    with app.app_context():
        db.create_all()
        print("Tables created successfully")
        