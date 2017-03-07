require 'rails_helper'

RSpec.describe Artwork, type: :model do
  context "validations" do
    it "is not valid without title" do
      artwork = Artwork.create(artist: "some guy",
                           description: "description",
                           address: "my place")

      expect(artwork).not_to be_valid
    end

    it "is not valid without artist" do
      artwork = Artwork.create(title: "artwork",
                           description: "description",
                           address: "my place")

      expect(artwork).not_to be_valid
    end

    it "is not valid without description" do
      artwork = Artwork.create(title: "artwork",
                           artist: "some guy",
                           address: "my place")

      expect(artwork).not_to be_valid
    end

    it "is not valid without address" do
      artwork = Artwork.create(artist: "some guy",
                           title: "artwork",
                           description: "description")

      expect(artwork).not_to be_valid
    end

    it "is valid with correct attributes" do
      artwork = create(:artwork)

      expect(artwork).to be_valid
    end

    it "should have default status of 'pending'" do
      artwork = create(:artwork)

      expect(artwork.status).to eq('pending')
    end

    it "belongs to a user" do
      
    end
  end
end
