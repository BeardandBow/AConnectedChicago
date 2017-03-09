require 'rails_helper'

RSpec.describe Event, type: :model do
  context "validations" do

    it "is not valid without title" do
      event = build(:event, title: nil)

      expect(event).not_to be_valid
    end

    it "is not valid without host_contact" do
      event = build(:event, host_contact: nil)

      expect(event).not_to be_valid
    end

    it "is not valid without description" do
      event = build(:event, description: nil)

      expect(event).not_to be_valid
    end

    it "is not valid without address" do
      event = build(:event, address: nil)

      expect(event).not_to be_valid
    end

    it "is not valid without date" do
      event = build(:event, date: nil)

      expect(event).not_to be_valid
    end

    it "is not valid without time" do
      event = build(:event, time: nil)

      expect(event).not_to be_valid
    end

    it "should validate format of host_contact email" do
      event = build(:event, host_contact: "someguygmailcom")

      expect(event).not_to be_valid
    end

    it "is valid with correct attributes" do
      event = create(:event)

      expect(event).to be_valid
    end

    it "should have default status of 'pending'" do
      event = create(:event)

      expect(event.status).to eq('pending')
    end

    it "belongs to a user" do
      event = create(:event)

      expect(event).to respond_to(:user)
    end

    it "belongs to a neighborhood" do
      event = create(:event)

      expect(event).to respond_to(:neighborhood)
    end

    it "belongs to an organization" do
      event = create(:event)

      expect(event).to respond_to(:organization)
    end
  end
end
