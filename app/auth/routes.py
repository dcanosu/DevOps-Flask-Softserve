from flask import Blueprint, flash, redirect, render_template, request, session, url_for, current_app
from ..models import db, User  # Import db and User model

auth_bp = Blueprint("auth", __name__)


@auth_bp.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")

        if not username or not password:
            flash("Username and password are required.", "error")
            return render_template("register.html")

        existing_user = User.query.filter_by(username=username).first()
        if existing_user:
            flash("Username already exists. Please choose a different one.", "error")
            return render_template("register.html")

        new_user = User(username=username)
        new_user.set_password(password)
        with current_app.app_context():
            db.session.add(new_user)
            db.session.commit()
        
        flash("Registration successful! Please log in.", "success")
        return redirect(url_for("auth.login"))
    return render_template("register.html")


@auth_bp.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")

        if not username or not password:
            flash("Username and password are required.", "error")
            return render_template("login.html")

        user = User.query.filter_by(username=username).first()

        if user and user.check_password(password):
            session["user_id"] = user.id  # Store user_id in session
            flash("Login successful!", "success")
            return redirect(url_for("articles.home"))
        else:
            flash("Invalid username or password.", "error")
    return render_template("login.html")


@auth_bp.route("/logout")
def logout():
    session.pop("user_id", None)  # Clear user_id from session
    flash("Logout success", "success")
    return redirect(url_for("auth.login"))
