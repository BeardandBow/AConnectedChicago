require 'rails_helper'

RSpec.describe Neighborhood, type: :model do
  context "validations" do
    it "is not valid without name" do
      neighborhood = Neighborhood.create()

      expect(neighborhood).not_to be_valid
    end

    it "should have unique name" do
      create(:neighborhood)
      neighborhood = build(:neighborhood)

      expect(neighborhood).not_to be_valid
      expect(neighborhood.errors[:name]).to include("has already been taken")
    end

    it "is valid with correct attributes" do
      neighborhood = create(:neighborhood)

      expect(neighborhood).to be_valid
    end
  end
end
