require 'rails_helper'

RSpec.describe Artwork, type: :model do
  context "validations" do
    before :each do
      @neighborhood = create(:neighborhood, :with_user)
      @user = @neighborhood.users.first
    end
    
    it "is not valid without title" do
      artwork = build(:artwork, title: nil,
                                neighborhood_id: @neighborhood.id,
                                user_id: @user.id)

      expect(artwork).not_to be_valid
    end

    it "is not valid without artist" do
      artwork = build(:artwork, artist: nil,
                                neighborhood_id: @neighborhood.id,
                                user_id: @user.id)

      expect(artwork).not_to be_valid
    end

    it "is not valid without description" do
      artwork = build(:artwork, description: nil,
                                neighborhood_id: @neighborhood.id,
                                user_id: @user.id)

      expect(artwork).not_to be_valid
    end

    it "is not valid without address" do
      artwork = build(:artwork, address: nil,
                                neighborhood_id: @neighborhood.id,
                                user_id: @user.id)

      expect(artwork).not_to be_valid
    end

    it "is valid with correct attributes" do
      artwork = build(:artwork, neighborhood_id: @neighborhood.id,
                                user_id: @user.id)

      expect(artwork).to be_valid
    end

    it "should have default status of 'pending'" do
      artwork = create(:artwork, neighborhood_id: @neighborhood.id,
                                 user_id: @user.id)

      expect(artwork.status).to eq('pending')
    end

    it "belongs to a user" do
      artwork = create(:artwork, neighborhood_id: @neighborhood.id,
                                 user_id: @user.id)

      expect(@user.artworks.count).to eq(1)
      expect(Artwork.all.count).to eq(1)
      expect(artwork.user_id).to eq(@user.id)
    end

    it "belongs to a neighborhood" do
      artwork = create(:artwork, neighborhood_id: @neighborhood.id,
                                 user_id: @user.id)

      expect(@neighborhood.artworks.count).to eq(1)
      expect(Artwork.all.count).to eq(1)
      expect(artwork.neighborhood_id).to eq(@neighborhood.id)
    end
  end
end
