require 'rails_helper'

RSpec.feature "user can log in and log out" do
  context "user logs in" do
    scenario "user logs into their account" do
      #  As a user
      user = create(:user, :registered_user)
      #  When I visit the home page
      visit root_path
      #  and click the login link
      click_link "Login"
      #  I should be able to enter my credentials and login
      fill_in "Email", with: user.email
      fill_in "Password", with: "opensesame"
      click_button "Login"

      expect(current_path).to eq(user_path(user))
      expect(page).to have_link("Logout")
    end

    scenario "user enters non-existent email" do
      visit root_path
      click_link "Login"

      fill_in "Email", with: "anotherguy@gmail.com"
      fill_in "Password", with: "opensesame"
      click_button "Login"

      expect(current_path).to eq(login_path)
      expect(page).to have_content("There is no user with that email")
    end

    scenario "user enters wrong password" do
      user = create(:user, :registered_user)
      visit root_path
      click_link "Login"

      fill_in "Email", with: user.email
      fill_in "Password", with: "closesesame"
      click_button "Login"

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Password is incorrect")
    end
  end

  scenario "user logs out" do
    user = create(:user, :registered_user)
    visit root_path
    click_link "Login"

    fill_in "Email", with: user.email
    fill_in "Password", with: "opensesame"

    click_button "Login"
    click_on "Logout"

    expect(current_path).to eq(root_path)
    expect(page).to have_link("Login")
    expect(page).not_to have_link("Logout")
  end
end
