require 'rails_helper'


RSpec.feature "admin can delete submission" do

  before :each do
    @type = create(:type)
    @admin  = create(:user, :admin)
    @event = create(:event, type: @type)
    @story = create(:story)
    @artwork = create(:artwork)
  end

  scenario "admin deletes event they created" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit event_path(@event)

    expect(page).to have_button("Delete")

    click_button("Delete")

    expect(Event.all).to be_empty
    expect(current_path).to eq user_path(@admin)
    expect(page).to have_content("Event Deleted")
  end

  scenario "admin deletes story they created" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit story_path(@story)

    expect(page).to have_button("Delete")

    click_button("Delete")

    expect(Story.all).to be_empty
    expect(current_path).to eq(user_path(@admin))
    expect(page).to have_content("Story Deleted")
  end

  scenario "admin deletes artwork they created" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit artwork_path(@artwork)

    expect(page).to have_button("Delete")

    click_button("Delete")

    expect(Artwork.all).to be_empty
    expect(current_path).to eq(user_path(@admin))
    expect(page).to have_content("Artwork Deleted")
  end
end
