require 'rails_helper'

RSpec.feature "visitor can create account" do
  before :all do
    @neighborhood = create(:neighborhood)
    @organization = create(:organization)
  end

  context "valid logins" do
    scenario "visitor creates valid account manually" do
      # As a visitor
      # When I visit the home page
      visit root_path
      # I should be able to click the sign up link
      expect(page).to have_link("Create Account")
      click_link "Create Account"
      # and create an account with credentials
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

    xscenario "visitor creates valid account with google" do
      # or create an account with google or facebook
    end
  end

  context "sad paths" do
  end
  scenario "visitor does not enter first name" do
    visit root_path
    # I should be able to click the sign up link
    expect(page).to have_link("Create Account")
    click_link "Create Account"
    # and create an account with credentials
    fill_in "Email", with: "someguy@gmail.com"
    fill_in "First Name", with: ""
    fill_in "Last Name", with: "Smith"
    fill_in "Password", with: "opensesame"
    fill_in "Password Confirmation", with: "opensesame"
    select @neighborhood.name, from: "user_neighborhood"
    click_button "Create Account"

    expect(User.all.count).to eq(0)
    expect(page).to have_content("First name can't be blank")
  end

  scenario "visitor does not enter last name" do
    visit root_path
    # I should be able to click the sign up link
    expect(page).to have_link("Create Account")
    click_link "Create Account"
    # and create an account with credentials
    fill_in "Email", with: "someguy@gmail.com"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: ""
    fill_in "Password", with: "opensesame"
    fill_in "Password Confirmation", with: "opensesame"
    select @neighborhood.name, from: "user_neighborhood"
    click_button "Create Account"

    expect(User.all.count).to eq(0)
    expect(page).to have_content("Last name can't be blank")
  end

  scenario "visitor enters bad password confirmation" do
    visit root_path
    click_link "Create Account"

    fill_in "Email", with: "someguy@gmail.com"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Smith"
    fill_in "Password", with: "opensesame"
    fill_in "Password Confirmation", with: "closesesame"
    select @neighborhood.name, from: "user_neighborhood"
    click_button "Create Account"

    expect(User.all.count).to eq(0)
    expect(page).to have_content("Password confirmation doesn't match password")
  end

  scenario "visitor does not enter password" do
    visit root_path
    click_link "Create Account"

    save_and_open_page
    fill_in "Email", with: "someguy@gmail.com"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Smith"
    fill_in "Password", with: ""
    fill_in "Password Confirmation", with: "closesesame"
    select @neighborhood.name, from: "user_neighborhood"
    click_button "Create Account"

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

end
