require 'rails_helper'

RSpec.feature "visitor sees homepage" do
  scenario "visitor sees links to view content" do
    visit root_path

    expect(page).to have_link("Events")
    expect(page).to have_link("Stories")
    expect(page).to have_link("Art")
  end
end
