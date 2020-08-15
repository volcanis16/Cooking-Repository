class IngredientList < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  belongs_to :unit
  belongs_to :alt_unit, class_name: "Unit"
end
