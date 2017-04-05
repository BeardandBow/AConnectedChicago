class Event < ApplicationRecord
  validates :title, presence: true
  validates :host_contact, presence: true
  validates_format_of :host_contact, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create, message: "please use a valid email for the host."
  validates :description, presence: true
  validates :date, presence: true
  validates :time, presence: true
  validates :address, presence: true
  validates :event_type, presence: true

  enum status: %w(pending approved rejected)

  mount_uploader :image, ImageUploader

  geocoded_by :address, latitude: :map_lat, longitude: :map_long
  before_validation :geocode
  before_validation :find_neighborhood
  after_create :format_date_time
  after_create :set_pkey

  belongs_to :user
  belongs_to :organization
  belongs_to :neighborhood, optional: true

  def path
    "/events/#{self.id}"
  end

  def type
    "event"
  end

  def set_pkey
    self.update_attributes(pkey: "EV-#{self.id}")
  end

  def approve
    self.update_attributes(status: "approved")
  end

  def reject
    self.update_attributes(status: "rejected")
  end


  def formatted_create_time
    self.created_at.strftime("%m/%d/%Y %I:%M %p")
  end

  def find_neighborhood
    neighborhood = Neighborhood.find do |hood|
      hood.has?(self.map_lat.to_f, self.map_long.to_f)
    end
    self.assign_attributes(neighborhood: neighborhood)
  end
end

private

  def format_date_time
    self.update_attributes(formatted_date_time: "#{self.date.strftime("%A, %B %e, %Y")} at #{self.time.strftime("%I:%M %p")}")
  end
