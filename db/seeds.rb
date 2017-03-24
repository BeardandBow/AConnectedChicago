class Seed
  def self.start
    neighborhood_names = ["Rogers Park", "West Ridge", "Uptown", "Lincoln Square", "Edison Park",
                          "Norwood Park", "Jefferson Park", "Forest Glen", "North Park", "Albany Park",
                          "O'Hare", "Edgewater", "North Center", "Lakeview", "Lincoln Park",
                          "Avondale", "Logan Square", "Portage Park", "Irving Park", "Dunning",
                          "Montclare", "Belmont Cragin", "Hermosa", "Near North Side", "Loop",
                          "Near South Side", "Humboldt Park", "West Town", "Austin", "West Garfield Park",
                          "East Garfield Park", "Near West Side", "North Lawndale", "South Lawndale", "Lower West Side",
                          "Garfield Ridge", "Archer Heights", "Brighton Park", "McKinley Park", "New City",
                          "West Elsdon", "Gage Park", "Clearing", "West Lawn", "Chicago Lawn",
                          "West Englewood", "Englewood", "Armour Square", "Douglas", "Oakland",
                          "Fuller Park", "Grand Boulevard", "Kenwood", "Washington Park", "Hyde Park",
                          "Woodlawn", "South Shore", "Bridgeport", "Greater Grand Crossing", "Ashburn",
                          "Auburn Gresham", "Beverly", "Washington Heights", "Mount Greenwood", "Morgan Park",
                          "Chatham", "Avalon Park", "South Chicago", "Burnside", "Calumet Heights",
                          "Roseland", "Pullman", "South Deering", "East Side", "West Pullman",
                          "Riverdale", "Hegewisch"]

    neighborhood_names.each do |name|
              puts "creating #{name}"
      Neighborhood.create(name: name)
    end

    org_1 = Organization.create(name: "Organization 1", neighborhoods: [Neighborhood.first, Neighborhood.second])
    org_2 = Organization.create(name: "Organization 2", neighborhoods: [Neighborhood.second, Neighborhood.third])
    org_3 = Organization.create(name: "Organization 3", neighborhoods: [Neighborhood.third, Neighborhood.fourth])
    org_4 = Organization.create(name: "Organization 4", neighborhoods: [Neighborhood.first, Neighborhood.fourth])

    user = User.create(email: "user@example.com",
                first_name: "Jack",
                last_name: "Reacher",
                password: "user",
                role: "registered_user",
                neighborhood: Neighborhood.first)
    leader = User.create(email: "leader@example.com",
                first_name: "John",
                last_name: "Wick",
                password: "leader",
                role: "community_leader",
                neighborhood: Neighborhood.first,
                organizations: [org_1, org_2])
    admin = User.create(email: "admin@example.com",
                first_name: "Jason",
                last_name: "Bourne",
                password: "admin",
                role: "admin",
                neighborhood: Neighborhood.first)

    Event.create(title: "Event 1",
                 host_contact: "person@example.com",
                 description: "A description",
                 address: "1719 W Lunt Ave, Chicago, IL 60626",
                 date: Date.tomorrow + 10,
                 time: Time.now,
                 user: user,
                 organization: org_1)
    Event.create(title: "Event 2",
                 host_contact: "person@example.com",
                 description: "A description",
                 address: "5100 S. Elizabeth St., Chicago, IL 60609",
                 date: Date.tomorrow + 10,
                 time: Time.now + 20*60,
                 user: user,
                 organization: org_2)
    Event.create(title: "Event 3",
                 host_contact: "person@example.com",
                 description: "A description",
                 address: "5120 S. Elizabeth St., Chicago, IL 60609",
                 date: Date.tomorrow,
                 time: Time.now + 20*60*60,
                 user: user,
                 organization: org_2)
    Event.create(title: "Event 4",
                 host_contact: "person@example.com",
                 description: "A description",
                 address: "5114 S. Elizabeth St., Chicago, IL 60609",
                 date: Date.tomorrow,
                 time: Time.now,
                 status: "approved",
                 user: user,
                 organization: org_2)

    Artwork.create(title: "Art 1",
                  artist: "Picasso",
                  description: "A description",
                  address: "3291 S. Elizabeth St., Chicago, IL 60609",
                  user: user)
    Artwork.create(title: "Art 2",
                   artist: "da Vinci",
                   description: "A description",
                   address: "5000 S. Elizabeth St., Chicago, IL 60609",
                   user: user)
    Artwork.create(title: "Art 3",
                   artist: "van Gogh",
                   description: "A description",
                   address: "6111 S. Elizabeth St., Chicago, IL 60609",
                   status: "approved",
                   user: user)

    Story.create(title: "Story 1",
                 author: "David Kelly",
                 description: "A description",
                 body: "A riveting story goes here",
                 address: "5120 S. Elizabeth St., Chicago, IL 60609",
                 user: user)
    Story.create(title: "Story 2",
                 author: "Mike Martinez",
                 description: "A description",
                 body: "A riveting story goes here",
                 address: "4113 S. Elizabeth St., Chicago, IL 60609",
                 user: user)
    Story.create(title: "Story 3",
                 author: "Some guy",
                 description: "A description",
                 body: "A riveting story goes here",
                 address: "3218 S. Elizabeth St., Chicago, IL 60609",
                 status: "approved",
                 user: user)
  end
end

Seed.start
