class Unit < ApplicationRecord
  validates :name, precence: true, uniqueness: true
  has_many :ingredient_lists
end
