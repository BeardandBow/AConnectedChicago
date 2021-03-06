require 'rails_helper'

RSpec.describe Artwork, type: :model do
  before :all do
    create(:neighborhood, name: "Hyde Park")
  end

  context "validations" do

    it "is not valid without title" do
      artwork = build_stubbed(:artwork, title: nil)

      expect(artwork).not_to be_valid
    end

    it "is not valid without artist" do
      artwork = build_stubbed(:artwork, artist: nil)

      expect(artwork).not_to be_valid
    end

    it "is not valid without description" do
      artwork = build_stubbed(:artwork, description: nil)

      expect(artwork).not_to be_valid
    end

    it "is not valid without address" do
      artwork = build_stubbed(:artwork, address: nil)

      expect(artwork).not_to be_valid
    end

    it "is valid with correct attributes" do
      artwork = create(:artwork)

      expect(artwork).to be_valid
    end

    it "should have default status of 'pending'" do
      artwork = build_stubbed(:artwork)

      expect(artwork.status).to eq('pending')
    end
  end

  context "associations" do

    before :each do
      @artwork = build_stubbed(:artwork)
    end

    it "belongs to a user" do
      expect(@artwork).to respond_to(:user)
    end

    it "belongs to a neighborhood" do
      expect(@artwork).to respond_to(:neighborhood)
    end
  end

  context "custom methods" do
    before :each do
      @artwork = build_stubbed(:artwork)
    end

    it "returns a path with .path" do
      expect(@artwork.path).to eq("/artworks/#{@artwork.id}")
    end

    it ".set_pkey sets a 'primary key' based on table and id" do
      artwork = build(:artwork)
      artwork.set_pkey
      expect(artwork.pkey).to eq("AR-#{artwork.id}")
    end

    it ".approve sets artwork status to approved" do
      artwork = build(:artwork)
      expect(artwork.status).to eq("pending")
      artwork.approve
      expect(artwork.status).to eq("approved")
    end

    it ".reject sets artwork status to rejected" do
      artwork = build(:artwork)
      expect(artwork.status).to eq("pending")
      artwork.reject
      expect(artwork.status).to eq("rejected")
    end

    it ".formatted_create_time formats the created_at" do
      time = Time.now.in_time_zone("Central Time (US & Canada)")
      artwork = build(:artwork, created_at: time)
      expect(artwork.formatted_create_time).to eq(time.strftime("%m/%d/%Y %I:%M %p"))
    end

    it ".formatted_update_time formats the updated_at" do
      time = Time.now.in_time_zone("Central Time (US & Canada)")
      artwork = build(:artwork, updated_at: time)
      expect(artwork.formatted_update_time).to eq(time.strftime("%m/%d/%Y %I:%M %p"))
    end
  end
end
