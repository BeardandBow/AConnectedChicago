require 'rails_helper'

RSpec.feature "community leader sees dashboard" do
  before :all do
    @neighborhood = create(:neighborhood, name: "Hyde Park")
  end

  before :each do
    # As a community leader
    @type = create(:type)
    @user = create(:user, :community_leader, neighborhood: @neighborhood)
    @artwork = create(:artwork)
    @event = create(:event, organization: @user.organizations.first, type: @type)
    @story = create(:story)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  context "community leader sees link to pending submissions" do
    scenario "community leader clicks link and sees pending submissions" do
      # When I visit my dashboard
      visit user_path(@user)
      # I should see a link to view submitted content
      expect(page).to have_button("Pending Submissions")
      # and when I click on the link
      click_on "Pending Submissions"

      # I should see a list of pending submissions with links to each
      expect(page).to have_link(@story.title)
      expect(page).to have_link(@artwork.title)
      expect(page).to have_link(@event.title)
    end

    scenario "community leader only sees submissions for their organization or neighborhood" do
      different_user = create(:user, :community_leader)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(different_user)
      visit user_path(different_user)

      click_on "Pending Submissions"

      expect(page).to have_content("You have no pending submissions")
      expect(page).not_to have_content(@artwork.title)
      expect(page).not_to have_content(@story.title)
      expect(page).not_to have_content(@event.title)
    end
  end

  context "community leader sees submission details" do
    scenario "community leader sees event details" do
      visit user_path(@user)
      click_on "Pending Submissions"
      click_on @event.title
      expect(page).to have_content(@event.title)
      expect(page).to have_content(@event.organization.name)
      expect(page).to have_content(@event.formatted_date_time)
      expect(page).to have_content("Contact for more information")
      expect(page).to have_content(@event.description)
      expect(page).to have_content(@event.type.name)
      expect(page).to have_content(@event.address)
    end

    scenario "community leader sees artwork details" do
      visit user_path(@user)
      click_on "Pending Submissions"
      click_on @artwork.title
      expect(page).to have_content(@artwork.title)
      expect(page).to have_content(@artwork.artist)
      expect(page).to have_content(@artwork.description)
      expect(page).to have_content(@artwork.address)
    end

    scenario "community leader sees story details" do
      visit user_path(@user)
      click_on "Pending Submissions"
      click_on @story.title
      expect(page).to have_content(@story.title)
      expect(page).to have_content(@story.author)
      expect(page).to have_content(@story.description)
      expect(page).to have_content(@story.body)
    end
  end

  context "community leader approves submissions" do
    scenario "community leader approves event" do
      visit user_path(@user)
      click_on "Pending Submissions"
      within ("#event-#{@event.id}") do
        choose("Approve")
      end
      click_on "Approve/Reject Submissions"
      expect(page).not_to have_content(@event.title)
      expect(page).to have_content(@artwork.title)
      expect(page).to have_content(@story.title)
      expect(@event.reload.status).to eq("approved")
    end

    scenario "community leader approves artwork" do
      visit user_path(@user)
      click_on "Pending Submissions"
      within ("#artwork-#{@artwork.id}") do
        choose("Approve")
      end
      click_on "Approve/Reject Submissions"
      expect(page).not_to have_content(@artwork.title)
      expect(page).to have_content(@event.title)
      expect(page).to have_content(@story.title)
      expect(@artwork.reload.status).to eq("approved")
    end

    scenario "community leader approves story" do
      visit user_path(@user)
      click_on "Pending Submissions"
      within ("#story-#{@story.id}") do
        choose("Approve")
      end
      click_on "Approve/Reject Submissions"
      expect(page).not_to have_content(@story.title)
      expect(page).to have_content(@artwork.title)
      expect(page).to have_content(@event.title)
      expect(@story.reload.status).to eq("approved")
    end
  end

  context "community leader denies submissions" do
    scenario "community leader denies event" do
      visit user_path(@user)
      click_on "Pending Submissions"
      within ("#event-#{@event.id}") do
        choose("Reject")
      end
      click_on "Approve/Reject Submissions"
      expect(page).not_to have_content(@event.title)
      expect(page).to have_content(@artwork.title)
      expect(page).to have_content(@story.title)
      expect(@event.reload.status).to eq("rejected")
    end

    scenario "community leader denies artwork" do
      visit user_path(@user)
      click_on "Pending Submissions"
      within ("#artwork-#{@artwork.id}") do
        choose("Reject")
      end
      click_on "Approve/Reject Submissions"
      expect(page).not_to have_content(@artwork.title)
      expect(page).to have_content(@story.title)
      expect(page).to have_content(@event.title)
      expect(@artwork.reload.status).to eq("rejected")
    end

    scenario "community leader denies story" do
      visit user_path(@user)
      click_on "Pending Submissions"
      within ("#story-#{@story.id}") do
        choose("Reject")
      end
      click_on "Approve/Reject Submissions"
      expect(page).not_to have_content(@story.title)
      expect(page).to have_content(@artwork.title)
      expect(page).to have_content(@event.title)
      expect(@story.reload.status).to eq("rejected")
    end
  end

  context "community leader's submissions are automagically approved" do
    scenario "community leader submits an event" do
      organization = create(:organization)
      # As a logged-in user
      # when I visit my dashboard
      visit user_path(@user)
      # and click "Share your Event"
      click_on "Share your Event"

      # and fill in the information for a new event in the text fields
      fill_in "Title of Event", with: "event"
      fill_in "Host Contact Email", with: "someguy@gmail.com"
      select organization.name, from: "event_organization_id"
      fill_in "Brief Description of Event", with: "description"
      fill_in "Location of Event (Read Important Instructions)", with: "5699 S Ellis Ave, Chicago, IL 60637"
      select "Peace Circle", from: "event_type_id"
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
      expect(page).to have_content("Your Event has been created.")
      expect(Event.last.status).to eq("approved")
    end

    scenario "community leader submits an story" do
      # As a logged-in user
      # when I visit my dashboard
      visit user_path(@user)
      # and click "Share your Event"
      click_on "Share your Story"

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
      # and I should see text that my event has been sent to a community leader for approval.
      expect(page).to have_content("Your Story has been created.")
      expect(Story.last.status).to eq("approved")
    end

    scenario "community leader submits an artwork" do
      # As a logged-in user
      # when I visit my dashboard
      visit user_path(@user)
      # and click "Share your Event"
      click_on "Share your Artwork"
      # and fill in the information for a new event in the text fields
      fill_in "Title of Artwork", with: "artwork"
      fill_in "Name of Artist/s", with: "some guy"
      fill_in "Brief Description of Artwork", with: "description"

      fill_in "Location/Address of Artwork (Read Important Instructions)", with: "5699 S Ellis Ave, Chicago, IL 60637"
      # and click submit
      click_on "Share your Art"
      # I should be on my dashboard
      expect(current_path).to eq(user_path(@user))
      # and I should see text that my event has been sent to a community leader for approval.
      expect(page).to have_content("Your Artwork has been created.")
      expect(Artwork.last.status).to eq("approved")
    end
  end
end
