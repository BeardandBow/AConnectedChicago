require 'rails_helper'

RSpec.feature "admin functionality" do
  before :all do
    @neighborhood = create(:neighborhood, name: "Hyde Park")
    create(:neighborhood, name: "Rogers Park")
    @organization = create(:organization)
  end

  before :each do
    @admin = create(:user, :admin, neighborhood: @neighborhood)
    @c_l = create(:user, :community_leader, neighborhood: @neighborhood)
    @neighborhood.users << @c_l
    @artwork = create(:artwork, address: "1543 W Morse Ave, Chicago, IL 60626") # address is in Rogers Park
    @event = create(:event)
    @story = create(:story, organization: @organization, address: "1543 W Morse Ave, Chicago, IL 60626")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit user_path(@admin)
  end

  context "admin interacts with pending submissions that do not have a community leader" do
    scenario "admin sees only pending submissions that do not have a community leader" do
      click_on "See Unowned Pending Submissions"

      expect(page).to have_link(@artwork.title)
      expect(page).not_to have_link(@event.title)
      expect(page).to have_link(@story.title)
    end

    scenario "admin approves only pending submissions that do not have a community leader" do
      click_on "See Unowned Pending Submissions"
      within ("#artwork-#{@artwork.id}") do
        choose("Approve")
      end
      click_on "Approve/Reject Submissions"

      expect(page).not_to have_link(@artwork.title)
      expect(@artwork.reload.status).to eq("approved")
    end

    scenario "admin rejects only pending submissions that do not have a community leader" do
      click_on "See Unowned Pending Submissions"
      within ("#artwork-#{@artwork.id}") do
        choose("Reject")
      end
      click_on "Approve/Reject Submissions"

      expect(page).not_to have_link(@artwork.title)
      expect(@artwork.reload.status).to eq("rejected")
    end
  end

  context "admin interacts with all pending submissions" do
    scenario "admin sees all pending submissions" do
      click_on "See All Pending Submissions"

      expect(page).to have_link(@artwork.title)
      expect(page).to have_link(@event.title)
      expect(page).to have_link(@story.title)
    end

    scenario "admin approves any pending submissions regardless of ownership" do
      click_on "See All Pending Submissions"
      within ("#event-#{@event.id}") do
        choose("Approve")
      end
      click_on "Approve/Reject Submissions"

      expect(page).not_to have_link(@event.title)
      expect(page).to have_link(@artwork.title)
      expect(page).to have_link(@story.title)
      expect(@event.reload.status).to eq("approved")
    end

    scenario "admin rejects any pending submissions regardless of ownership" do
      click_on "See All Pending Submissions"
      within ("#story-#{@story.id}") do
        choose("Reject")
      end
      click_on "Approve/Reject Submissions"

      expect(page).not_to have_link(@story.title)
      expect(page).to have_link(@artwork.title)
      expect(page).to have_link(@event.title)
      expect(@story.reload.status).to eq("rejected")
    end
  end

  context "admin promotes user to community leader" do
    scenario "admin promotes existing user" do
      user = create(:user, neighborhood: @neighborhood)

      click_on "Add Community Leader"
      fill_in "User Email", with: user.email
      click_on "Promote User"

      expect(page).to have_content("#{user.email} has been promoted to Community Leader.")
      expect(user.reload.role).to eq("community_leader")
    end

    scenario "admin promotes non-existent user" do
      click_on "Add Community Leader"
      fill_in "User Email", with: "idontexist@gmail.com"
      click_on "Promote User"

      expect(page).to have_content("Could not find a User with that email.")
    end
  end
end
