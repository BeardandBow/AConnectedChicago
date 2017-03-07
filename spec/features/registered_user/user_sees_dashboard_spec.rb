require 'rails_helper'

RSpec.feature "user sees dashboard" do
  scenario "user sees links on dashboard" do
    # As a user
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    # When I visit my dashboard
    visit user_path(user)
    # I should see links for adding an event, a story, and an art piece
    expect(page).to have_link("Submit Event")
    expect(page).to have_link("Submit Story")
    expect(page).to have_link("Submit Art")
  end
end
