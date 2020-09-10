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
    @recipes = @tag.recipes.order(created_at: :desc).page(params[:page]).per(30)
    @recipe_count = @recipes.count
  end

end