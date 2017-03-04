require 'rails_helper'

RSpec.describe Event, type: :model do
  context "validations" do
    it "is not valid without title" do
      event = Event.create(host_contact: "some guy",
                           description: "description",
                           address: "my place",
                           date: Date.tomorrow,
                           time: Time.now)

      expect(event).not_to be_valid
    end

    it "is not valid without host_contact" do
      event = Event.create(title: "event",
                           description: "description",
                           address: "my place",
                           date: Date.tomorrow,
                           time: Time.now)

      expect(event).not_to be_valid
    end

    it "is not valid without description" do
      event = Event.create(title: "event",
                           host_contact: "someguy@gmail.com",
                           address: "my place",
                           date: Date.tomorrow,
                           time: Time.now)

      expect(event).not_to be_valid
    end

    it "is not valid without address" do
      event = Event.create(title: "event",
                           host_contact: "someguy@gmail.com",
                           description: "description",
                           date: Date.tomorrow,
                           time: Time.now)

      expect(event).not_to be_valid
    end

    it "is not valid without date" do
      event = Event.create(title: "event",
                           host_contact: "someguy@gmail.com",
                           description: "description",
                           address: "my place",
                           time: Time.now)

      expect(event).not_to be_valid
    end

    it "is not valid without time" do
      event = Event.create(title: "event",
                           host_contact: "someguy@gmail.com",
                           description: "description",
                           address: "my place",
                           date: Date.tomorrow)

      expect(event).not_to be_valid
    end

    it "should validate format of host_contact email" do
      event = Event.create(title: "event",
                           host_contact: "some guy",
                           description: "description",
                           address: "my place",
                           date: Date.tomorrow,
                           time: Time.now)

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
end
