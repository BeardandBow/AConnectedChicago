require 'rails_helper'

RSpec.feature "visitor sees homepage", js: true do
  scenario "visitor sees intro popup on homepage" do
    visit root_path

    expect(page).to have_css("#modal")
    expect(page).to have_content("Welcome to Connected Chicago!")
  end

  scenario "visitor sees links to view content" do
    visit root_path

    expect(page).to have_button("All")
    expect(page).to have_button("Peace Circles")
    expect(page).to have_button("Events")
    expect(page).to have_button("Stories")
    expect(page).to have_button("Art")
  end

  context "visitor views content" do
    scenario "visitor views organizations outside of neighborhood" do
      type1 = create(:type, name: "RJ Hub", category: "organization")
      type2 = create(:type, name: "Church", category: "organization")
      create(:neighborhood, name: "Hyde Park")
      organization1 = create(:organization, :with_locations, type: type1)
      organization2 = create(:organization, :with_locations, type: type2, description: "Different description")

      visit root_path
      sleep(0.5)

      select "All", from: "organization_type_select"

      wait_for(page).to have_content(organization1.name)
      wait_for(page).to have_content(organization2.name)
      wait_for(page).to have_content(organization1.description)
      wait_for(page).to have_content(organization2.description)

      select "RJ Hub", from: "organization_type_select"

      wait_for(page).to have_content(organization1.name)
      wait_for(page).to have_content(organization1.description)
      expect(page).not_to have_content(organization2.name)
      expect(page).not_to have_content(organization2.description)
    end

    scenario "visitor views organizations within neighborhood" do
      type = create(:type, name: "RJ Hub", category: "organization")
      hood = create(:neighborhood, name: "Hyde Park")
      organization = create(:organization, :with_locations, type: type, neighborhoods: [hood])
      visit root_path
      sleep(0.5)

      select hood.name, from: "neighborhood_select"
      sleep(0.5)

      select organization.type.name, from: "organization_type_select"

      wait_for(page).to have_content(organization.name)
      wait_for(page).to have_content(organization.description)
    end

    scenario "visitor views events" do
      type = create(:type, name: "Thing")
      @hood = create(:neighborhood, name: "Hyde Park")
      @events = create_list(:event, 2, status: "approved", type: type)
      visit root_path

      select @hood.name, from: "neighborhood_select"
      wait_for(page).to have_button "Events"
      sleep(0.5)

      click_button "Events"


      wait_for(page).to have_link(@events.first.title)
      wait_for(page).to have_link(@events.second.title)
    end

    scenario "visitor views artworks" do
      @hood = create(:neighborhood, name: "Hyde Park")
      @artworks = create_list(:artwork, 2, status: "approved")
      visit root_path

      select @hood.name, from: "neighborhood_select"
      wait_for(page).to have_button "Art"
      sleep(0.5)

      click_button "Art"

      wait_for(page).to have_link(@artworks.first.title)
      wait_for(page).to have_link(@artworks.second.title)
    end

    scenario "visitor views stories" do
      @hood = create(:neighborhood, name: "Hyde Park")
      @stories = create_list(:story, 2, status: "approved")
      visit root_path
      select @hood.name, from: "neighborhood_select"
      wait_for(page).to have_button "Stories"
      sleep(0.5)

      click_button "Stories"

      wait_for(page).to have_link(@stories.first.title)
      wait_for(page).to have_link(@stories.second.title)
    end
  end

  context "visitor views content details" do
    scenario "visitor views event details" do
      create(:type)
      @hood = create(:neighborhood, name: "Hyde Park")
      @events = create_list(:event, 2, status: "approved", type_id: 1)

      event = @events.first
      visit root_path
      select @hood.name, from: "neighborhood_select"
      wait_for(page).to have_button "Events"
      sleep(0.5)

      click_button "Events"
      wait_for(page).to have_content(event.title)
      click_on event.title

      wait_for(page).to have_content(event.title)
      wait_for(page).to have_content(event.organization.name)
      wait_for(page).to have_content(event.formatted_date_time)
      wait_for(page).to have_content("Contact for more information")
      wait_for(page).to have_content(event.description)
      wait_for(page).to have_content(event.type.name)
      wait_for(page).to have_content(event.address)
      wait_for(page).to have_link("View Event Page")
    end

    scenario "visitor views artwork details" do
      @hood = create(:neighborhood, name: "Hyde Park")
      @artworks = create_list(:artwork, 2, status: "approved")

      artwork = @artworks.first
      visit root_path
      select @hood.name, from: "neighborhood_select"
      wait_for(page).to have_button "Art"
      sleep(0.5)

      click_button "Art"
      wait_for(page).to have_content(artwork.title)
      click_on artwork.title

      wait_for(page).to have_content(artwork.title)
      wait_for(page).to have_content(artwork.artist)
      wait_for(page).to have_content(artwork.description)
      wait_for(page).to have_content(artwork.address)
    end

    scenario "visitor views story details" do
      @hood = create(:neighborhood, name: "Hyde Park")
      @stories = create_list(:story, 2, status: "approved")

      story = @stories.first
      visit root_path
      select @hood.name, from: "neighborhood_select"
      wait_for(page).to have_button "Stories"
      sleep(0.5)

      click_button "Stories"
      wait_for(page).to have_content(story.title)
      click_on story.title

      wait_for(page).to have_content(story.title)
      wait_for(page).to have_content(story.body)
      wait_for(page).to have_content(story.description)
      wait_for(page).to have_content(story.body)
    end
  end
end
