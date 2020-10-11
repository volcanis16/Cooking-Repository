class Group < ApplicationRecord
  ## FriendlyId allows user to use the name in place of the ID when entering urls
  extend FriendlyId
  has_and_belongs_to_many :categories, optional: true
  has_and_belongs_to_many :tags, optional: true
  friendly_id :name, use: :slugged
end
