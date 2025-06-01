from flask import redirect, render_template, request, url_for, Blueprint, flash, session
from ..models import Article, db, Category # Changed Note to Article, added Category

articles_bp = Blueprint("articles", __name__, template_folder='../templates')  # Renamed blueprint, added template_folder


@articles_bp.route("/")  # Assuming this will be the new home for articles
def home():
    # Fetch all articles, ordered by creation date (newest first)
    # We can add a .limit(X) here if we want to show fewer to non-logged-in users later
    articles = Article.query.order_by(Article.created_at.desc()).all()
    return render_template("home.html", articles=articles)


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
            categories_from_db = Category.query.all()
            return render_template("article_form.html", title=title, content=content, categories=categories_from_db) # Template rename

        selected_category_ids = request.form.getlist('categories')
        if not selected_category_ids:
            flash("Please select at least one category.", "error")
            categories_from_db = Category.query.all()
            return render_template("article_form.html", title=title, content=content, categories=categories_from_db)

        article_db = Article(title=title, content=content, user_id=session['user_id'])
        
        if selected_category_ids:
            for cat_id in selected_category_ids:
                category = Category.query.get(int(cat_id))
                if category:
                    article_db.categories.append(category)
        
        db.session.add(article_db)
        db.session.commit()
        flash("Article created", "success") # Updated message
        return redirect(url_for("articles.home")) # Updated url_for
    categories_from_db = Category.query.all()
    return render_template("article_form.html", categories=categories_from_db) # Template rename


@articles_bp.route("/edit-article/<int:id>", methods=["GET", "POST"])  # Renamed route
def edit_article(id):  # Renamed function
    if "user_id" not in session:
        flash("You must be logged in to edit articles.", "error")
        return redirect(url_for("auth.login"))
    article = Article.query.get_or_404(id)  # Changed Note to Article
    if article.user_id != session['user_id']:
        flash("You are not authorized to edit this article.", "error")
        return redirect(url_for("articles.home"))

    if request.method == "POST":
        title = request.form.get("title", "")
        content = request.form.get("content", "")
        article.title = title
        article.content = content

        selected_category_ids = request.form.getlist('categories')
        if not selected_category_ids:
            flash("Please select at least one category.", "error")
            all_categories = Category.query.all()
            # Pass the current article and all categories back to the template
            return render_template("edit_article.html", article=article, categories=all_categories)

        # Clear existing categories and add new ones
        article.categories.clear() 
        if selected_category_ids:
            for cat_id in selected_category_ids:
                category = Category.query.get(int(cat_id))
                if category:
                    article.categories.append(category)

        db.session.commit()
        flash("Article updated", "success") # Updated message
        return redirect(url_for("articles.home")) # Updated url_for

    all_categories = Category.query.all()
    return render_template("edit_article.html", article=article, categories=all_categories) # Template rename, pass article and all categories



@articles_bp.route("/my-articles")
def my_articles():
    if 'user_id' not in session:
        flash("Please log in to view your articles.", "error")
        return redirect(url_for('auth.login'))
    
    user_articles = Article.query.filter_by(user_id=session['user_id']).order_by(Article.created_at.desc()).all()
    return render_template("my_articles.html", articles=user_articles)


@articles_bp.route("/delete-article/<int:id>", methods=["POST"])  # Renamed route
def delete_article(id):  # Renamed function
    if "user_id" not in session:
        flash("You must be logged in to delete articles.", "error")
        return redirect(url_for("auth.login"))
    article = Article.query.get_or_404(id)  # Changed Note to Article
    if article.user_id != session['user_id']:
        flash("You are not authorized to delete this article.", "error")
        return redirect(url_for("articles.home"))

    db.session.delete(article)
    db.session.commit()
    flash("Article deleted", "success") # Updated message
    return redirect(url_for("articles.home")) # Updated url_for
