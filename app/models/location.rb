class Location < ApplicationRecord
  validates :address, presence: true

  belongs_to :organization
  belongs_to :neighborhood

  geocoded_by :address, latitude: :map_lat, longitude: :map_long
  before_validation :geocode
  before_validation :find_neighborhood

  def find_neighborhood
    neighborhood = Neighborhood.find do |hood|
      hood.has?(self.map_lat.to_f, self.map_long.to_f)
    end
    self.assign_attributes(neighborhood: neighborhood)
  end
end