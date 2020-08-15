class Recipe < ApplicationRecord
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags
  has_many :ingredients, through: :ingredient_lists
end
