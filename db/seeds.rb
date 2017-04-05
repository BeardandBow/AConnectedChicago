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

    # neighborhood_names.each do |name|
    #           puts "creating #{name}"
    #   Neighborhood.create(name: name)
      # sleep 0.5
    # end

    Neighborhood.create(name: "Rogers Park")

    org_1 = Organization.create(name: "Precious Blood Ministry of Reconciliation",
                                website: "http://www.pbmr.org")
    org_2 = Organization.create(name: "Urban Life Skills",
                                website: "http://www.urbanlifeskills.org")
    org_3 = Organization.create(name: "Lawndale Christian Legal Center",
                                website: "http://lclc.net")
    org_4 = Organization.create(name: "Community Justice for Youth Institute",
                                website: "http://cjyiorg.publishpath.com")
    org_5 = Organization.create(name: "Institute on Public Safety and Social Justice at Adler University",
                                website: "http://www.adler.edu/page/institutes/institute-on-public-safety-and-social-justice/about")
    org_6 = Organization.create(name: "Circles and Ciphers",
                                website: "http://www.ucrogerspark.org/childrenyouthprograms/circlesciphers.html")
    org_7 = Organization.create(name: "Austin Coming Together",
                                website: "http://austincomingtogether.org")
    org_8 = Organization.create(name: "Target Area Development Corporation",
                                website: "http://targetarea.org")

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
                 address: "1823 W Farwell Ave, Chicago, IL 60626",
                 date: Date.tomorrow + 2.week.to_i,
                 time: Time.now,
                 link: "https://www.eventbrite.com/",
                 status: "approved",
                 user: user,
                 event_type: "Poetry Slam",
                 organization: org_1)
    Event.create(title: "Event 2",
                 host_contact: "person@example.com",
                 description: "A description",
                 address: "1170d W Farwell Ave, Chicago, IL 60626",
                 event_type: "Music Event",
                 date: Date.tomorrow + 2.week.to_i + 10,
                 time: Time.now + 20*60,
                 link: "https://www.eventbrite.com/",
                 status: "approved",
                 user: user,
                 organization: org_2)
    Event.create(title: "Event 3",
                 host_contact: "person@example.com",
                 description: "A description",
                 address: "5102 S. Elizabeth St., Chicago, IL 60609",
                 date: Date.tomorrow + 2.week.to_i,
                 time: Time.now + 20*60*60,
                 link: "https://www.eventbrite.com/",
                 status: "approved",
                 user: user,
                 event_type: "Open Mic",
                 organization: org_2)
    Event.create(title: "Event 4",
                 host_contact: "person@example.com",
                 description: "A description",
                 address: "1930 W Farwell Ave, Chicago, IL 60626",
                 date: Date.tomorrow + 2.week.to_i,
                 time: Time.now,
                 link: "https://www.eventbrite.com/",
                 status: "approved",
                 user: user,
                 event_type: "Peace Circle",
                 organization: org_2)

    addresses = ["1912 Touhy Ave, Chicago, IL 60626",
                 "1708 W Chase Ave, Chicago, IL 60626",
                 "1419 W Greenleaf Ave, Chicago, IL 60626",
                 "1918 W Farwell Ave, Chicago, IL 60626",
                 "1106 W Loyola Ave, Chicago, IL 60626",
                 "7644 N Bosworth Ave, Chicago, IL 60626",
                 "1512 W Juneway Terrace, Chicago, IL 60626",
                 "7729 N Hermitage Ave, Chicago, IL 60626",
                 "1436 W Fargo Ave, Chicago, IL 60626",
                 "1437 Howard St, Chicago, IL 60626"
                ]

    10.times do |n|
      Event.create(title: "Event #{n + 10}",
                   host_contact: "person@example.com",
                   description: "A description that is long with many words and phrases and sentences. it just keeps going and going and going forever until the end of time, because we cant stop, and we won't stop. we run things, things don't run we. Don't take nothing from nobody.",
                   address: addresses[n],
                   date: Date.tomorrow + 2.week.to_i,
                   time: Time.now,
                   link: "https://www.eventbrite.com/",
                   status: "approved",
                   user: user,
                   event_type: "Poetry Slam",
                   organization: org_1)
    end

    Artwork.create(title: "Art 1",
                  artist: "Picasso",
                  description: "A description",
                  address: "1321 W Chase Ave, Chicago, IL 60626",
                  status: "approved",
                  user: user)
    Artwork.create(title: "Art 2",
                   artist: "da Vinci",
                   description: "A description",
                   address: "1530 W Pratt Blvd, Chicago, IL 60626",
                   status: "approved",
                   user: user)
    Artwork.create(title: "Art 3",
                   artist: "van Gogh",
                   description: "A description",
                   address: "1199 W Morse Ave, Chicago, IL 60626",
                   status: "approved",
                   user: user)

    Story.create(title: "Story 1",
                 author: "David Kelly",
                 description: "A description",
                 body: "A riveting story goes here",
                 address: "7550 N Sheridan Rd, Chicago, IL 60626",
                 youtube_link: "https://www.youtube.com/watch?v=bXAdFETvL8M",
                 status: "approved",
                 user: user)
    Story.create(title: "Story 2",
                 author: "Mike Martinez",
                 description: "A description",
                 body: "A riveting story goes here",
                 address: "1426 W Sherwin Ave, Chicago, IL 60626",
                 youtube_link: "https://www.youtube.com/watch?v=bXAdFETvL8M",
                 status: "approved",
                 user: user)
    Story.create(title: "Story 3",
                 author: "Some guy",
                 description: "A description",
                 body: "A riveting story goes here",
                 address: "1544 W Jonquil Terrace, Chicago, IL 60626",
                 youtube_link: "https://www.youtube.com/watch?v=bXAdFETvL8M",
                 status: "approved",
                 user: user)
  end
end

Seed.start
