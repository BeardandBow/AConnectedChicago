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
  end

  factory :neighborhood do
    name "Hyde Park"
    trait :with_user do
      after(:create) do |neighborhood|
        create(:user, neighborhood: neighborhood)
      end
    end
  end
end
