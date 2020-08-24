class CategoriesController < ApplicationController
  before_action :set_cat, only: [:show]

  def show

  end

  def index
    @categories = Category.all
  end

  private

  def set_cat
    @category = Category.find(params[:id])
    @recipes = Recipe.joins(:categories).where('categories.name' => @category[:name])
    @recipe_count = @recipes.count
  end

end