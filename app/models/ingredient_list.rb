class IngredientList < ApplicationRecord
  belongs_to :recipe
  validates :recipe, presence: true
  belongs_to :ingredient
  validates :ingredient, presence: true
  belongs_to :unit
  belongs_to :alt_unit, class_name: "Unit"
end
