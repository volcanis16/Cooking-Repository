class AddTimeToRecipes < ActiveRecord::Migration[6.0]
  def change
    add_column :recipes, :prep, :string
    add_column :recipes, :cook, :string
  end
end
