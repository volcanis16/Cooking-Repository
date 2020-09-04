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
    @recipes = Recipe.joins(:tags).where('tags.name' => @tag[:name])
    @recipe_count = @recipes.count
  end

end