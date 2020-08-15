class AddAltUnitIdtoIngredientList < ActiveRecord::Migration[6.0]
  def change
    add_column :ingredient_lists, :alt_unit_id, :integer
  end
end
