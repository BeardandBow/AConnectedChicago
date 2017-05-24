require "rails_helper"

RSpec.describe Type, type: :model do

  context "validations" do
    it "is not valid without a name" do
      type = build_stubbed(:type, name: nil)

      expect(type).not_to be_valid
    end

    it "must have a unique name" do
      create(:type, name: "Stuff")
      type = build(:type, name: "Stuff")

      expect(type).not_to be_valid
      expect(type.errors[:name]).to include("has already been taken")
    end
  end

  context "associations" do
    it "has many organizations" do
      type = create(:type, :with_organizations)

      expect(type.organizations.count).to eq 2
    end

    it "has many events" do
      type = create(:type, :with_events)

      expect(type.events.count).to eq 2
    end
  end
end
