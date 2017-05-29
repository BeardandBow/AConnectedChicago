class Organization < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :type
  has_many :events
  has_many :stories
  has_many :artworks
  has_many :locations, dependent: :destroy
  accepts_nested_attributes_for :locations, reject_if: proc { |attributes| attributes['address'].blank? }
  has_many :organization_neighborhoods
  has_many :neighborhoods, through: :organization_neighborhoods
  has_many :organization_users
  has_many :users, through: :organization_users
end
