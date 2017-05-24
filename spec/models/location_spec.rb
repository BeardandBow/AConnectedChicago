require "rails_helper"

RSpec.describe Location, type: :model do
  context "validations" do
    it "is not valid without an address" do
      location = build_stubbed(:location, address: nil)

      expect(location).not_to be_valid
    end
  end

  context "associations" do
    it "belongs to an organization" do
      location = build_stubbed(:location)

      expect(location).to respond_to(:organization)
    end

    it "belongs to an neighborhood" do
      location = build_stubbed(:location)

      expect(location).to respond_to(:neighborhood)
    end
  end
end
