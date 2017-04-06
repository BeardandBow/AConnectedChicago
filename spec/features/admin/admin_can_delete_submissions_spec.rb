require 'rails_helper'


RSpec.feature "user can delete submission" do

  before :each do
    @user  = create(:user, :admin)
    @event = create(:event)
    @story = create(:story)
    @artwork = create(:artwork)
  end

  scenario "user deletes event they created" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit event_path(@event)

    expect(page).to have_button("Delete")

    click_button("Delete")

    expect(Event.all).to be_empty
    expect(current_path).to eq user_path(@user)
    expect(page).to have_content("Event Deleted")
  end

  scenario "user deletes story they created" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit story_path(@story)

    expect(page).to have_button("Delete")

    click_button("Delete")

    expect(Story.all).to be_empty
    expect(current_path).to eq(user_path(@user))
    expect(page).to have_content("Story Deleted")
  end

  scenario "user deletes artwork they created" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit artwork_path(@artwork)

    expect(page).to have_button("Delete")

    click_button("Delete")

    expect(Artwork.all).to be_empty
    expect(current_path).to eq(user_path(@user))
    expect(page).to have_content("Artwork Deleted")
  end
end