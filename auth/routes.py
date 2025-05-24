from flask import Blueprint, flash, redirect, render_template, request, session, url_for

auth_bp = Blueprint("auth", __name__)


@auth_bp.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form["username"]
        if username == "admin":
            session["user"] = username
            return redirect(url_for("notes.home"))
        else:
            flash("User not allow", "error")
    return render_template("login.html")


@auth_bp.route("/logout")
def logout():
    session.pop("user", None)
    flash("Logout success", "success")
    return redirect(url_for("auth.login"))
