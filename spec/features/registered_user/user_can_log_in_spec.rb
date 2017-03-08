require 'rails_helper'

RSpec.feature "user can log in" do
  scenario "user logs into their account" do
    #  As a user
    neighborhood = create(:neighborhood, :with_user)
    user = neighborhood.users.first
    #  When I visit the home page
    visit root_path
    #  and click the login link
    click_on "Login"
    #  I should be able to enter my credentials and login
    fill_in "Email", with: "someguy@gmail.com"
    fill_in "Password", with: "opensesame"
    click_on "Login"

    expect(current_path).to eq(user_path(user))
    expect(page).to have_link("Logout")
  end

  scenario "user enters non-existent email" do
    visit root_path
    click_on "Login"

    fill_in "Email", with: "anotherguy@gmail.com"
    fill_in "Password", with: "opensesame"
    click_on "Login"

    expect(current_path).to eq(login_path)
    expect(page).to have_content("There is no user with that email")
  end

  scenario "user enters wrong password" do
    neighborhood = create(:neighborhood, :with_user)
    visit root_path
    click_on "Login"

    fill_in "Email", with: "someguy@gmail.com"
    fill_in "Password", with: "closesesame"
    click_on "Login"

    expect(current_path).to eq(login_path)
    expect(page).to have_content("Password is incorrect")
  end
end
