require 'rails_helper'

RSpec.feature "community leader sees dashboard" do

  before :each do
    # As a community leader
    @user = create(:user, :community_leader)
    @artwork = create(:artwork)
    @event = create(:event)
    @story = create(:story)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  context "community leader sees link to pending submissions" do
    scenario "community leader clicks link and sees pending submissions" do
      # When I visit my dashboard
      visit user_path(@user)
      # I should see a link to view submitted content
      expect(page).to have_link("Pending Submissions")
      # and when I click on the link
      click_on "Pending Submissions"
      # I should see a list of pending submissions with links to each
      expect(page).to have_link(@story.title)
      expect(page).to have_link(@artwork.title)
      expect(page).to have_link(@event.title)
    end
  end

  context "community leader sees submission details" do
    scenario "community leader sees event details" do
      visit user_path(@user)
      click_on "Pending Submissions"
      click_on(@event.title)
      expect(page).to have_content(@event.title)
      expect(page).to have_content(@event.host_contact)
      expect(page).to have_content(@event.description)
      expect(page).to have_content(@event.address)
      expect(page).to have_content(@event.date)
      expect(page).to have_content(@event.time)
      expect(page).to have_content(@event.organization.name)
    end

    scenario "community leader sees artwork details" do
      visit user_path(@user)
      click_on "Pending Submissions"
      click_on(@artwork.title)
      expect(page).to have_content(@artwork.title)
      expect(page).to have_content(@artwork.artist)
      expect(page).to have_content(@artwork.description)
      expect(page).to have_content(@artwork.address)
    end

    scenario "community leader sees story details" do
      visit user_path(@user)
      click_on "Pending Submissions"
      click_on(@story.title)
      expect(page).to have_content(@story.title)
      expect(page).to have_content(@story.author)
      expect(page).to have_content(@story.description)
      expect(page).to have_content(@story.address)
      expect(page).to have_content(@story.body)
    end
  end

  context "community leader approves submissions" do
    scenario "community leader approves event" do
      visit user_path(@user)
      click_on "Pending Submissions"
      within ("#event-#{@event.id}") do
        choose("Agac "pprove")
      end
      click_on "Approve/Deny Submissions"
      expect(page).not_to have_content(@event.title)
    end

    scenario "community leader approves artwork" do
      visit user_path(@user)
      click_on "Pending Submissions"
      within ("#artwork-#{@artwork.id}") do
        choose("Approve")
      end
      click_on "Approve/Deny Submissions"
      expect(page).not_to have_content(@artwork.title)
    end

    scenario "community leader approves story" do
      visit user_path(@user)
      click_on "Pending Submissions"
      within ("#story-#{@story.id}") do
        choose("Approve")
      end
      click_on "Approve/Deny Submissions"
      expect(page).not_to have_content(@story.title)
    end
  end
end
