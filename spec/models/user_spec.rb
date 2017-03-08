require 'rails_helper'

RSpec.describe User, type: :model do
  context "validations" do
    before :each do
      @neighborhood = create(:neighborhood)
    end

    it "is not valid without email" do
      user = build(:user, email: "",
                          neighborhood_id: @neighborhood.id)

      expect(user).not_to be_valid
    end

    it "is not valid without password" do
      user = build(:user, password: "",
                          neighborhood_id: @neighborhood.id)

      expect(user).not_to be_valid
    end

    it "is not valid with incorrect password confirmation" do
      user = build(:user, password_confirmation: "closesesame",
                          neighborhood_id: @neighborhood.id)

      expect(user).not_to be_valid
    end

    it "should validate format of email" do
      user = build(:user, email: "some guy",
                          neighborhood_id: @neighborhood.id)

      expect(user).not_to be_valid
    end

    it "should have unique email" do
      create(:user, neighborhood_id: @neighborhood.id)
      user = build(:user, neighborhood_id: @neighborhood.id)

      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "is valid with correct attributes" do
      user = create(:user, neighborhood_id: @neighborhood.id)

      expect(user).to be_valid
    end
  end
end
