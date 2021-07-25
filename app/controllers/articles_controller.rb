class ArticlesController < ApplicationController
  before_action :find_article, only: %i[show destroy]

  def index
    # byebug
    @q = Article.ransack(search_params[:q])
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

  def search_params
    params.permit(:commit, q: [:title_cont, :source_eq]).to_h
  end
end
