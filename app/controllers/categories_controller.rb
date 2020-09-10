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
    @recipes = @category.recipes.order(created_at: :desc).page(params[:page]).per(30)
    @recipe_count = @recipes.count
  end

end