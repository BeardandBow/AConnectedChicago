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

    it "belongs to a user" do
      user = create(:user, :with_artwork)

      expect(user.artworks.count).to eq(1)
      expect(Artwork.all.count).to eq(1)
      expect(Artwork.first.user_id).to eq(user.id)
    end

    it "belongs to a neighborhood" do
      neighborhood = create(:neighborhood, :with_artwork)

      expect(neighborhood.artworks.count).to eq(1)
      expect(Artwork.all.count).to eq(1)
      expect(Artwork.first.neighborhood_id).to eq(neighborhood.id)
    end
  end
end
