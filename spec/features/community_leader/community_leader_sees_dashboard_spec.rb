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
      expect(page).to have_link("Approve or Deny Submissions")
      # and when I click on the link
      click_on("Approve or Deny Submissions")
      # I should see a list of pending submissions
      expect(page).to have_content(@story.title)
      expect(page).to have_content(@artwork.title)
      expect(page).to have_content(@event.title)
    end
  end
end
