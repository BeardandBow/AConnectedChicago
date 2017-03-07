FactoryGirl.define do

  factory :story do
    title "story"
    author "some guy"
    description "description"
    body "blah blah blah"
    address "this one place"
    association :user, factory: :user
    association :neighborhood, factory: :neighborhood
  end

  factory :artwork do
    title "artwork"
    artist "some guy"
    description "description"
    address "this one place"
    association :user, factory: :user
    association :neighborhood, factory: :neighborhood
  end

  factory :event do
    title "event"
    host_contact "someguy@gmail.com"
    description "description"
    address "this one place"
    date Date.tomorrow
    time Time.now
    association :user, factory: :user
    association :neighborhood, factory: :neighborhood
  end

  factory :user do
    email "someguy@gmail.com"
    password "opensesame"
    trait :with_story do
      after(:create) do |user|
        create(:story, user: user)
    trait :with_event do
      after(:create) do |user|
        create(:event, user: user)
    trait :with_artwork do
      after(:create) do |user|
        create(:artwork, user: user)
    end
  end

  factory :neighborhood do
    name "Hyde Park"
    trait :with_story do
      after(:create) do |neighborhood|
        create(:story, neighborhood: neighborhood)
    trait :with_event do
      after(:create) do |neighborhood|
        create(:event, neighborhood: neighborhood)
    trait :with_artwork do
      after(:create) do |neighborhood|
        create(:artwork, neighborhood: neighborhood)
    end
  end
end
