class TagsController < ApplicationController
  before_action :set_tag, only: [:show]

  def show
  end

  def index
    @tags = Tag.all
  end

  private

  def set_tag
    @tag = Tag.friendly.find(params[:id])
    @recipe_count = @tag.recipes.count
    @recipes = @tag.recipes.order(:title).page(params[:page]).per(30)
  end

end