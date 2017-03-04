require 'rails_helper'

RSpec.describe User, type: :model do
  context "validations" do
    it "is not valid without email" do
      user = User.create(password: "opensesame")

      expect(user).not_to be_valid
    end

    it "is not valid without password" do
      user = User.create(email: "someguy@gmail.com")

      expect(user).not_to be_valid
    end

    it "should validate format of email" do
      user = User.create(email: "some guy",
                         password: "opensesame")

      expect(user).not_to be_valid
    end

    it "should have unique email" do
      create(:user)
      user = build(:user)

      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "is valid with correct attributes" do
      user = create(:user)

      expect(user).to be_valid
    end
  end
end
