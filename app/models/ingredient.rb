class Ingredient < ApplicationRecord

  has_many :ingredient_lists, inverse_of: :ingredient
  has_many :recipes, through: :ingredient_list
end
