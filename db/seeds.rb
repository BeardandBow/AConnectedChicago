class Seed
  def self.start
    hood_1 = Neighborhood.create(name: "Neighborhood 1")
    hood_2 = Neighborhood.create(name: "Neighborhood 2")
    hood_3 = Neighborhood.create(name: "Neighborhood 3")
    hood_4 = Neighborhood.create(name: "Neighborhood 4")

    org_1 = Organization.create(name: "Organization 1", neighborhoods: [hood_1, hood_2])
    org_2 = Organization.create(name: "Organization 2", neighborhoods: [hood_2, hood_3])
    org_3 = Organization.create(name: "Organization 3", neighborhoods: [hood_3, hood_4])
    org_4 = Organization.create(name: "Organization 4", neighborhoods: [hood_1, hood_4])

    user = User.create(email: "user@example.com",
                first_name: "Jack",
                last_name: "Reacher",
                password: "user",
                role: "registered_user",
                neighborhood: hood_1)
    leader = User.create(email: "leader@example.com",
                first_name: "John",
                last_name: "Wick",
                password: "leader",
                role: "community_leader",
                neighborhood: hood_1,
                organizations: [org_1, org_2])
    admin = User.create(email: "admin@example.com",
                first_name: "Jason",
                last_name: "Bourne",
                password: "admin",
                role: "admin",
                neighborhood: hood_1)

    Event.create(title: "Event 1",
                 host_contact: "person@example.com",
                 description: "A description",
                 address: "5114 S. Elizabeth St., Chicago, IL 60609",
                 date: Date.tomorrow + 10,
                 time: Time.now,
                 user: user,
                 neighborhood: hood_1,
                 organization: org_1)
    Event.create(title: "Event 2",
                 host_contact: "person@example.com",
                 description: "A description",
                 address: "5114 S. Elizabeth St., Chicago, IL 60609",
                 date: Date.tomorrow + 10,
                 time: Time.now + 20*60,
                 user: user,
                 neighborhood: hood_1,
                 organization: org_2)
    Event.create(title: "Event 3",
                 host_contact: "person@example.com",
                 description: "A description",
                 address: "5114 S. Elizabeth St., Chicago, IL 60609",
                 date: Date.tomorrow,
                 time: Time.now + 20*60*60,
                 user: user,
                 neighborhood: hood_2,
                 organization: org_2)
    Event.create(title: "Event 4",
                 host_contact: "person@example.com",
                 description: "A description",
                 address: "5114 S. Elizabeth St., Chicago, IL 60609",
                 date: Date.tomorrow,
                 time: Time.now,
                 status: "approved",
                 user: user,
                 neighborhood: hood_2,
                 organization: org_2)

    Artwork.create(title: "Art 1",
                  artist: "Picasso",
                  description: "A description",
                  address: "5114 S. Elizabeth St., Chicago, IL 60609",
                  user: user,
                  neighborhood: hood_1)
    Artwork.create(title: "Art 2",
                   artist: "da Vinci",
                   description: "A description",
                   address: "5114 S. Elizabeth St., Chicago, IL 60609",
                   user: user,
                   neighborhood: hood_2)
    Artwork.create(title: "Art 3",
                   artist: "van Gogh",
                   description: "A description",
                   address: "5114 S. Elizabeth St., Chicago, IL 60609",
                   status: "approved",
                   user: user,
                   neighborhood: hood_2)

    Story.create(title: "Story 1",
                 author: "David Kelly",
                 description: "A description",
                 body: "A riveting story goes here",
                 address: "5114 S. Elizabeth St., Chicago, IL 60609",
                 user: user,
                 neighborhood: hood_1)
    Story.create(title: "Story 2",
                 author: "Mike Martinez",
                 description: "A description",
                 body: "A riveting story goes here",
                 address: "5114 S. Elizabeth St., Chicago, IL 60609",
                 user: user,
                 neighborhood: hood_2)
    Story.create(title: "Story 3",
                 author: "Some guy",
                 description: "A description",
                 body: "A riveting story goes here",
                 address: "5114 S. Elizabeth St., Chicago, IL 60609",
                 status: "approved",
                 user: user,
                 neighborhood: hood_2)
  end
end

Seed.start
