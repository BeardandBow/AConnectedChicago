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






    rj_hub = Type.create(name: "Restorative Justice Hub", category: 1)
    church = Type.create(name: "Religous Institution", category: 1)
    np = Type.create(name: "Non-Profit", category: 1)
    shelter = Type.create(name: "Shelter", category: 1)
    rj_school = Type.create(name: "Restorative Justice School", category: 1)
    gov = Type.create(name: "Government Agency", category: 1)
    mhc = Type.create(name: "Mental Health Center", category: 1)

    l1 = Location.create(address: "5114 S Elizabeth St, Chicago, IL 60609")

    org_1 = Organization.create(name: "Precious Blood Ministry of Reconciliation",
                                description: "PBMR is a network of reconciliation ministries inspired by a spirituality of the Precious Blood. Motivated by the belief that 'those who were once far off have been brought near through the blood of Christ' (Eph. 2:13), we work as agents of reconciliation.",
                                website: "http://www.pbmr.org",
                                type_id: rj_hub.id,
                                locations: [l1])

    l2 = Location.create(address: "2657 S Lawndale Ave, Chicago, IL 60623")

    org_2 = Organization.create(name: "Urban Life Skills",
                                description: "Intensive Gang Intervention Program in the Little Village Community on Chicago’s Southwest Side. For the past two years, the program has worked with over 75 gang involved youth that are wards of the Cook County Juvenile Court. The program is closely partnered with the Cook County Juvenile Probation Department and has seen many successes.",
                                website: "https://newlifecenters.org/programs/urban-life-skills/",
                                type_id: rj_hub.id,
                                locations: [l2])

    l3 = Location.create(address: "1530 S Hamlin Ave, Chicago, IL 60623")

    Organization.create(name: "Lawndale Christian Legal Center",
                        description: "We walk youth through — and away from — the criminal justice system to become good citizens and leaders of the community. We offer zealous and competent criminal defense legal services, compassionate social health services, and faithful loving mentors who walk with our youth on their life’s path. We serve youth involved with the criminal justice system, age 24 and younger, in North Lawndale.",
                        website: "http://lclc.net",
                        type_id: np.id,
                        locations: [l3])

    l4 = Location.create(address: "2929 S Wabash Ave #203, Chicago, IL 60616")

    Organization.create(name: "Community Justice for Youth Institute",
                        description: "CJYI is working with several community and faith-based organizations to promote the healthy development of youth on probation and safe re-entry of youth diverted from the Juvenile Temporary Detention Center (JTDC). Working in collaboration with Precious Blood Ministry of Reconciliation, the Southwest Youth Collaboration and FLY (Fearless Leading by the Youth), our goal is to support the development of RJ Hubs throughout Chicago.",
                        website: "http://cjyiorg.publishpath.com",
                        type_id: np.id,
                        locations: [l4])

    l5 = Location.create(address: "17 N Dearborn St, Chicago, IL 60602")

    Organization.create(name: "Institute on Public Safety and Social Justice at Adler University",
                        description: "Adler University pursues social change through service to communities, especially to disenfranchised and marginalized populations, and through the Centers and Institutes for Social Change. The University differs from traditional education to prepare practitioners imbued with social responsibility, and we build new models for engaging communities in social change.",
                        website: "http://www.adler.edu/page/institutes/institute-on-public-safety-and-social-justice/about",
                        type_id: rj_school.id,
                        locations: [l5])

    l6 = Location.create(address: "1545 W Morse Ave, Chicago, IL 60626")

    Organization.create(name: "Circles and Ciphers",
                        description: "Builds and mobilizes a healthy, youth-led community among prison, court, and gang involved young men (predominantly African-American, ages 14-22) from Chicago. We use hip-hop infused peacemaking circles and creative arts projects on a wide variety of themes, including: masculinity; violence; school; gangs and gang histories; stereotypes; policing; relationships. Participants are empowered to derail a legacy of disengagement.",
                        website: "http://www.ucrogerspark.org/childrenyouthprograms/circlesciphers.html",
                        type_id: rj_hub.id,
                        locations: [l6])

    l7 = Location.create(address: "5049 W Harrison St, Chicago, IL 60644")

    Organization.create(name: "Austin Coming Together",
                        description: "ACT's work is driven by shared leadership, a commitment to the use of data and rigorous research; and a commitment to creative, strategic thinking. We are committed to ProACTive community building and increasing collective impact in the Austin community of Chicago.",
                        website: "http://austincomingtogether.org/",
                        type_id: np.id,
                        locations: [l7])

    l8 = Location.create(address: "1542 W 79th St, Chicago, IL 60620")

    Organization.create(name: "Target Area Development Corporation",
                        description: "Regional grassroots social justice organization with offices in Illinois, Indiana, Michigan, and South Africa building power in communities to solve stubborn problems using Research, Organizing, Mobilization, and Education (ROME).",
                        website: "http://targetarea.org",
                        type_id: rj_hub.id,
                        locations: [l8])

    l9 = Location.create(address: "2401 West North Avenue, Chicago, IL 60647")

    Organization.create(name: "Alliance of Local Service Organizations (ALSO)",
                        description: "Our mission is to end violence in the homes and streets of communities nationwide. It was created to coordinate services for youth and families in the Logan Square community on Chicago’s Northwest Side.",
                        website: "http://also-chicago.org/also_site/",
                        type_id: rj_hub.id,
                        locations: [l9])

    l10 = Location.create(address: "69 W. Washington, Suite 3300 Chicago, Illinois 60602")

    Organization.create(name: "Juvenile Justice and Child Protection - Resource Section",
                        description: "This Resource Section of the Cook County Circuit Court serves as liaison to the academic, business and religious communities to identify and develop services and resources that will augment programs vital to juvenile justice. A significant means of accomplishing this mission is through hosting quarterly City Wide restorative justice gatherings. The section is supervised by an administrative presiding judge.",
                        website: "http://www.cookcountycourt.org/ABOUTTHECOURT/JuvenileJusticeChildProtection/JuvenileJusticeChildProtectionResourceSection.aspx",
                        type_id: gov.id,
                        locations: [l10])

    l11 = Location.create(address: "430 S Michigan Ave, Chicago, IL 60605")

    Organization.create(name: "Mansfield Institute for Social Justice and Transformation at Roosevelt University",
                        description: "Created in 1999 through a generous gift from the Mansfield Foundation, gives Roosevelt University a unique opportunity to develop an integrated program of curriculum, research, and outreach focused on social justice issues through which students will develop into socially conscious leaders. We create and facilitate scholar activism among our students, faculty and members of our community, through a pedagogy of transformational learning, social justice programming, and action.",
                        website: "https://www.roosevelt.edu/centers/misjt/transformational-learning",
                        type_id: rj_school.id,
                        locations: [l11])

    l12 = Location.create(address: "5700 S. Prairie, Chicago, Illinois  60637")

    Organization.create(name: "Nehemiah Trinity Rising",
                        description: "NTR is a faith based restorative justice 501c3 dedicated to building peace. We collaborate with communities to provide restorative justice advocacy, education, skills transfer, re-entry strategies and sustainable implementation. We serve a wide variety of settings (including congregations, schools, businesses, prisons, juvenile detention centers, etc.) to transform relationships and heal communities.",
                        website: "https://www.nehemiahtrinityrising.org/",
                        type_id: np.id,
                        locations: [l12])

    neighborhood = Neighborhood.find(40)

    admin = User.create(email: ENV["admin_email"],
                first_name: "Connected",
                last_name: "Chicago",
                password: ENV["admin_password"],
                role: "admin",
                neighborhood: neighborhood)

    ps = Type.create(name: "Poetry Slam", category: 0)
    me = Type.create(name: "Music Event", category: 0)
    om = Type.create(name: "Open Mic", category: 0)
    pc = Type.create(name: "Peace Circle", category: 0)
  end
end

Seed.start
