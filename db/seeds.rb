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

    rj_hub = Type.create(name: "RJ Hub", category: 1)
    church = Type.create(name: "Religous Institution", category: 1)
    np = Type.create(name: "Non-Profit", category: 1)
    shelter = Type.create(name: "Shelter", category: 1)
    rj_school = Type.create(name: "RJ School", category: 1)
    gov = Type.create(name: "Government Agency", category: 1)
    mhc = Type.create(name: "Mental Health Center", category: 1)

    l1 = Location.create(address: "5114 S Elizabeth St, Chicago, IL 60609")
    l2 = Location.create(address: "2657 S Lawndale Ave, Chicago, IL 60623")
    l3 = Location.create(address: "1530 S Hamlin Ave, Chicago, IL 60623")
    l4 = Location.create(address: "2929 S Wabash Ave #203, Chicago, IL 60616")
    l5 = Location.create(address: "17 N Dearborn St, Chicago, IL 60602")
    l6 = Location.create(address: "1545 W Morse Ave, Chicago, IL 60626")
    l7 = Location.create(address: "5049 W Harrison St, Chicago, IL 60644")
    l8 = Location.create(address: "1542 W 79th St, Chicago, IL 60620")
    l9 = Location.create(address: "2401 West North Avenue, Chicago, IL 60647")
    l10 = Location.create(address: "69 W. Washington, Suite 3300 Chicago, Illinois 60602")
    l11 = Location.create(address: "430 S Michigan Ave, Chicago, IL 60605")
    l12 = Location.create(address: "5700 S. Prairie, Chicago, Illinois  60637")

    org_1 = Organization.create(name: "Precious Blood Ministry of Reconciliation",
                                description: "PBMR is a network of reconciliation ministries inspired by a spirituality of the Precious Blood. Motivated by the belief that 'those who were once far off have been brought near through the blood of Christ' (Eph. 2:13), we work as agents of reconciliation.",
                                website: "http://www.pbmr.org",
                                type_id: church.id,
                                locations: [l1])

    org_2 = Organization.create(name: "Urban Life Skills",
                                description: "Intensive Gang Intervention Program in the Little Village Community on Chicago’s Southwest Side. For the past two years, the program has worked with over 75 gang involved youth that are wards of the Cook County Juvenile Court. The program is closely partnered with the Cook County Juvenile Probation Department and has seen many successes.",
                                website: "https://newlifecenters.org/programs/urban-life-skills/",
                                type_id: rj_hub.id,
                                locations: [l2])

    Organization.create(name: "Lawndale Christian Legal Center",
                        description: "We walk youth through — and away from — the criminal justice system to become good citizens and leaders of the community. We offer zealous and competent criminal defense legal services, compassionate social health services, and faithful loving mentors who walk with our youth on their life’s path. We serve youth involved with the criminal justice system, age 24 and younger, in North Lawndale.",
                        website: "http://lclc.net",
                        type_id: np.id,
                        locations: [l3])

    Organization.create(name: "Community Justice for Youth Institute",
                        description: "CJYI is working with several community and faith-based organizations to promote the healthy development of youth on probation and safe re-entry of youth diverted from the Juvenile Temporary Detention Center (JTDC). Working in collaboration with Precious Blood Ministry of Reconciliation, the Southwest Youth Collaboration and FLY (Fearless Leading by the Youth), our goal is to support the development of RJ Hubs throughout Chicago.",
                        website: "http://cjyiorg.publishpath.com",
                        type_id: np.id,
                        locations: [l4])

    Organization.create(name: "Institute on Public Safety and Social Justice at Adler University",
                        description: "Adler University pursues social change through service to communities, especially to disenfranchised and marginalized populations, and through the Centers and Institutes for Social Change. The University differs from traditional education to prepare practitioners imbued with social responsibility, and we build new models for engaging communities in social change.",
                        website: "http://www.adler.edu/page/institutes/institute-on-public-safety-and-social-justice/about",
                        type_id: rj_school.id,
                        locations: [l5])

    Organization.create(name: "Circles and Ciphers",
                        description: "Builds and mobilizes a healthy, youth-led community among prison, court, and gang involved young men (predominantly African-American, ages 14-22) from Chicago. We use hip-hop infused peacemaking circles and creative arts projects on a wide variety of themes, including: masculinity; violence; school; gangs and gang histories; stereotypes; policing; relationships. Participants are empowered to derail a legacy of disengagement.",
                        website: "http://www.ucrogerspark.org/childrenyouthprograms/circlesciphers.html",
                        type_id: rj_hub.id,
                        locations: [l6])

    Organization.create(name: "Austin Coming Together",
                        description: "ACT's work is driven by shared leadership, a commitment to the use of data and rigorous research; and a commitment to creative, strategic thinking. We are committed to ProACTive community building and increasing collective impact in the Austin community of Chicago.",
                        website: "http://austincomingtogether.org/",
                        type_id: np.id,
                        locations: [l7])

    Organization.create(name: "Target Area Development Corporation",
                        description: "Regional grassroots social justice organization with offices in Illinois, Indiana, Michigan, and South Africa building power in communities to solve stubborn problems using Research, Organizing, Mobilization, and Education (ROME).",
                        website: "http://targetarea.org",
                        type_id: rj_hub.id,
                        locations: [l8])

    Organization.create(name: "Alliance of Local Service Organizations (ALSO)",
                        description: "Our mission is to end violence in the homes and streets of communities nationwide. It was created to coordinate services for youth and families in the Logan Square community on Chicago’s Northwest Side.",
                        website: "http://also-chicago.org/also_site/",
                        type_id: rj_hub.id,
                        locations: [l9])

    Organization.create(name: "Juvenile Justice and Child Protection - Resource Section",
                        description: "This Resource Section of the Cook County Circuit Court serves as liaison to the academic, business and religious communities to identify and develop services and resources that will augment programs vital to juvenile justice. A significant means of accomplishing this mission is through hosting quarterly City Wide restorative justice gatherings. The section is supervised by an administrative presiding judge.",
                        website: "http://www.cookcountycourt.org/ABOUTTHECOURT/JuvenileJusticeChildProtection/JuvenileJusticeChildProtectionResourceSection.aspx",
                        type_id: gov.id,
                        locations: [l10])

    Organization.create(name: "Mansfield Institute for Social Justice and Transformation at Roosevelt University",
                        description: "Created in 1999 through a generous gift from the Mansfield Foundation, gives Roosevelt University a unique opportunity to develop an integrated program of curriculum, research, and outreach focused on social justice issues through which students will develop into socially conscious leaders. We create and facilitate scholar activism among our students, faculty and members of our community, through a pedagogy of transformational learning, social justice programming, and action.",
                        website: "https://www.roosevelt.edu/centers/misjt/transformational-learning",
                        type_id: rj_school.id,
                        locations: [l11])

    Organization.create(name: "Nehemiah Trinity Rising",
                        description: "NTR is a faith based restorative justice 501c3 dedicated to building peace. We collaborate with communities to provide restorative justice advocacy, education, skills transfer, re-entry strategies and sustainable implementation. We serve a wide variety of settings (including congregations, schools, businesses, prisons, juvenile detention centers, etc.) to transform relationships and heal communities.",
                        website: "https://www.nehemiahtrinityrising.org/",
                        type_id: np.id,
                        locations: [l12])

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

    ps = Type.create(name: "Poetry Slam", category: 0)
    me = Type.create(name: "Music Event", category: 0)
    om = Type.create(name: "Open Mic", category: 0)
    pc = Type.create(name: "Peace Circle", category: 0)

    Event.create(title: "Event 1",
                 host_contact: "person@example.com",
                 description: "A description",
                 address: "1823 W Farwell Ave, Chicago, IL 60626",
                 date: Date.tomorrow + 2.week.to_i,
                 time: Time.now,
                 link: "https://www.eventbrite.com/",
                 status: "approved",
                 user: user,
                 type_id: ps.id,
                 organization: org_1)
    Event.create(title: "Event 2",
                 host_contact: "person@example.com",
                 description: "A description",
                 address: "1170d W Farwell Ave, Chicago, IL 60626",
                 type_id: me.id,
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
                 type_id: om.id,
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
                 type_id: pc.id,
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
                   type_id: ps.id,
                   organization: org_1)
    end

    3.times do |n|
      Event.create(title: "Event #{n + 100}",
                   host_contact: "person@example.com",
                   description: "An event that is not approved",
                   address: addresses[n],
                   date: Date.tomorrow + 2.week.to_i,
                   time: Time.now,
                   link: "https://www.eventbrite.com/",
                   status: "pending",
                   user: user,
                   type_id: om.id,
                   organization: org_1)

      Artwork.create(title: "Art #{n + 100}",
                     artist: "Picasso",
                     description: "An artwork that is not approved",
                     address: addresses[n + 3],
                     status: "pending",
                     user: user)

      Story.create(title: "Story #{n + 100}",
                   author: "David Kelly",
                   description: "A story that is not approved",
                   body: "A riveting story goes here",
                   address: addresses[n + 6],
                   youtube_link: "https://www.youtube.com/watch?v=bXAdFETvL8M",
                   status: "pending",
                   user: user)
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
