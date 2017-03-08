class Neighborhood < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :artworks
  has_many :events
  has_many :stories
  has_many :users
  has_many :organization_neighborhoods
  has_many :organizations, through: :organization_neighborhoods
end
