require 'rails_helper'

RSpec.feature "visitor can create account" do
  scenario "visitor creates valid account manually" do
    # As a visitor
    # When I visit the home page
    visit root_path
    # I should be able to click the sign up link
    expect(page).to have_link("Create Account")
    click_on "Create Account"
    # and I should see the new account form
    find_field "Email"
    find_field "Password"
    find_field "Password Confirmation"
    find_button "Create Account"
    # and create an account with credentials
    fill_in "Email", with: "someguy@gmail.com"
    fill_in "Password", with: "opensesame"
    fill_in "Password Confirmation", with: "opensesame"
    click_on "Create Account"
    expect(User.all.count).to eq(1)
    expect(User.first.email).to eq("someguy@gmail.com")
  end
  scenario "visitor creates valid account with google" do
    # or create an account with google or facebook
  end
end
