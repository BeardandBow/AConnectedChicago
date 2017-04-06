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
    if self.bounds[0]
      lat.between?(self.bounds[1]["lat"], self.bounds[0]["lat"]) && long.between?(self.bounds[1]["lng"], self.bounds[0]["lng"])
    end
  end

  private

    def geocode_location
      if self.bounds.empty?
        response = Geocoder.search("#{self.name}(neighborhood), Chicago IL")
        if response[0]
          self.bounds << response[0].data["geometry"]["viewport"]["northeast"]
          self.bounds << response[0].data["geometry"]["viewport"]["southwest"]
        end
      end
    end
end
