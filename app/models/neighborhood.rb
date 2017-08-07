require 'google_maps_service'

class Neighborhood < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  serialize :bounds
  after_validation :geocode_location

  has_many :artworks
  has_many :events
  has_many :stories
  has_many :locations
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
      gmaps = GoogleMapsService::Client.new(
        key: ENV['google_maps_secret'],
        queries_per_second: 10
      )
      special_hoods = ["O'Hare", "West Garfield Park", "West Lawn", "New City", "West Englewood"]
      if self.bounds.empty? && !special_hoods.any? { |word| self.name.include?(word) }
        response = gmaps.geocode("#{self.name} (neighborhood), Chicago IL")
        if response[0]
          self.bounds << response[0][:geometry][:bounds][:northeast]
          self.bounds << response[0][:geometry][:bounds][:southwest]
        end
      elsif self.bounds.empty? && special_hoods.any? { |word| self.name.include?(word) }
        if self.name == "O'Hare"
          response = gmaps.geocode("#{self.name} (community), Chicago IL")
          if response[0]
            self.bounds << response[0][:geometry][:bounds][:northeast]
            self.bounds << response[0][:geometry][:bounds][:southwest]
          end
        else
          response = gmaps.geocode(nil, components: {locality: "#{self.name}, Chicago, IL"})
          if response[0]
            self.bounds << response[0][:geometry][:bounds][:northeast]
            self.bounds << response[0][:geometry][:bounds][:southwest]
          end
        end
      end
    end
end
