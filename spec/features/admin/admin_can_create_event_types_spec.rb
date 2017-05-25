require 'rails_helper'

RSpec.feature "admin can create event types" do

  before :each do
    @admin = create(:user, :admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit user_path(@admin)
  end

  context "admin successfully adds an event type" do
    scenario "admin sees the button to add an event type" do
      expect(page).to have_content("Add an Event Type")
    end

    scenario "admin successfully adds an event type" do
      expect(Type.all.count).to eq(0)

      click_on "Add an Event Type"

      expect(current_path).to eq(types_path)

      fill_in "Event Type", with: "New Event Type"
      click_on "Add Event Type"

      expect(current_path).to eq(user_path(@admin))
      expect(Type.all.count).to eq(1)
      expect(Type.first.name).to eq("New Event Type")
    end
  end
end
