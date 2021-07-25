class TagsController < ApplicationController
  def index
    @q = Tag.ransack(params[:q])
    @tags = @q.result
              .order(:name)
              .page(params[:page])
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      flash[:notice] = t('.success')
      redirect_to tags_path
    else
      render :new
    end
  end

  def destroy
    tag = Tag.find(params[:id])
    tag.destroy
    redirect_to tags_path
  end

  private

  def tag_params
    params.require(:tag)
          .permit(:name)
  end
end
