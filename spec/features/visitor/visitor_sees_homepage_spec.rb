require 'rails_helper'

RSpec.feature "visitor sees homepage" do
  before :each do
    @events = create_list(:event, 2)
    @stories = create_list(:story, 2)
    @artworks = create_list(:artwork, 2)
  end
  scenario "visitor sees links to view content" do
    visit root_path

    expect(page).to have_link("Events")
    expect(page).to have_link("Stories")
    expect(page).to have_link("Art")
  end

  context "visitor views content" do
    scenario "visitor views events" do
      visit root_path

      click_on "Events"

      expect(page).to have_link(@events.first.title)
      expect(page).to have_link(@events.second.title)
    end

    scenario "visitor views artworks" do
      visit root_path

      click_on "Art"

      expect(page).to have_link(@artworks.first.title)
      expect(page).to have_link(@artworks.second.title)
    end

    scenario "visitor views stories" do
      visit root_path

      click_on "Stories"

      expect(page).to have_link(@stories.first.title)
      expect(page).to have_link(@stories.second.title)
    end
  end

  context "visitor views content details" do
    scenario "visitor views event details" do
      event = @events.first
      visit events_path

      click_on event.title

      expect(page).to have_content(event.title)
      expect(page).to have_content(event.host_contact)
      expect(page).to have_content(event.description)
      expect(page).to have_content(event.address)
      expect(page).to have_content(event.date)
      expect(page).to have_content(event.time.strftime("%I:%M %p"))
    end

    scenario "visitor views artwork details" do
      artwork = @artworks.first
      visit artworks_path

      click_on artwork.title

      expect(page).to have_content(artwork.title)
      expect(page).to have_content(artwork.artist)
      expect(page).to have_content(artwork.description)
      expect(page).to have_content(artwork.address)
    end

    scenario "visitor views story details" do
      story = @stories.first
      visit stories_path

      click_on story.title

      expect(page).to have_content(story.title)
      expect(page).to have_content(story.body)
      expect(page).to have_content(story.description)
      expect(page).to have_content(story.address)
      expect(page).to have_content(story.body)
    end
  end
end
