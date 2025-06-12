import os

class Config:
    
    DB_USER = os.environ.get('DB_USER', 'flask')
    DB_PASSWORD = os.environ.get('DB_PASSWORD', 'flask')
    DB_HOST = os.environ.get('DB_HOST', '44.201.202.228')
    DB_PORT = os.environ.get('DB_PORT', '5432') # Ensure this is 5432
    DB_NAME = os.environ.get('DB_NAME', 'db_app_flask')

    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABAcd SE_URL') or \
        f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    
    SQLALCHEMY_ENGINE_OPTIONS = {
        "connect_args": {"connect_timeout": 60} 
    }

    
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-key-change-in-production'

class TestConfig(Config):
    TESTING = True
    DB_NAME = os.environ.get('TEST_DB_NAME', 'db_app_flask')
    SQLALCHEMY_DATABASE_URI = os.environ.get('TEST_DATABASE_URL') or \
        f'postgresql://{Config.DB_USER}:{Config.DB_PASSWORD}@{Config.DB_HOST}:{Config.DB_PORT}/{DB_NAME}'

class DevelopmentConfig(Config):
    DEBUG = True

class ProductionConfig(Config):
    DEBUG = False
    