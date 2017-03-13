require "rails_helper"

RSpec.feature "pending user tries to log in" do
  scenario "unconfirmed user enters log in details" do
    user = create(:user)

    visit login_path

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login"

    expect(page).to have_content("Please activate your account by following the
        instructions in the account confirmation email you received to proceed")
    expect(current_path).to eq(login_path)
  end
end
