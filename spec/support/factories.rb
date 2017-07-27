FactoryGirl.define do

  factory :story do
    sequence(:title) {|n| "story #{n}"}
    author "some guy"
    description "description"
    body "blah blah blah"
    address "1100 E 55th St, Chicago, IL 60615" # address is in Hyde Park
    youtube_link "YYrus5g5iN4"
    user
  end

  factory :artwork do
    sequence(:title) {|n| "artwork #{n}"}
    artist "some guy"
    description "description"
    address "1100 E 55th St, Chicago, IL 60615"
    user
  end

  factory :event do
    sequence(:title) {|n| "event #{n}"}
    host_contact "someguy@gmail.com"
    description "description"
    address "1100 E 55th St, Chicago, IL 60615"
    date Date.tomorrow
    time Time.now
    link "https://www.eventbrite.com/"
    user
    organization
  end

  factory :user do
    sequence(:email) {|n| "someguy#{n}@gmail.com"}
    sequence(:first_name) {|n| "Guy #{n}"}
    sequence(:last_name) {|n| "Smith #{n}"}
    password "opensesame"
    neighborhood
    trait :registered_user do
      role 1
    end
    trait :community_leader do
      role 2
      after(:create) do |user|
        create(:organization, users: [user])
      end
    end
    trait :admin do
      role 3
    end
    trait :with_organizations do
      after(:create) do |user|
        create_list(:organization, 2, users: [user])
      end
    end
  end

# hood_names = ["West Ridge", "Uptown", "Lincoln Square", "Edison Park",
#                         "Norwood Park", "Jefferson Park", "Forest Glen", "North Park", "Albany Park",
#                         "O'Hare", "Edgewater", "North Center", "Lakeview", "Lincoln Park",
#                         "Avondale", "Logan Square", "Portage Park", "Irving Park", "Dunning",
#                         "Montclare", "Belmont Cragin", "Hermosa", "Near North Side", "Loop",
#                         "Near South Side", "Humboldt Park", "West Town", "Austin", "West Garfield Park",
#                         "East Garfield Park", "Near West Side", "North Lawndale", "South Lawndale", "Lower West Side",
#                         "Garfield Ridge", "Archer Heights", "Brighton Park", "McKinley Park", "New City",
#                         "West Elsdon", "Gage Park", "Clearing", "West Lawn", "Chicago Lawn",
#                         "West Englewood", "Englewood", "Armour Square", "Douglas", "Oakland",
#                         "Fuller Park", "Grand Boulevard", "Kenwood", "Washington Park", "Hyde Park",
#                         "Woodlawn", "South Shore", "Bridgeport", "Greater Grand Crossing", "Ashburn",
#                         "Auburn Gresham", "Beverly", "Washington Heights", "Mount Greenwood", "Morgan Park",
#                         "Chatham", "Avalon Park", "South Chicago", "Burnside", "Calumet Heights",
#                         "Roseland", "Pullman", "South Deering", "East Side", "West Pullman",
#                         "Riverdale", "Hegewisch", "Rogers Park"]

  factory :neighborhood do
    sequence (:name) { |n| "Hyde Park #{n}" }
    bounds [{lat:41.8026339, lng:-87.5751643}, {lat:41.78583400000001, lng:-87.6064074}]
    trait :with_user do
      after(:create) do |neighborhood|
        create(:user, neighborhood: neighborhood)
      end
    end
    trait :with_organizations do
      after(:create) do |hood|
        create_list(:organization, 2, neighborhoods: [hood])
      end
    end
    trait :with_community_leader do
      after(:create) do |hood|
        create(:user, :community_leader, neighborhood: hood)
      end
    end
    trait :with_locations do
      after(:create) do |hood|
        create_list(:location, 2, neighborhood: hood)
      end
    end
  end

  factory :organization do
    sequence(:name) {|n| "Organization #{n}"}
    description "A Description"
    trait :with_neighborhoods do
      after(:create) do |org|
        create_list(:neighborhood, 2, organizations: [org])
      end
    end
    trait :with_users do
      after(:create) do |org|
        create_list(:user, 2, organizations: [org])
      end
    end
    trait :with_locations do
      after(:create) do |org|
        create_list(:location, 2, organization: org)
      end
    end
  end

  factory :type do
    name "Peace Circle"
    category 0
    trait :with_organizations do
      after(:create) do |type|
        create_list(:organization, 2, type: type)
      end
    end
    trait :with_events do
      after(:create) do |type|
        create_list(:event, 2, type: type)
      end
    end
  end

  factory :location do
    address "1100 E 55th St, Chicago, IL 60615"
  end
end
