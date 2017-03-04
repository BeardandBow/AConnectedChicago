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
end
