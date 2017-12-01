class Location < ApplicationRecord
  validates :address, presence: true

  belongs_to :organization, optional: false
  belongs_to :neighborhood, optional: false

  geocoded_by :address, latitude: :map_lat, longitude: :map_long
  before_validation :geocode
  before_validation :find_neighborhood

  def find_neighborhood
    hoods = Neighborhood.all
    neighborhood = hoods.find do |hood|
      hood.has?(self.map_lat.to_f, self.map_long.to_f)
    end
    self.assign_attributes(neighborhood: neighborhood)
  end
end
