import unittest
from app import create_app
from app.models import db, Article # CHANGED: Import Article instead of Note

class TestNotes(unittest.TestCase):
    def setUp(self):
        self.app = create_app('ConfigTestConfig')
        self.client = self.app.test_client()

        with self.app.app_context():
            db.create_all()

    def tearDown(self):
        with self.app.app_context():
            db.session.remove()
            db.drop_all()

    def test_create_article(self): # Optional: Rename test method to reflect Article
        with self.app.app_context():
            # Use Article model now
            article = Article(title="Test Article Title", content="This is the content of the test article", user_id=1) # Note: user_id is required for Article
            db.session.add(article)
            db.session.commit()

            # Query for the Article
            retrieved_article = Article.query.first()
            self.assertEqual(retrieved_article.title, "Test Article Title")
            self.assertEqual(retrieved_article.content, "This is the content of the test article")
            self.assertEqual(retrieved_article.user_id, 1)

            # You might want to add a test for user creation as well since Article requires a user_id
            # Example:
            # user = User(username="testuser", password_hash="hashedpassword")
            # db.session.add(user)
            # db.session.commit()
            # self.assertEqual(retrieved_article.author.username, "testuser") # Test relationship