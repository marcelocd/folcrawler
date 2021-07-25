class ArticlesController < ApplicationController
  before_action :find_article, only: %i[edit update destroy]

  def index
    @q = Article.ransack(search_params[:q])
    @articles = @q.result
                  .order(updated_at: :desc)
                  .page(params[:page])
  end

  def edit
  end

  def update
    if @article.update(article_params)
      flash[:notice] = t('.success')
      redirect_to articles_path
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private

  def article_params
    params.require(:article)
          .permit(tag_ids: [])
  end

  def find_article
    @article = Article.find(params[:id])
  end

  def search_params
    params.permit(:commit, q: [:title_cont, :source_eq, :tag_id_eq]).to_h
  end
end
