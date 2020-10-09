class AddRatingToRecipes < ActiveRecord::Migration[6.0]
  def change
    add_column :recipes, :rating, :float
  end
end
