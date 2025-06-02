from . import app  # Import the app instance from __init__.py
from .models import db, Category # Import db and Category from models.py

if __name__ == "__main__":
    with app.app_context():
        print("Populating default categories (assuming tables are created by migrations)...")
        # Add default categories
        default_categories = ["Technology", "Science", "Travel", "Food", "Lifestyle", "Business"]
        for cat_name in default_categories:
            category = Category.query.filter_by(name=cat_name).first()
            if not category:
                new_category = Category(name=cat_name)
                db.session.add(new_category)
        
        if default_categories: # only commit if there were categories to potentially add
            db.session.commit()
            print(f"{len(default_categories)} default categories processed.")
        