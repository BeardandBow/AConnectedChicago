require 'rails_helper'

RSpec.feature "user sees homepage" do
  scenario "visitor sees links to view content, logout, and view dashboard" do
    user = create(:user, :registered_user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit root_path

    expect(page).to have_link("Events")
    expect(page).to have_link("Stories")
    expect(page).to have_link("Art")
    expect(page).to have_link("Logout")
    expect(page).to have_link("Dashboard")
  end
end
