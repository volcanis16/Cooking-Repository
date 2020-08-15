class Ingredient < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :ingredient_lists, inverse_of :ingredient
  has_many :recipes, through: :ingredient_list
end
