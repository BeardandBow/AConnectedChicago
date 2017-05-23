require 'rails_helper'

RSpec.describe Neighborhood, type: :model do
  context "validations" do
    it "is not valid without name" do
      neighborhood = build_stubbed(:neighborhood, name: nil)

      expect(neighborhood).not_to be_valid
    end

    it "should have unique name" do
      create(:neighborhood, name: "Hyde Park")
      neighborhood = build(:neighborhood, name: "Hyde Park")

      expect(neighborhood).not_to be_valid
      expect(neighborhood.errors[:name]).to include("has already been taken")
    end

    it "is valid with correct attributes" do
      neighborhood = build_stubbed(:neighborhood)

      expect(neighborhood).to be_valid
    end

    it "has many organizations" do
      neighborhood = create(:neighborhood, :with_organizations)

      expect(neighborhood.organizations.count).to eq 2
    end

    it "has many locations" do
      hood = create(:neighborhood, :with_locations, name: 'Hyde Park')

      expect(hood.locations.count).to eq 2
    end
  end
end
