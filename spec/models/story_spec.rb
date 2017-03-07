require 'rails_helper'

RSpec.describe Story, type: :model do
  context "validations" do
    it "is not valid without title" do
      story = build(:story, title: nil)

      expect(story).not_to be_valid
    end

    it "is not valid without author" do
      story = build(:story, author: nil)

      expect(story).not_to be_valid
    end

    it "is not valid without description" do
      story = build(:story, description: nil)

      expect(story).not_to be_valid
    end

    it "is not valid without body" do
      story = build(:story, body: nil)

      expect(story).not_to be_valid
    end

    it "is not valid without address" do
      story = build(:story, address: nil)

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

    it "belongs to a user" do
      user = create(:user, :with_story)

      expect(user.stories.count).to eq(1)
      expect(Story.all.count).to eq(1)
      expect(Story.first.user_id).to eq(user.id)
    end

    it "belongs to a neighborhood" do
      neighborhood = create(:neighborhood, :with_story)

      expect(neighborhood.stories.count).to eq(1)
      expect(Story.all.count).to eq(1)
      expect(Story.first.neighborhood_id).to eq(neighborhood.id)
    end
  end
end
