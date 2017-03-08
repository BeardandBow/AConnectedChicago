require 'rails_helper'

RSpec.describe Event, type: :model do
  context "validations" do
    before :each do
      @neighborhood = create(:neighborhood, :with_user)
      @user = @neighborhood.users.first
    end

    it "is not valid without title" do
      event = build(:event, title: nil,
                            neighborhood_id: @neighborhood.id,
                            user_id: @user.id)

      expect(event).not_to be_valid
    end

    it "is not valid without host_contact" do
      event = build(:event, host_contact: nil,
                            neighborhood_id: @neighborhood.id,
                            user_id: @user.id)

      expect(event).not_to be_valid
    end

    it "is not valid without description" do
      event = build(:event, description: nil,
                            neighborhood_id: @neighborhood.id,
                            user_id: @user.id)

      expect(event).not_to be_valid
    end

    it "is not valid without address" do
      event = build(:event, address: nil,
                            neighborhood_id: @neighborhood.id,
                            user_id: @user.id)

      expect(event).not_to be_valid
    end

    it "is not valid without date" do
      event = build(:event, date: nil,
                            neighborhood_id: @neighborhood.id,
                            user_id: @user.id)

      expect(event).not_to be_valid
    end

    it "is not valid without time" do
      event = build(:event, time: nil,
                            neighborhood_id: @neighborhood.id,
                            user_id: @user.id)

      expect(event).not_to be_valid
    end

    it "should validate format of host_contact email" do
      event = build(:event, host_contact: "someguygmailcom",
                            neighborhood_id: @neighborhood.id,
                            user_id: @user.id)

      expect(event).not_to be_valid
    end

    it "is valid with correct attributes" do
      event = create(:event, neighborhood_id: @neighborhood.id,
                             user_id: @user.id)

      expect(event).to be_valid
    end

    it "should have default status of 'pending'" do
      event = create(:event, neighborhood_id: @neighborhood.id,
                             user_id: @user.id)

      expect(event.status).to eq('pending')
    end

    it "belongs to a user" do
      event = create(:event, neighborhood_id: @neighborhood.id,
                             user_id: @user.id)

      expect(@user.events.count).to eq(1)
      expect(Event.all.count).to eq(1)
      expect(event.user_id).to eq(@user.id)
    end

    it "belongs to a neighborhood" do
      event = create(:event, neighborhood_id: @neighborhood.id,
                             user_id: @user.id)

      expect(@neighborhood.events.count).to eq(1)
      expect(Event.all.count).to eq(1)
      expect(event.neighborhood_id).to eq(@neighborhood.id)
    end
  end
end
