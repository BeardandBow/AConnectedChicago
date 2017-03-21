require 'rails_helper'

RSpec.feature "user can update their profile" do
  before :all do
    @user = create(:user, :registered_user)
  end

  scenario "user updates their profile with good info" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit user_path(@user)

    click_link "Update My Account"

    fill_in "First Name", with: "Dude"
    fill_in "Last Name", with: "McDuderson"
    select "Man", from: "user_gender"
    select "Hispanic/Latino", from: "user_race"
    fill_in "What motivated you to join Connected Chicago?", with: "I dunno"
    fill_in "How did you hear about Connected Chicago?", with: "a friend"
    fill_in "What part of Chicago would you like to connect with?", with: "hyde park"
    click_on "Update Account"

    expect(current_path).to eq(user_path(@user))
    expect(page).to have_content "Your profile has been updated!"
    expect(@user.first_name).to eq "Dude"
    expect(@user.last_name).to eq "McDuderson"
    expect(@user.gender).to eq "Man"
    expect(@user.race).to eq "Hispanic/Latino"
    expect(@user.why).to eq "I dunno"
    expect(@user.how).to eq "a friend"
    expect(@user.where).to eq "hyde park"
  end

  scenario "user with updated attributes can update some attributes without replacing all of them" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    
    visit user_path(@user)

    click_link "Update My Account"

    fill_in "First Name", with: "Mann"
    fill_in "Last Name", with: "McMannerson"
    fill_in "How did you hear about Connected Chicago?", with: "my mom"
    click_on "Update Account"

    expect(@user.first_name).to eq "Mann"
    expect(@user.last_name).to eq "McMannerson"
    expect(@user.gender).to eq "Man"
    expect(@user.race).to eq "Hispanic/Latino"
    expect(@user.why).to eq "I dunno"
    expect(@user.how).to eq "my mom"
    expect(@user.where).to eq "hyde park"
  end
end
