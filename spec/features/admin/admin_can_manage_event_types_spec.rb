require 'rails_helper'

RSpec.feature "admin can manage event types" do

  before :each do
    @admin = create(:user, :admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit user_path(@admin)
  end

  context "admin successfully adds an event type" do
    scenario "admin sees the button to add an event type" do
      expect(page).to have_button("Manage Event Types")
    end

    scenario "admin successfully adds an event type" do
      expect(Type.all.count).to eq(0)

      click_on "Manage Event Types"

      expect(current_path).to eq(admin_types_path)

      fill_in "Event Type Name", with: "New Event Type"
      click_on "Add Event Type"

      expect(Type.all.count).to eq(1)
      expect(Type.first.name).to eq("New Event Type")
    end
  end

  context "admin cannot add an event type" do
    scenario "admin submits an empty event type" do
      click_on "Manage Event Types"
      click_on "Add Event Type"

      expect(Type.all.count).to eq(0)
      expect(page).to have_content("Cannot create duplicate or blank Event Type")
    end
    scenario "admin submits a duplicate event type" do
      create(:type, name: "Snorkeling", category: "event")

      click_on "Manage Event Types"
      fill_in "Event Type Name", with: "Snorkeling"
      click_on "Add Event Type"

      expect(Type.all.count).to eq(1)
      expect(page).to have_content("Cannot create duplicate or blank Event Type")

    end
  end

  scenario "admin can delete an event type" do
    create(:type, name: "Snorkeling", category: "event")

    click_on "Manage Event Types"
    click_on "Delete Event Type"

    expect(Type.all.count).to eq(0)
    expect(page).to have_content("'Snorkeling' Event Type deleted")
  end


  context "sad paths" do
    scenario "admin tries to delete event type with event" do
      type = create(:type, name: "Snorkeling", category: "event")
      event = create(:event)
      type.events << event


      click_on "Manage Event Types"
      click_on "Delete Event Type"

      expect(page).to have_content("There are Events with the type 'Snorkeling' and it cannot be deleted")
    end
  end
end
