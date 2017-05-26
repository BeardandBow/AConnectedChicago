require 'rails_helper'

RSpec.feature "admin can manage organizations" do

  before :each do
    @admin = create(:user, :admin)
    create(:type, name: "RJ Hub", category: "organization")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit user_path(@admin)
  end

  context "admin successfully adds an organization" do
    scenario "admin sees the button to add an organization" do
      expect(page).to have_button("Manage Organizations")
    end

    scenario "admin successfully adds an organization" do
      expect(Organization.all.count).to eq(0)

      click_on "Manage Organizations"

      expect(current_path).to eq(admin_organizations_path)

      fill_in "Organization Name", with: "New Organization"
      fill_in "Organization Website", with: "http://www.test.com"
      fill_in "Organization Description", with: "New Description"
      select "RJ Hub", from: "organization_type"
      click_on "Add Organization"

      expect(Organization.all.count).to eq(1)
      expect(Organization.first.name).to eq("New Organization")
    end
  end

  context "admin cannot add an organization" do
    scenario "admin submits an empty organization" do
      click_on "Manage Organizations"
      click_on "Add Organization"

      expect(Organization.all.count).to eq(0)
      expect(page).to have_content("Cannot create duplicate or blank Organization")
    end
    scenario "admin submits a duplicate organization" do
      create(:type, name: "Snorkeling", category: "event")

      click_on "Manage Organizations"
      fill_in "Organization Name", with: "Snorkeling"
      click_on "Add Organization"

      expect(Organization.all.count).to eq(1)
      expect(page).to have_content("Cannot create duplicate or blank Organization")

    end
  end
end
