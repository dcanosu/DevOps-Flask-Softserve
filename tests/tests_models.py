import unittest
from app import create_app
from app.models import db, Note # CHANGED: Import db from app.models, and keep Note

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

    def test_create_note(self):
        with self.app.app_context():
            note = Note(title="title", content="content")
            db.session.add(note)
            db.session.commit()

            note = Note.query.first()
            self.assertEqual(note.title, "title")
            self.assertEqual(note.content, "content")