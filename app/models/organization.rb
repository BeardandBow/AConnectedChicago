class Organization < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :users
  has_many :events
  has_many :organization_neighborhoods
  has_many :neighborhoods, through: :organization_neighborhoods
end
