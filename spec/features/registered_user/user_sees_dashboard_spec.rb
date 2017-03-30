require 'rails_helper'

RSpec.feature "user sees dashboard" do
  before :all do
    create(:neighborhood, name: "Hyde Park")
  end
  before :each do
    @user = create(:user, :registered_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  scenario "user sees links on dashboard" do
    # As a logged_in user
    # When I visit my dashboard
    visit user_path(@user)
    # I should see links for adding an event, a story, and an art piece
    expect(page).to have_button("Submit Event")
    expect(page).to have_button("Submit Story")
    expect(page).to have_button("Submit Artwork")
  end

  context "user submits content to a community leader" do

    scenario "user submits event" do
      organization = create(:organization)
      # As a logged-in user
      # when I visit my dashboard
      visit user_path(@user)
      # and click "Submit Event"
      click_on "Submit Event"

      # and fill in the information for a new event in the text fields
      fill_in "Title", with: "event"
      fill_in "Host Contact Email", with: "someguy@gmail.com"
      select organization.name, from: "event_organization"
      fill_in "Description", with: "description"
      fill_in "Location", with: "5699 S Ellis Ave, Chicago, IL 60637"
      select Date.tomorrow.year, from: "event_date_1i"
      select Date.tomorrow.strftime("%B"), from: "event_date_2i"
      select Date.tomorrow.day, from: "event_date_3i"
      select Time.now.strftime("%I %p"), from: "event_time_4i"
      select "30", from: "event_time_5i"
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
      fill_in "Location", with: "5699 S Ellis Ave, Chicago, IL 60637"
      fill_in "YouTube Link", with: "https://www.youtube.com/watch?v=eRBOgtp0Hac"
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
      fill_in "Location", with: "5699 S Ellis Ave, Chicago, IL 60637"
      # and click submit
      click_on "Submit Artwork for Approval"
      # I should be on my dashboard
      expect(current_path).to eq(user_path(@user))
      # and I should see text that my artwork has been sent to a community leader for approval.
      expect(page).to have_content("Your Artwork has been sent to a Community Leader for approval.")
    end
  end

  context "user submits incomplete content" do

    scenario "user submits incomplete event" do
      visit user_path(@user)

      click_on "Submit Event"
      click_on "Submit Event for Approval"

      expect(current_path).to eq(events_path)
      expect(page).to have_content("There is a problem with your submission. Please correct and resubmit.")
    end

    scenario "user submits incomplete story" do
      visit user_path(@user)

      click_on "Submit Story"
      click_on "Submit Story for Approval"

      expect(current_path).to eq(stories_path)
      expect(page).to have_content("There is a problem with your submission. Please correct and resubmit.")
    end

    scenario "user submits incomplete artwork" do
      visit user_path(@user)

      click_on "Submit Artwork"
      click_on "Submit Artwork for Approval"

      expect(current_path).to eq(artworks_path)
      expect(page).to have_content("There is a problem with your submission. Please correct and resubmit.")
    end
  end
end
