require 'rails_helper'

RSpec.feature "user sees dashboard" do
  before :each do
    neighborhood = create(:neighborhood, :with_user)
    @user = neighborhood.users.first
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  scenario "user sees links on dashboard" do
    # As a logged_in user
    # When I visit my dashboard
    visit user_path(@user)
    # I should see links for adding an event, a story, and an art piece
    expect(page).to have_link("Submit Event")
    expect(page).to have_link("Submit Story")
    expect(page).to have_link("Submit Artwork")
  end

  context "user submits content to a community leader" do

    scenario "user submits event" do
      # As a logged-in user
      # when I visit my dashboard
      visit user_path(@user)
      # and click "Submit Event"
      click_on "Submit Event"
      # and fill in the information for a new event in the text fields
      fill_in "Title", with: "event"
      fill_in "Host Contact Email", with: "someguy@gmail.com"
      fill_in "Description", with: "description"
      fill_in "Location", with: "619 Logan St., Denver, CO 80203"
      fill_in "Date", with: Date.tomorrow
      fill_in "Time", with: Time.now
      # and click submit
      click_on "Submit Event for Approval"
      # I should be on my dashboard
      expect(current_path).to eq(user_path(@user))
      # and I should see text that my event has been sent to a community leader for approval.
      expect(page).to have_content("Your Event has been sent to a Community Leader for approval.")
    end

    scenario "user submits story" do
      visit user_path(@user)
      # and when I click "Submit Story"
      click_on "Submit Story"
      # and fill in the information for a new event in the text fields
      fill_in "Title", with: "story"
      fill_in "Author", with: "some guy"
      fill_in "Description", with: "description"
      fill_in "Story", with: "body"
      fill_in "Location", with: "619 Logan St., Denver, CO 80203"
      # and click submit
      click_on "Submit Story for Approval"
      # I should be on my dashboard
      expect(current_path).to eq(user_path(@user))
      # and I should see text that my story has been sent to a community leader for approval.
      expect(page).to have_content("Your Story has been sent to a Community Leader for approval.")
    end

    scenario "user submits artwork" do
      visit user_path(@user)
      # and when I click "Submit Artwork"
      click_on "Submit Artwork"
      # and fill in the information for a new event in the text fields
      fill_in "Title", with: "artwork"
      fill_in "Artist", with: "some guy"
      fill_in "Description", with: "description"
      fill_in "Location", with: "619 Logan St., Denver, CO 80203"
      # and click submit
      click_on "Submit Artwork for Approval"
      # I should be on my dashboard
      expect(current_path).to eq(user_path(@user))
      # and I should see text that my artwork has been sent to a community leader for approval.
      expect(page).to have_content("Your Artwork has been sent to a Community Leader for approval.")
    end
  end
end
