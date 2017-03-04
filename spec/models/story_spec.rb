require 'rails_helper'

RSpec.describe Story, type: :model do
  context "validations" do
    it "is not valid without title" do
      story = Story.create(author: "some guy",
                           description: "description",
                           body: "my story stuff",
                           address: "my place")

      expect(story).not_to be_valid
    end

    it "is not valid without author" do
      story = Story.create(title: "story",
                           description: "description",
                           body: "my story stuff",
                           address: "my place")

      expect(story).not_to be_valid
    end

    it "is not valid without description" do
      story = Story.create(title: "story",
                           author: "some guy",
                           body: "my story stuff",
                           address: "my place")

      expect(story).not_to be_valid
    end

    it "is not valid without body" do
      story = Story.create(author: "some guy",
                           title: "story",
                           description: "description",
                           address: "my place")

      expect(story).not_to be_valid
    end

    it "is not valid without address" do
      story = Story.create(author: "some guy",
                           title: "story",
                           description: "description",
                           body: "my story stuff")

      expect(story).not_to be_valid
    end

    it "is valid with correct attributes" do
      story = create(:story)

      expect(story).to be_valid
    end

    it "should have default status of 'pending'" do
      story = create(:story)

      expect(story.status).to eq('pending')
    end
  end
end
