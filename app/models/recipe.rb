class Recipe < ApplicationRecord
  validates :title, presence: true
  validates :default_servings, length: {maximum: 2}

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags

  has_many :ingredient_lists, inverse_of: :recipe
  has_many :ingredients, through: :ingredient_lists
  
  accepts_nested_attributes_for :ingredients
  accepts_nested_attributes_for :tags, allow_destroy: true
  accepts_nested_attributes_for :categories, allow_destroy: true
end
