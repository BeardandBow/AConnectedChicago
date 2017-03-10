class Story < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true
  validates :description, presence: true
  validates :body, presence: true
  validates :address, presence: true
  enum status: %w(pending approved rejected)
  geocoded_by :address, latitude: :map_lat, longitude: :map_long
  after_validation :geocode
  after_create :set_pkey

  belongs_to :user
  belongs_to :neighborhood

  def path
    "/stories/#{self.id}"
  end

  def type
    "story"
  end

  def set_pkey
    self.update_attributes(pkey: "ST-#{self.id}")
  end

  def approve
    self.update_attributes(status: "approved")
  end

  def deny
    self.update_attributes(status: "rejected")
  end
end
