class ArticlesController < ApplicationController
  before_action :find_article, only: %i[show destroy]

  def index
    @q = Article.ransack(params[:q])
    @articles = @q.result
                  .order(updated_at: :desc)
                  .page(params[:page])
  end

  def show
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private

  def find_article
    @article = Article.find_by(id: params[:id])
  end
end
