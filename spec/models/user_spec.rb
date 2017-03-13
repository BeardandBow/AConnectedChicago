require 'rails_helper'

RSpec.describe User, type: :model do
  context "validations" do

    it "is not valid without email" do
      user = build_stubbed(:user, email: "")

      expect(user).not_to be_valid
    end

    it "is not valid without a first name" do
      user = build_stubbed(:user, first_name: "")

      expect(user).not_to be_valid
    end

    it "is not valid without a last name" do
      user = build_stubbed(:user, last_name: "")

      expect(user).not_to be_valid
    end

    it "is not valid without password" do
      user = build_stubbed(:user, password: "")

      expect(user).not_to be_valid
    end

    it "is not valid with incorrect password confirmation" do
      user = build_stubbed(:user, password_confirmation: "closesesame")

      expect(user).not_to be_valid
    end

    it "should validate format of email" do
      user = build(:user, email: "some guy")

      expect(user).not_to be_valid
    end

    it "should have unique email" do
      create(:user, email: "someguy@gmail.com")
      user = build(:user, email: "someguy@gmail.com")

      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "is valid with correct attributes" do
      user = build_stubbed(:user)

      expect(user).to be_valid
    end
  end

  context "associations" do
    it "belongs to a neighborhood" do
      user = build_stubbed(:user)

      expect(user).to respond_to(:neighborhood)
    end

    it "can have many organizations" do
      user1 = create(:user)
      user2 = create(:user, :with_organizations)

      expect(user1).to respond_to(:organizations)
      expect(user1.organizations.count).to eq 0
      expect(user2.organizations.count).to eq 2
    end
  end

  context "custom methods" do
    it ".promote changes role to Community Leader" do
      user = create(:user)

      expect(user.role).to eq("user")
      user.promote
      expect(user.role).to eq("community_leader")
    end
  end
end
