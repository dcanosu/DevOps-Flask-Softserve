import unittest

from app import create_app
import unittest
from app import create_app, db
from app.models import Note # Assuming Note is in app.models

class Notetests(unittest.TestCase): # Still inherits from unittest.TestCase
    def setUp(self): # CHANGED: Capital 'U'
        self.app = create_app('ConfigTestConfig') # Assuming 'ConfigTestConfig' is valid
        self.client = self.app.test_client()

        with self.app.app_context():
            db.create_all()

    def tearDown(self): # Good practice to add a tearDown for cleanup
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
