FactoryGirl.define do

  factory :story do
    sequence(:title) {|n| "story #{n}"}
    author "some guy"
    description "description"
    body "blah blah blah"
    address "this one place"
    user
    neighborhood
  end

  factory :artwork do
    sequence(:title) {|n| "artwork #{n}"}
    artist "some guy"
    description "description"
    address "this one place"
    user
    neighborhood
  end

  factory :event do
    sequence(:title) {|n| "event #{n}"}
    host_contact "someguy@gmail.com"
    description "description"
    address "this one place"
    date Date.tomorrow
    time Time.now
    user
    neighborhood
    organization
  end

  factory :user do
    sequence(:email) {|n| "someguy#{n}@gmail.com"}
    password "opensesame"
    neighborhood
    trait :community_leader do
      role 1
      after(:create) do |user|
        create(:organization, users: [user])
      end
    end
    trait :admin do
      role 2
    end
    trait :with_organizations do
      after(:create) do |user|
        create_list(:organization, 2, users: [user])
      end
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
  end

  factory :organization do
    sequence(:name) {|n| "Organization #{n}"}
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
  end
end
