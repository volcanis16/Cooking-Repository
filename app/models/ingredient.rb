class Ingredient < ApplicationRecord

  has_many :ingredient_lists, inverse_of: :ingredient
  has_many :recipes, through: :ingredient_list

  accepts_nested_attributes_for :ingredient_lists, allow_destroy: true, reject_if:proc { |att| att['name'].blank? }
end
