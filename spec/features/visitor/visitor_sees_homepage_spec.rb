require 'rails_helper'

RSpec.feature "visitor sees homepage", js: true do
  scenario "visitor sees links to view content" do
    visit root_path

    expect(page).to have_button("All")
    expect(page).to have_button("Peace Circles")
    expect(page).to have_button("Events")
    expect(page).to have_button("Stories")
    expect(page).to have_button("Art")
  end

  context "visitor views content" do
    scenario "visitor views events" do
      @hood = create(:neighborhood, name: "Hyde Park")
      @events = create_list(:event, 2, status: "approved")
      visit root_path

      select @hood.name, from: "neighborhood_select"
      sleep(1)

      click_button "Events"

      expect(page).to have_link(@events.first.title)
      expect(page).to have_link(@events.second.title)
    end

    scenario "visitor views artworks" do
      @hood = create(:neighborhood, name: "Hyde Park")
      @artworks = create_list(:artwork, 2, status: "approved")
      visit root_path

      select @hood.name, from: "neighborhood_select"
      sleep(1)

      click_button "Art"

      expect(page).to have_link(@artworks.first.title)
      expect(page).to have_link(@artworks.second.title)
    end

    scenario "visitor views stories" do
      @hood = create(:neighborhood, name: "Hyde Park")
      @stories = create_list(:story, 2, status: "approved")
      visit root_path
      select @hood.name, from: "neighborhood_select"
      sleep(1)

      click_button "Stories"

      expect(page).to have_link(@stories.first.title)
      expect(page).to have_link(@stories.second.title)
    end
  end

  context "visitor views content details" do
    scenario "visitor views event details" do
      @hood = create(:neighborhood, name: "Hyde Park")
      @events = create_list(:event, 2, status: "approved")

      event = @events.first
      visit root_path
      select @hood.name, from: "neighborhood_select"
      sleep(1)

      click_button "Events"
      click_on event.title

      expect(page).to have_content(event.title)
      expect(page).to have_content(event.organization.name)
      expect(page).to have_content(event.formatted_date_time)
      expect(page).to have_content("Contact for more information")
      expect(page).to have_content(event.description)
      expect(page).to have_content(event.event_type)
      expect(page).to have_content(event.address)
      expect(page).to have_link("View Event Page")
    end

    scenario "visitor views artwork details" do
      @hood = create(:neighborhood, name: "Hyde Park")
      @artworks = create_list(:artwork, 2, status: "approved")

      artwork = @artworks.first
      visit root_path
      select @hood.name, from: "neighborhood_select"
      sleep(1)

      click_button "Art"
      click_on artwork.title

      expect(page).to have_content(artwork.title)
      expect(page).to have_content(artwork.artist)
      expect(page).to have_content(artwork.description)
      expect(page).to have_content(artwork.address)
    end

    scenario "visitor views story details" do
      @hood = create(:neighborhood, name: "Hyde Park")
      @stories = create_list(:story, 2, status: "approved")

      story = @stories.first
      visit root_path
      select @hood.name, from: "neighborhood_select"
      sleep(1)

      click_button "Stories"
      click_on story.title

      expect(page).to have_content(story.title)
      expect(page).to have_content(story.body)
      expect(page).to have_content(story.description)
      expect(page).to have_content(story.body)
    end
  end
end
