require 'rails_helper'

RSpec.feature "visitor can create account" do
  before :all do
    @neighborhood = create(:neighborhood, name: "Hyde Park")
    @organization = create(:organization)
  end

  before :each do
    visit root_path

    click_link "Create Account"
  end

  context "valid logins" do
    scenario "visitor creates valid account manually" do
      expect(page).to have_select("user_organizations")
      fill_in "Email", with: "someguy@gmail.com"
      fill_in "First Name", with: "John"
      fill_in "Last Name", with: "Smith"
      fill_in "Password", with: "opensesame"
      fill_in "Password Confirmation", with: "opensesame"
      select @neighborhood.name, from: "user_neighborhood"
      click_button "Create Account"

      user = User.first

      expect(User.all.count).to eq(1)
      expect(user.email).to eq("someguy@gmail.com")
      expect(current_path).to eq(root_path)
      expect(page).to have_content("Account created! Email confirmation sent to #{user.email}")
      expect(ActionMailer::Base.deliveries.count).to eq(1)

      visit confirm_user_email_url(user.email_token)

      expect(page).to have_content("Welcome to A Connected Chicago! Your email has been confirmed.
      Please sign in to continue.")
      expect(user.reload.role).to eq("registered_user")
    end
  end

  context "sad paths" do
    scenario "visitor does not enter first name" do
      fill_in "Email", with: "someguy@gmail.com"
      fill_in "First Name", with: ""
      fill_in "Last Name", with: "Smith"
      fill_in "Password", with: "opensesame"
      fill_in "Password Confirmation", with: "opensesame"
      select @neighborhood.name, from: "user_neighborhood"
      click_button "Create Account and start Connecting!"

      expect(User.all.count).to eq(0)
      expect(page).to have_content("First name can't be blank")
    end

    scenario "visitor does not enter last name" do
      fill_in "Email", with: "someguy@gmail.com"
      fill_in "First Name", with: "John"
      fill_in "Last Name", with: ""
      fill_in "Password", with: "opensesame"
      fill_in "Password Confirmation", with: "opensesame"
      select @neighborhood.name, from: "user_neighborhood"
      click_button "Create Account and start Connecting!"

      expect(User.all.count).to eq(0)
      expect(page).to have_content("Last name can't be blank")
    end

    scenario "visitor enters bad password confirmation" do
      fill_in "Email", with: "someguy@gmail.com"
      fill_in "First Name", with: "John"
      fill_in "Last Name", with: "Smith"
      fill_in "Password", with: "opensesame"
      fill_in "Password Confirmation", with: "closesesame"
      select @neighborhood.name, from: "user_neighborhood"
      click_button "Create Account and start Connecting!"

      expect(User.all.count).to eq(0)
      expect(page).to have_content("Password confirmation doesn't match password")
    end

    scenario "visitor does not enter password" do
      fill_in "Email", with: "someguy@gmail.com"
      fill_in "First Name", with: "John"
      fill_in "Last Name", with: "Smith"
      fill_in "Password", with: ""
      fill_in "Password Confirmation", with: "closesesame"
      select @neighborhood.name, from: "user_neighborhood"
      click_button "Create Account and start Connecting!"

      expect(User.all.count).to eq(0)
      expect(page).to have_content("Password can't be blank")
    end

    scenario "visitor tries to confirm email with fake token" do
      fake_token = "120498230948719"

      visit confirm_user_email_url(fake_token)
      expect(current_path).to eq(root_path)
      expect(page).to have_content("Invalid token. The user with that token has already been confirmed, or a user with that token does not exist.")
    end

    scenario "visitor tries to visit a users dashboard" do
      visit '/users/123'

      expect(page).to have_http_status(:forbidden)
    end

    scenario "visitor does not select a neighborhood" do
      fill_in "Email", with: "someguy@gmail.com"
      fill_in "First Name", with: "John"
      fill_in "Last Name", with: "Smith"
      fill_in "Password", with: ""
      fill_in "Password Confirmation", with: "closesesame"
      click_button "Create Account and start Connecting!"

      expect(User.all.count).to eq(0)
      expect(page).to have_content("Please select your home neighborhood.")
    end
  end
end
