class CategoriesController < ApplicationController
  before_action :set_cat, only: [:show]

  def show
  end

  def index
    @categories = Category.all.order(:name)
  end

  private

  def set_cat
    @category = Category.friendly.find(params[:id])

    # Needed for recipe_preview partial
    @recipe_count = @category.recipes.count

    # Limit to 30 recipes/page
    @recipes = @category.recipes.order(:title).page(params[:page]).per(30)
  end

end