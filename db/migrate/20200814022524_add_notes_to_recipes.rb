class AddNotesToRecipes < ActiveRecord::Migration[6.0]
  def change
    add_column :recipes, :notes, :text
  end
end
