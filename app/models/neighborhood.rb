class Neighborhood < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  serialize :bounds
  after_validation :geocode_location

  has_many :artworks
  has_many :events
  has_many :stories
  has_many :users
  has_many :organization_neighborhoods
  has_many :organizations, through: :organization_neighborhoods

  def has?(lat, long)
    lat.between?(self.bounds[1]["lat"], self.bounds[0]["lat"]) && long.between?(self.bounds[1]["long"], self.bounds[0]["long"])
  end

  private

    def geocode_location
      if self.bounds.empty?
        puts "Geocoding #{self.name}"
        response = Geocoder.search("#{self.name}, Chicago IL")
        self.bounds << response[0].data["geometry"]["viewport"]["northeast"]
        self.bounds << response[0].data["geometry"]["viewport"]["southwest"]
      end
    end
end
