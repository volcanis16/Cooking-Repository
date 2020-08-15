class Recipe < ApplicationRecord
  validates :title, presence: true
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags
  has_many :ingredient_lists, inverse_of :recipe
  has_many :ingredients, through: :ingredient_lists
end
