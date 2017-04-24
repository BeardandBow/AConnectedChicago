require 'rails_helper'

RSpec.feature "user can update their profile" do
  before :each do
    @user = create(:user, :registered_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  scenario "user updates their profile with good info" do

    visit user_path(@user)

    click_button "Update My Account"

    fill_in "First Name", with: "Dude"
    fill_in "Last Name", with: "McDuderson"
    fill_in "Gender", with: "Man"
    fill_in "Race/Ethnicity", with: "Hispanic/Latino"
    fill_in "What motivated you to join Connected Chicago?", with: "I dunno"
    select "Online", from: "user_how"
    fill_in "What part of Chicago would you like to connect with?", with: "hyde park"
    click_on "Update Account"

    expect(current_path).to eq(user_path(@user))
    expect(page).to have_content "Your profile has been updated!"
    expect(@user.first_name).to eq "Dude"
    expect(@user.last_name).to eq "McDuderson"
    expect(@user.gender).to eq "Man"
    expect(@user.race).to eq "Hispanic/Latino"
    expect(@user.why).to eq "I dunno"
    expect(@user.how).to eq "Online"
    expect(@user.where).to eq "hyde park"
  end

  scenario "user can update some attributes without adding all of them" do

    visit user_path(@user)

    click_button "Update My Account"

    fill_in "First Name", with: "Mann"
    fill_in "Last Name", with: "McMannerson"
    select "Online", from: "user_how"
    click_on "Update Account"

    expect(@user.first_name).to eq "Mann"
    expect(@user.last_name).to eq "McMannerson"
    expect(@user.gender).to eq nil
    expect(@user.race).to eq nil
    expect(@user.why).to eq nil
    expect(@user.how).to eq "Online"
    expect(@user.where).to eq nil
  end

  scenario "user joins an organization" do
    organization = create(:organization)
    visit user_path(@user)

    click_button "Update My Account"
    select organization.name, from: "user_organizations"
    click_button "Update Account"

    expect(@user.organizations.count).to eq(1)
    expect(current_path).to eq(user_path(@user))
    expect(page).to have_content("Your profile has been updated!")
    expect(page).to have_content(organization.name)
  end
end
