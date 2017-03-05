FactoryGirl.define do

  factory :story do
    title "story"
    author "some guy"
    description "description"
    body "blah blah blah"
    address "this one place"
  end

  factory :artwork do
    title "artwork"
    artist "some guy"
    description "description"
    address "this one place"
  end

  factory :event do
    title "event"
    host_contact "someguy@gmail.com"
    description "description"
    address "this one place"
    date Date.tomorrow
    time Time.now
  end

  factory :user do
    email "someguy@gmail.com"
    password "opensesame"
    password_confirmation "opensesame"
  end

  factory :neighborhood do
    name "Hyde Park"
  end
end
