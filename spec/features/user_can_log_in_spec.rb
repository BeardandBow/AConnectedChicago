 require 'rails_helper'

 RSpec.feature "user can log in" do
   scenario "user logs into their account" do
    #  As a user
    user = create(:user)
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

   end

   scenario "user enters wrong password" do
     
   end
 end
