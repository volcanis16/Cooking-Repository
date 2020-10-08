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
    @recipe_count = @category.recipes.count
    @recipes = @category.recipes.order(:title).page(params[:page]).per(30)
  end

end