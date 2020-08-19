class Unit < ApplicationRecord
  validates :unit, presence: true, uniqueness: true
  has_many :ingredient_lists
end
