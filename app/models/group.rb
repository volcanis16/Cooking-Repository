class Group < ApplicationRecord
  has_and_belongs_to_many :categories, optional: true
  has_and_belongs_to_many :tags, optional: true
end
