require "rails_helper"

RSpec.feature "visitor views resources" do
  scenario "visitor visits resources page from homepage" do
    visit root_path

    click_link "Resources"

    expect(current_path).to eq(resources_path)
    expect(page).to have_content("Resources")
  end
end
