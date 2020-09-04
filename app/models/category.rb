class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates :name, presence: true, uniqueness: true
  has_and_belongs_to_many :recipes, optional: true
end
