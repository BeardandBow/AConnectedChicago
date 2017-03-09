require 'rails_helper'

RSpec.describe Artwork, type: :model do
  context "validations" do
    it "is not valid without title" do
      artwork = build(:artwork, title: nil)

      expect(artwork).not_to be_valid
    end

    it "is not valid without artist" do
      artwork = build(:artwork, artist: nil)

      expect(artwork).not_to be_valid
    end

    it "is not valid without description" do
      artwork = build(:artwork, description: nil)

      expect(artwork).not_to be_valid
    end

    it "is not valid without address" do
      artwork = build(:artwork, address: nil)

      expect(artwork).not_to be_valid
    end

    it "is valid with correct attributes" do
      artwork = build(:artwork)

      expect(artwork).to be_valid
    end

    it "should have default status of 'pending'" do
      artwork = create(:artwork)

      expect(artwork.status).to eq('pending')
    end
  end

  context "associations" do

    before :each do
      @artwork = create(:artwork)
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
      @artwork = create(:artwork)
    end

    it "returns a path with .path" do
      expect(@artwork.path).to eq("/artworks/#{@artwork.id}")
    end
  end
end
