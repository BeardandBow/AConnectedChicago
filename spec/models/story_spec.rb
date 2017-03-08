require 'rails_helper'

RSpec.describe Story, type: :model do
  context "validations" do
    before :each do
      @neighborhood = create(:neighborhood, :with_user)
      @user = @neighborhood.users.first
    end

    it "is not valid without title" do
      story = build(:story, title: nil,
                            neighborhood_id: @neighborhood.id,
                            user_id: @user.id)

      expect(story).not_to be_valid
    end

    it "is not valid without author" do
      story = build(:story, author: nil,
                            neighborhood_id: @neighborhood.id,
                            user_id: @user.id)

      expect(story).not_to be_valid
    end

    it "is not valid without description" do
      story = build(:story, description: nil,
                            neighborhood_id: @neighborhood.id,
                            user_id: @user.id)

      expect(story).not_to be_valid
    end

    it "is not valid without body" do
      story = build(:story, body: nil,
                            neighborhood_id: @neighborhood.id,
                            user_id: @user.id)

      expect(story).not_to be_valid
    end

    it "is not valid without address" do
      story = build(:story, address: nil,
                            neighborhood_id: @neighborhood.id,
                            user_id: @user.id)

      expect(story).not_to be_valid
    end

    it "is valid with correct attributes" do
      story = create(:story, neighborhood_id: @neighborhood.id,
                             user_id: @user.id)

      expect(story).to be_valid
    end

    it "should have default status of 'pending'" do
      story = create(:story, neighborhood_id: @neighborhood.id,
                             user_id: @user.id)

      expect(story.status).to eq('pending')
    end

    it "belongs to a user" do
      story = create(:story, neighborhood_id: @neighborhood.id,
                             user_id: @user.id)

      expect(@user.stories.count).to eq(1)
      expect(Story.all.count).to eq(1)
      expect(story.user_id).to eq(@user.id)
    end

    it "belongs to a neighborhood" do
      story = create(:story, neighborhood_id: @neighborhood.id,
                             user_id: @user.id)

      expect(@neighborhood.stories.count).to eq(1)
      expect(Story.all.count).to eq(1)
      expect(story.neighborhood_id).to eq(@neighborhood.id)
    end
  end
end
