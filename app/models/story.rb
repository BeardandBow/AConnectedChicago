class Story < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true
  validates :description, presence: true
  validates :body, presence: true
  validates :address, presence: true

  enum status: %w(pending approved rejected)

  mount_uploader :image, ImageUploader

  geocoded_by :address, latitude: :map_lat, longitude: :map_long
  before_validation :geocode
  before_validation :find_neighborhood
  after_create :set_pkey

  belongs_to :user
  belongs_to :neighborhood
  belongs_to :organization, optional: true

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

  def reject
    self.update_attributes(status: "rejected")
  end

  def formatted_update_time
    self.updated_at.strftime("%m/%d/%Y %I:%M %p")
  end

  def formatted_create_time
    self.created_at.strftime("%m/%d/%Y %I:%M %p")
  end

  def find_neighborhood
    hoods = Neighborhood.all
    hood = hoods.find do |hood|
      hood.has?(self.map_lat.to_f, self.map_long.to_f)
    end
    self.neighborhood = hood
  end
end
