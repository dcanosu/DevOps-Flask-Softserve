import os

class Config:
    # Database - usando variables de entorno
    DB_USER = os.environ.get('DB_USER', 'flask_user')
    DB_PASSWORD = os.environ.get('DB_PASSWORD', 'flask_password')
    DB_HOST = os.environ.get('DB_HOST', 'localhost')
    DB_PORT = os.environ.get('DB_PORT', '5432')
    DB_NAME = os.environ.get('DB_NAME', 'flask_notes_db')
    
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # Security
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-key-change-in-production'

class TestConfig(Config):
    TESTING = True
    DB_NAME = os.environ.get('TEST_DB_NAME', 'flask_test_db')
    SQLALCHEMY_DATABASE_URI = os.environ.get('TEST_DATABASE_URL') or \
        f'postgresql://{Config.DB_USER}:{Config.DB_PASSWORD}@{Config.DB_HOST}:{Config.DB_PORT}/{DB_NAME}'

class DevelopmentConfig(Config):
    DEBUG = True

class ProductionConfig(Config):
    DEBUG = False
    