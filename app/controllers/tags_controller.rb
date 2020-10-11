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

    # Needed for recipe_preview partial
    @recipe_count = @tag.recipes.count

    # Limit to 30 recipes/page
    @recipes = @tag.recipes.order(:title).page(params[:page]).per(30)
  end

end