class CreateIngredientLists < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredient_lists do |t|
      t.references :recipe
      t.references :ingredient
      t.references :unit
      t.string :amount
      t.string :alt_amount
      t.string :prep

      t.timestamps
    end
    add_foreign_key :ingredient_lists, :recipes
    add_foreign_key :ingredient_lists, :ingredients
    add_foreign_key :ingredient_lists, :units

  end
end
