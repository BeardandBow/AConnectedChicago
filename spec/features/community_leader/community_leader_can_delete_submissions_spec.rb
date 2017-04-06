require 'rails_helper'


RSpec.feature "community leader can delete submission" do

  before :each do
    @hood = create(:neighborhood, :with_community_leader, name: "Hyde Park")
    @user = @hood.users.find_by(role: "community_leader")
    @user2 = create(:user, :community_leader)
    @event = create(:event, organization: @user.organizations.first)
    @story = create(:story)
    @artwork = create(:artwork)
  end

  scenario "community leader deletes event that belongs to their organization" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit event_path(@event)

    expect(page).to have_button("Delete")

    click_button("Delete")

    expect(Event.all).to be_empty
    expect(current_path).to eq user_path(@user)
    expect(page).to have_content("Event Deleted")
  end

  scenario "community leader deletes story that belongs to their organization" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit story_path(@story)

    expect(page).to have_button("Delete")

    click_button("Delete")

    expect(Story.all).to be_empty
    expect(current_path).to eq user_path(@user)
    expect(page).to have_content("Story Deleted")
  end

  scenario "community leader deletes artwork that belongs to their organization" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit artwork_path(@artwork)

    expect(page).to have_button("Delete")

    click_button("Delete")

    expect(Artwork.all).to be_empty
    expect(current_path).to eq user_path(@user)
    expect(page).to have_content("Artwork Deleted")
  end

  context "community leader cant delete submissions they are not affiliated with" do
    scenario "community leader does not see delete button on event page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user2)

      visit event_path(@event)

      expect(page).not_to have_button("Delete")
    end

    scenario "community leader does not see delete button on story page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user2)

      visit story_path(@story)

      expect(page).not_to have_button("Delete")
    end

    scenario "community leader does not see delete button on artwork page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user2)

      visit artwork_path(@artwork)

      expect(page).not_to have_button("Delete")
    end
  end
end
