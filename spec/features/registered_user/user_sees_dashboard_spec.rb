require 'rails_helper'

RSpec.feature "user sees dashboard" do
  before :all do
    create(:type)
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
    expect(page).to have_button("Share your Event")
    expect(page).to have_button("Share your Story")
    expect(page).to have_button("Share your Artwork")
  end

  context "user submits content to a community leader" do

    scenario "user submits event" do
      organization = create(:organization)
      # As a logged-in user
      # when I visit my dashboard
      visit user_path(@user)
      # and click "Share your Event"
      click_on "Share your Event"

      expect(page).to have_content("By hosting your events on Connected Chicago, you can foster community-building opportunities for all of Chicago. Events hosted can include everything from poetry slams, open mics, shared meals, sporting events, religious prayer services to circle trainings, restorative justice workshops, issue-based community discussions and so much more.")

      expect(page).to have_content("Click here to see important instructions for submitting an event")

      # and fill in the information for a new event in the text fields
      fill_in "Title of Event", with: "event"
      fill_in "Host Contact Email", with: "someguy@gmail.com"
      select organization.name, from: "event_organization_id"
      fill_in "Brief Description of Event", with: "description"
      fill_in "Location of Event (Read Important Instructions)", with: "5699 S Ellis Ave, Chicago, IL 60637"
      select "Peace Circle", from: "event_type_id"
      fill_in "Event Website Link", with: "https://www.youtube.com/watch?v=eRBOgtp0Hac"
      select Date.tomorrow.year, from: "event_date_1i"
      select Date.tomorrow.strftime("%B"), from: "event_date_2i"
      select Date.tomorrow.day, from: "event_date_3i"
      select Time.now.strftime("%I %p"), from: "event_time_4i"
      select "30", from: "event_time_5i"
      # and click submit
      click_on "Share your Event"
      # I should be on my dashboard
      expect(current_path).to eq(user_path(@user))
      # and I should see text that my event has been sent to a community leader for approval.
      expect(page).to have_content("Your Event has been sent to a Community Leader for approval.")
    end

    scenario "user submits story" do
      visit user_path(@user)
      # and when I click "Share your Story"
      click_on "Share your Story"

      expect(page).to have_content("By uploading your stories, you too can help build empathy and share what is needed to connect Chicago by going to the source - us fellow Chicagoans.The online storytelling component of the campaign is not a substitute for real-life engagement or proximity with persons, but a supplement for engaging these, at times unknown, Chicago stories.")

      expect(page).to have_content("Click here to see important instructions for submitting a story")

      # and fill in the information for a new event in the text fields
      fill_in "Title of Story", with: "story"
      fill_in "Author/s of Story", with: "some guy"
      fill_in "Brief Description of Story", with: "description"
      fill_in "Your Written Story", with: "body"
      fill_in "Location/Address of Story (Read Important Instructions)", with: "5699 S Ellis Ave, Chicago, IL 60637"
      fill_in "Insert YouTube Link", with: "https://www.youtube.com/watch?v=eRBOgtp0Hac"
      # and click submit
      click_on "Share your Story"
      # I should be on my dashboard
      expect(current_path).to eq(user_path(@user))
      # and I should see text that my story has been sent to a community leader for approval.
      expect(page).to have_content("Your Story has been sent to a Community Leader for approval.")
    end

    scenario "user submits artwork" do
      visit user_path(@user)
      # and when I click "Share your Artwork"
      click_on "Share your Artwork"

      expect(page).to have_content("Art can be a collective microphone for us to be heard. Posting art on Connected Chicago, and tagging your neighborhood allows Chicago to dialogue both within and across neighborhoods. Whether it be through music, public artworks, murals, sculptures, architecture, your personal drawings, paintings and/or photography, etc., each neighborhood will have the opportunity to be heard. The website functions as a kind of Living Document/Canvas gathering testimonies, personal truths, and artistic expressions reflecting a need and desire for an interconnected Chicago.")

      expect(page).to have_content("Click here to see important instructions for submitting artwork")

      # and fill in the information for a new event in the text fields
      fill_in "Title of Artwork", with: "artwork"
      fill_in "Name of Artist/s", with: "some guy"
      fill_in "Brief Description of Artwork", with: "description"
      fill_in "Location/Address of Artwork (Read Important Instructions)", with: "5699 S Ellis Ave, Chicago, IL 60637"
      # and click submit
      click_on "Share your Art"
      # I should be on my dashboard
      expect(current_path).to eq(user_path(@user))
      # and I should see text that my artwork has been sent to a community leader for approval.
      expect(page).to have_content("Your Artwork has been sent to a Community Leader for approval.")
    end
  end

  context "user submits incomplete content" do

    scenario "user submits incomplete event" do
      visit user_path(@user)

      click_on "Share your Event"
      click_on "Share your Event"

      expect(current_path).to eq(events_path)
      expect(page).to have_content("There is a problem with your submission. Please correct and resubmit.")
    end

    scenario "user submits incomplete story" do
      visit user_path(@user)

      click_on "Share your Story"
      click_on "Share your Story"

      expect(current_path).to eq(stories_path)
      expect(page).to have_content("There is a problem with your submission. Please correct and resubmit.")
    end

    scenario "user submits incomplete artwork" do
      visit user_path(@user)

      click_on "Share your Artwork"
      click_on "Share your Art"

      expect(current_path).to eq(artworks_path)
      expect(page).to have_content("There is a problem with your submission. Please correct and resubmit.")
    end
  end
end
