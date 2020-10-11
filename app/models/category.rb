class Category < ApplicationRecord
  ## FriendlyId allows user to use the name in place of the ID when entering urls
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates :name, presence: true, uniqueness: true
  has_and_belongs_to_many :recipes, optional: true
  has_and_belongs_to_many :groups, optional: true
end
