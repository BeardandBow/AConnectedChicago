class Artwork < ApplicationRecord
  validates :title, presence: true
  validates :artist, presence: true
  validates :description, presence: true
  validates :address, presence: true
  enum status: %w(pending approved rejected)
  geocoded_by :address, latitude: :map_lat, longitude: :map_long
  after_validation :geocode
  after_create :set_pkey

  belongs_to :user
  belongs_to :neighborhood
  belongs_to :organization, optional: true

  def path
    "/artworks/#{self.id}"
  end

  def type
    "artwork"
  end

  def set_pkey
    self.update_attributes(pkey: "AR-#{self.id}")
  end

  def approve
    self.update_attributes(status: "approved")
  end

  def reject
    self.update_attributes(status: "rejected")
  end

  def formatted_update_time
    self.updated_at.strftime("%m/%d/%Y %I:%M %p")
  end

  def formatted_create_time
    self.created_at.strftime("%m/%d/%Y %I:%M %p")
  end
end
