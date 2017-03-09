class Artwork < ApplicationRecord
  validates :title, presence: true
  validates :artist, presence: true
  validates :description, presence: true
  validates :address, presence: true
  enum status: %w(pending approved rejected)
  geocoded_by :address, latitude: :map_lat, longitude: :map_long
  after_validation :geocode

  belongs_to :user
  belongs_to :neighborhood

  def path
    "/artworks/#{self.id}"
  end
end
