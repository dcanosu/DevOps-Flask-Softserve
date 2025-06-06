import unittest
from app import create_app
from app.models import db, Article, User 

class TestNotes(unittest.TestCase):
    def setUp(self):
       
        self.app = create_app('app.config.TestConfig')
        self.client = self.app.test_client()

        with self.app.app_context():
            db.create_all() 
            
            
            user = User.query.filter_by(username="testuser").first()
            if not user:
                user = User(username="testuser", password_hash="testpasswordhash") 
                db.session.add(user)
                db.session.commit()
            
            self.test_user_id = user.id 

    def tearDown(self):
        with self.app.app_context():
            db.session.remove() 

    def test_create_article(self):
        with self.app.app_context():
            
            article = Article(title="Test Article Title", content="This is the content of the test article", user_id=self.test_user_id)
            db.session.add(article)
            db.session.commit()

            retrieved_article = Article.query.first()
            self.assertIsNotNone(retrieved_article) 
            self.assertEqual(retrieved_article.title, "Test Article Title")
            self.assertEqual(retrieved_article.content, "This is the content of the test article")
            self.assertEqual(retrieved_article.user_id, self.test_user_id)