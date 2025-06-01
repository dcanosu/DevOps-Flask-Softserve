from flask import redirect, render_template, request, url_for, Blueprint, flash, session
from ..models import Article, db  # Changed Note to Article

articles_bp = Blueprint("articles", __name__, template_folder='../templates')  # Renamed blueprint, added template_folder


@articles_bp.route("/")  # Assuming this will be the new home for articles
def home():
    if "user_id" not in session:
        flash("You must log in to view the articles", "error")
        return redirect(url_for("auth.login"))

    articles = Article.query.all()  # Changed Note to Article
    # We'll need to rename home.html or create a new articles_home.html later
    return render_template("home.html", articles=articles) # Pass articles to template


@articles_bp.route("/create-article", methods=["GET", "POST"])  # Renamed route
def create_article():  # Renamed function
    if "user_id" not in session:
        flash("You must be logged in to create an article.", "error")
        return redirect(url_for("auth.login"))
    if request.method == "POST":
        title = request.form.get("title", "")
        content = request.form.get("content", "")

        if not len(title.strip()) > 5:
            flash("The title is too short, minimum 5 characters", "error")
            return render_template("article_form.html", title=title, content=content) # Template rename

        if not len(content.strip()) > 10:
            flash("The content is too short, minimum 10 characters", "error")
            return render_template("article_form.html", title=title, content=content) # Template rename

        article_db = Article(title=title, content=content)
        # If you add user_id to Article model: article_db.user_id = session["user_id"]
        db.session.add(article_db)
        db.session.commit()
        flash("Article created", "success") # Updated message
        return redirect(url_for("articles.home")) # Updated url_for
    return render_template("article_form.html") # Template rename


@articles_bp.route("/edit-article/<int:id>", methods=["GET", "POST"])  # Renamed route
def edit_article(id):  # Renamed function
    if "user_id" not in session:
        flash("You must be logged in to edit articles.", "error")
        return redirect(url_for("auth.login"))
    article = Article.query.get_or_404(id)  # Changed Note to Article
    # Optional: Check if current user is the author of the article
    # if article.user_id != session["user_id"]:
    #     flash("You are not authorized to edit this article.", "error")
    #     return redirect(url_for("articles.home"))

    if request.method == "POST":
        title = request.form.get("title", "")
        content = request.form.get("content", "")
        article.title = title
        article.content = content
        db.session.commit()
        flash("Article updated", "success") # Updated message
        return redirect(url_for("articles.home")) # Updated url_for

    return render_template("edit_article.html", article=article) # Template rename, pass article


@articles_bp.route("/delete-article/<int:id>", methods=["POST"])  # Renamed route
def delete_article(id):  # Renamed function
    if "user_id" not in session:
        flash("You must be logged in to delete articles.", "error")
        return redirect(url_for("auth.login"))
    article = Article.query.get_or_404(id)  # Changed Note to Article
    # Optional: Check if current user is the author of the article
    # if article.user_id != session["user_id"]:
    #     flash("You are not authorized to delete this article.", "error")
    #     return redirect(url_for("articles.home"))

    db.session.delete(article)
    db.session.commit()
    flash("Article deleted", "success") # Updated message
    return redirect(url_for("articles.home")) # Updated url_for
