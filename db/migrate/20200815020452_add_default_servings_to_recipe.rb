class AddDefaultServingsToRecipe < ActiveRecord::Migration[6.0]
  def change
    add_column :recipes, :default_servings, :integer
  end
end
