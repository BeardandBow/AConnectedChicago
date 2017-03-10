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
  end

  context "associations" do

    before :each do
      @story = create(:story)
    end

    it "belongs to a user" do
      expect(@story).to respond_to(:user)
    end

    it "belongs to a neighborhood" do
      expect(@story).to respond_to(:neighborhood)
    end
  end

  context "custom methods" do
    before :each do
      @story = create(:story)
    end

    it "returns a path with .path" do
      expect(@story.path).to eq("/stories/#{@story.id}")
    end

    it "returns a type with .type" do
      expect(@story.type).to eq("story")
    end

    it ".set_pkey sets a 'primary key' based on table and id" do
      story = build(:story)
      story.set_pkey
      expect(story.pkey).to eq("ST-#{story.id}")
    end

    it ".approve sets story status to approved" do
      expect(@story.status).to eq("pending")
      @story.approve
      expect(@story.status).to eq("approved")
    end

    it ".reject sets story status to rejected" do
      expect(@story.status).to eq("pending")
      @story.reject
      expect(@story.status).to eq("rejected")
    end
  end
end
