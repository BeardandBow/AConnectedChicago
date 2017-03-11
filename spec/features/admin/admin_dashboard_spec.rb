require 'rails_helper'

RSpec.feature "admin functionality" do

  before :each do
    @admin = create(:user, :admin)
    @c_l = create(:user, :community_leader)
    @artwork = create(:artwork)
    @event = create(:event, neighborhood_id: @c_l.neighborhood.id)
    @story = create(:story, neighborhood_id: @c_l.neighborhood.id)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit user_path(@admin)
  end

  context "admin interacts with pending submissions that do not have a community leader" do
    scenario "admin sees only pending submissions that do not have a community leader" do
      click_on "Unowned Pending Submissions"

      expect(page).to have_link(@artwork.title)
    end

    scenario "admin approves only pending submissions that do not have a community leader" do
      click_on "Unowned Pending Submissions"
      within ("#artwork-#{@artwork.id}") do
        choose("Approve")
      end
      click_on "Approve/Reject Submissions"

      expect(page).not_to have_link(@artwork.title)
    end

    scenario "admin rejects only pending submissions that do not have a community leader" do
      click_on "Unowned Pending Submissions"
      within ("#artwork-#{@artwork.id}") do
        choose("Reject")
      end
      click_on "Approve/Reject Submissions"

      expect(page).not_to have_link(@artwork.title)
    end
  end

  context "admin interacts with all pending submissions" do
    scenario "admin sees all pending submissions" do
      click_on "All Pending Submissions"

      expect(page).to have_link(@artwork.title)
      expect(page).to have_link(@event.title)
      expect(page).to have_link(@story.title)
    end

    scenario "admin approves any pending submissions regardless of ownership" do
      click_on "All Pending Submissions"
      within ("#event-#{@event.id}") do
        choose("Approve")
      end
      click_on "Approve/Reject Submissions"

      expect(page).not_to have_link(@event.title)
      expect(page).to have_link(@artwork.title)
      expect(page).to have_link(@story.title)
    end

    scenario "admin rejects any pending submissions regardless of ownership" do
      click_on "All Pending Submissions"
      within ("#story-#{@story.id}") do
        choose("Reject")
      end
      click_on "Approve/Reject Submissions"

      expect(page).not_to have_link(@story.title)
      expect(page).to have_link(@artwork.title)
      expect(page).to have_link(@event.title)
    end
  end
end
