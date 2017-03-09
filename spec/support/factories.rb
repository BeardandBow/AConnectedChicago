FactoryGirl.define do

  factory :story do
    title "story"
    author "some guy"
    description "description"
    body "blah blah blah"
    address "this one place"
    user
    neighborhood
  end

  factory :artwork do
    title "artwork"
    artist "some guy"
    description "description"
    address "this one place"
    user
    neighborhood
  end

  factory :event do
    title "event"
    host_contact "someguy@gmail.com"
    description "description"
    address "this one place"
    date Date.tomorrow
    time Time.now
    user
    neighborhood
  end

  factory :user do
    email "someguy@gmail.com"
    password "opensesame"
    trait :community_leader do
      role: 1
    end
  end

  factory :neighborhood do
    sequence(:name) {|n| "Hyde Park #{n}"}
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
        create(:user, :community_leader, neighborhoods: [hood])
    end
  end

  factory :organization do
    sequence(:name) {|n| "Organization #{n}"}
    trait :with_neighborhoods do
      after(:create) do |org|
        create_list(:neighborhood, 2, organizations: [org])
      end
    end
  end
end
