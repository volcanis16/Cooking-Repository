class Group < ApplicationRecord
  extend FriendlyId
  has_and_belongs_to_many :categories, optional: true
  has_and_belongs_to_many :tags, optional: true
  friendly_id :name, use: :slugged
end
