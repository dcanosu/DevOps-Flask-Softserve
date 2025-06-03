# 🚀 devops-flask

Welcome to the **devops-flask** project.  
Follow these steps to easily set up and run the local environment.

---

## 🛠️ Local Environment Setup

Follow these steps to set up and run the project locally:

### 1. Prerequisites
- Python 3.7+ installed.
- PostgreSQL server installed and running.

### 2. Clone the Repository
```bash
git clone https://github.com/dcanosu/DevOps-Flask-Softserve # Or your fork
cd DevOps-Flask-Softserve
```

### 3. Create and Activate Virtual Environment
```bash
python3 -m venv venv
source venv/bin/activate
```

### 4. Configure Environment Variables
The application uses a `.env` file to manage sensitive configuration like database credentials and the Flask secret key.

First, copy the example file:
```bash
cp .env.example .env
```
Now, open the newly created `.env` file and configure the following variables:

- **`SECRET_KEY`**: This is used by Flask to keep client-side sessions secure. The example file provides a placeholder. For local development, it's okay to use it as is, but **for production, you must change this to a unique, long, and random string.**

- **`DATABASE_URL`**: This is the connection string for your PostgreSQL database. 
  - The required format is: `postgresql://YOUR_DB_USER:YOUR_DB_PASSWORD@YOUR_DB_HOST:YOUR_DB_PORT/YOUR_DB_NAME`
  - Replace `YOUR_DB_USER`, `YOUR_DB_PASSWORD`, `YOUR_DB_HOST`, `YOUR_DB_PORT`, and `YOUR_DB_NAME` with your actual PostgreSQL credentials and database details.
  - For a typical local setup, `YOUR_DB_HOST` is `localhost` and `YOUR_DB_PORT` is `5432`.
  - **Important:** Ensure the database (`YOUR_DB_NAME`) already exists in your PostgreSQL server before proceeding to the next steps. You might need to create it manually (e.g., using the `createdb YOUR_DB_NAME` command in your terminal if you have PostgreSQL client tools installed).

*The `.env.example` file also shows commented-out individual database components (`DB_USER`, `DB_PASSWORD`, etc.). If `DATABASE_URL` is set, these individual components are typically ignored by the application's configuration.*

### 5. Install Dependencies
With the virtual environment activated, install the required Python packages:
```bash
pip install -r requirements.txt
```

### 6. Apply Database Migrations & Create Tables
This project uses Flask-Migrate to manage database schema changes. The necessary migration scripts are included in the repository.

To set up your database tables:

1.  Ensure your PostgreSQL server is running and that the database specified in your `.env` file exists (you might need to create it manually, e.g., using `createdb YOUR_DB_NAME` if you have PostgreSQL client tools).

2.  Set the `FLASK_APP` environment variable (if not already set for your terminal session):
    ```bash
    export FLASK_APP=app.py # Or the appropriate path to your Flask app instance
    ```

3.  Apply the migrations to create the tables in your database:
    ```bash
    flask db upgrade
    ```
    *(This command applies all pending migrations. Since you've just cloned the repo, it will set up the initial schema based on the committed migration scripts.)*

### 7. Populate Default Categories
After the tables are created, run the script to populate default categories:
```bash
python -m app.create_db
```

### 8. Run the Application
Set the necessary Flask environment variables and run the development server:
```bash
export FLASK_APP=app.py && export FLASK_DEBUG=1 && flask run
```
The application will typically be available at `http://127.0.0.1:5000`.

## ✨ Features

- User registration and login.
- Create, view, edit, and delete articles.
- Public, user public and private articles.
- Article categories.
- Modern UI with Tailwind CSS, featuring a teal color scheme and square corners.
- Activity calendar displaying article creation frequency.

## 🚧 Future Enhancements

- **Implement Database Migrations:**  
  Integrate Flask-Migrate (Alembic) to manage database schema changes without data loss.
- **Advanced Article Filtering/Searching:**  
  Allow users to filter articles by date (via calendar interaction), category, or search by keywords.
- **User Profile Management:**  
  Allow users to update their profile information.
- **Testing:**  
  Implement unit and integration tests.