class Neighborhood < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :artworks
  has_many :events
  has_many :stories
end
