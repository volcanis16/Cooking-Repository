class IngredientList < ApplicationRecord
  validates :amount, :alt_amount, length: {maximum: 5}
  belongs_to :recipe, optional: true
  validates :recipe, presence: true

  belongs_to :ingredient, optional: true
  validates :ingredient, presence: true

  belongs_to :unit
  belongs_to :alt_unit, class_name: "Unit"
end
