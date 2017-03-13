require 'rails_helper'

RSpec.describe Organization, type: :model do
  context "validations" do
    it "is not valid without a name" do
      org = build_stubbed(:organization, name: nil)

      expect(org).not_to be_valid
    end

    it "must have a unique name" do
      create(:organization, name: "Organization")
      org = build(:organization, name: "Organization")

      expect(org).not_to be_valid
      expect(org.errors[:name]).to include("has already been taken")
    end
  end

  context "associations" do
    it "has many neighborhoods" do
      org = create(:organization, :with_neighborhoods)

      expect(org.neighborhoods.count).to eq 2
    end

    it "has many users" do
      org = create(:organization, :with_users)

      expect(org.users.count).to eq 2
    end
  end
end
