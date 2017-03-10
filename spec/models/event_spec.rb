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
  end

  context "associations" do

    before :each do
      @event = create(:event)
    end

    it "belongs to a user" do
      expect(@event).to respond_to(:user)
    end

    it "belongs to a neighborhood" do
      expect(@event).to respond_to(:neighborhood)
    end

    it "belongs to an organization" do
      expect(@event).to respond_to(:organization)
    end
  end

  context "custom methods" do
    before :each do
      @event = create(:event)
    end

    it "returns a path with .path" do
      expect(@event.path).to eq("/events/#{@event.id}")
    end

    it "returns a type with .type" do
      expect(@event.type).to eq("event")
    end

    it ".set_pkey sets a 'primary key' based on table and id" do
      event = build(:event)
      event.set_pkey
      expect(event.pkey).to eq("EV-#{event.id}")
    end

    it ".approve sets event status to approved" do
      expect(@event.status).to eq("pending")
      @event.approve
      expect(@event.status).to eq("approved")
    end

    it ".reject sets event status to rejected" do
      expect(@event.status).to eq("pending")
      @event.reject
      expect(@event.status).to eq("rejected")
    end
  end
end
