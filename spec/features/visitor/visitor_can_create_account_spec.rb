require 'rails_helper'

RSpec.feature "visitor can create account" do
  before :each do
    create(:neighborhood)
  end
  scenario "visitor creates valid account manually" do
    # As a visitor
    # When I visit the home page
    visit root_path
    # I should be able to click the sign up link
    expect(page).to have_link("Create Account")
    click_on "Create Account"
    # and create an account with credentials
    fill_in "Email", with: "someguy@gmail.com"
    fill_in "Password", with: "opensesame"
    fill_in "Password Confirmation", with: "opensesame"
    fill_in "Your Neighborhood", with: "Hyde Park"
    click_on "Create Account"

    user = User.first

    expect(User.all.count).to eq(1)
    expect(user.email).to eq("someguy@gmail.com")
    expect(page).to have_content("Account created!")
    expect(current_path).to eq(user_path(user))
  end

  scenario "visitor enters bad password confirmation" do
    visit root_path
    click_on "Create Account"

    fill_in "Email", with: "someguy@gmail.com"
    fill_in "Password", with: "opensesame"
    fill_in "Password Confirmation", with: "closesesame"
    fill_in "Your Neighborhood", with: "Hyde Park"
    click_on "Create Account"

    expect(User.all.count).to eq(0)
    expect(page).to have_content("Password confirmation doesn't match password")
  end

  scenario "visitor does not enter password" do
    visit root_path
    click_on "Create Account"

    fill_in "Email", with: "someguy@gmail.com"
    fill_in "Password", with: ""
    fill_in "Password Confirmation", with: "closesesame"
    fill_in "Your Neighborhood", with: "Hyde Park"
    click_on "Create Account"

    expect(User.all.count).to eq(0)
    expect(page).to have_content("Password can't be blank")
  end

  scenario "visitor tries to visit a users dashboard" do
    visit '/users/123'

    expect(page).to have_http_status(:forbidden)
  end
  xscenario "visitor creates valid account with google" do
    # or create an account with google or facebook
  end
end
