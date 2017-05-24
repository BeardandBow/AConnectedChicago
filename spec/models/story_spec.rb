require 'rails_helper'

RSpec.describe Story, type: :model do
  before :all do
    create(:neighborhood, name: "Hyde Park")
  end

  context "validations" do

    it "is not valid without title" do
      story = build_stubbed(:story, title: nil)

      expect(story).not_to be_valid
    end

    it "is not valid without author" do
      story = build_stubbed(:story, author: nil)

      expect(story).not_to be_valid
    end

    it "is not valid without description" do
      story = build_stubbed(:story, description: nil)

      expect(story).not_to be_valid
    end

    it "is not valid without body" do
      story = build_stubbed(:story, body: nil)

      expect(story).not_to be_valid
    end

    it "is not valid without address" do
      story = build_stubbed(:story, address: nil)

      expect(story).not_to be_valid
    end


    it "is valid with correct attributes" do
      story = create(:story)

      expect(story).to be_valid
    end

    it "is valid without a youtube link" do
      event = create(:story, youtube_link: "")

      expect(event).to be_valid
      expect(event.youtube_link).to be_nil
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
      @story = build_stubbed(:story)
    end

    it "returns a path with .path" do
      expect(@story.path).to eq("/stories/#{@story.id}")
    end

    it ".set_pkey sets a 'primary key' based on table and id" do
      story = build(:story)
      story.set_pkey
      expect(story.pkey).to eq("ST-#{story.id}")
    end

    it ".approve sets story status to approved" do
      story = build(:story)
      expect(story.status).to eq("pending")
      story.approve
      expect(story.status).to eq("approved")
    end

    it ".reject sets story status to rejected" do
      story = build(:story)
      expect(story.status).to eq("pending")
      story.reject
      expect(story.status).to eq("rejected")
    end

    it ".formatted_create_time formats the created_at" do
      time = Time.now.in_time_zone("Central Time (US & Canada)")
      story = build(:story, created_at: time)
      expect(story.formatted_create_time).to eq(time.strftime("%m/%d/%Y %I:%M %p"))
    end

    it ".formatted_update_time formats the updated_at" do
      time = Time.now.in_time_zone("Central Time (US & Canada)")
      story = build(:story, updated_at: time)
      expect(story.formatted_update_time).to eq(time.strftime("%m/%d/%Y %I:%M %p"))
    end

    it "formats a youtube link into an embedded link" do
      story= create(:story, youtube_link: "https://www.youtube.com/watch?v=eRBOgtp0Hac")

      expect(story.youtube_link).to eq("https://www.youtube.com/embed/eRBOgtp0Hac")
    end
  end
end
