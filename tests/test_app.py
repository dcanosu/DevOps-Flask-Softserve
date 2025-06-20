import pytest
from app import create_app
from app.config import TestConfig

def test_create_app_with_test_config():
    """Test that the create_app factory:
    1. Creates an app instance successfully.
    2. Uses the TestConfig when provided.
    3. Sets app.testing to True.
    4. Configures the correct test database URI.
    """
    app = create_app(TestConfig)

    assert app is not None
    assert app.testing is True
    assert app.config['TESTING'] is True
    assert TestConfig.DB_NAME in app.config['SQLALCHEMY_DATABASE_URI']
    # More specific check for the database URI if needed
    expected_db_uri_part = f"postgresql://{TestConfig.DB_USER}:{TestConfig.DB_PASSWORD}@{TestConfig.DB_HOST}:{TestConfig.DB_PORT}/{TestConfig.DB_NAME}"
    assert expected_db_uri_part == app.config['SQLALCHEMY_DATABASE_URI']
