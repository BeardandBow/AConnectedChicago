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
      fill_in "Organization Location", with: "1918 W Farwell Ave, Chicago, IL 60626"
      select "RJ Hub", from: "organization_type_id"
      click_on "Add Organization"
      expect(Organization.all.count).to eq(1)
      expect(Location.all.count).to eq(1)
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
      create(:organization, name: "Snorkeling")

      click_on "Manage Organizations"
      fill_in "Organization Name", with: "Snorkeling"
      click_on "Add Organization"

      expect(Organization.all.count).to eq(1)
      expect(page).to have_content("Cannot create duplicate or blank Organization")
    end
  end

  context "admin can edit an organization" do
    before :each do
      @org = create(:organization, name: "Circles and Cyphers")

      click_on "Manage Organizations"
      within("#circles-and-cyphers") do
        click_on "Edit Info"
      end
    end

    scenario "admin edits an organization's info" do

      fill_in "Name", with: "Squares and Neos"
      fill_in "Website", with: "http://www.example.com"
      fill_in "Description", with: "what a description this is"
      select "RJ Hub", from: "organization_type_id"
      click_on "Update Organization"

      expect(page).to have_selector("input[value='Squares and Neos']")
      expect(page).to have_selector("input[value='http://www.example.com']")
      expect(page).to have_content("what a description this is")
      expect(page).to have_content("'Squares and Neos' has been updated")
    end

    scenario "admin adds a new location" do
      expect(current_path).to eq(edit_admin_organization_path(@org))

      fill_in "New Address", with: "1918 W Farwell Ave, Chicago, IL 60626"
      click_on "Add New Location"

      expect(page).to have_content("'Circles and Cyphers' has been updated")
      expect(Location.all.count).to eq(1)
      expect(Location.first.address).to eq("1918 W Farwell Ave, Chicago, IL 60626")
    end
  end

  scenario "admin deletes an Organization" do
    @org = create(:organization, name: "Circles and Cyphers")

    click_on "Manage Organizations"
    within("#circles-and-cyphers") do
      click_on "Delete"
    end

    expect(page).to have_content("'Circles and Cyphers' Organization deleted")
    expect(".center").not_to have_content("Circles and Cyphers")
  end

  context "sad paths" do
    before :each do
      @org = create(:organization, name: "Circles and Cyphers")

      click_on "Manage Organizations"
      within("#circles-and-cyphers") do
        click_on "Edit Info"
      end
    end

    scenario "admin tried to delete an organization's name" do
      fill_in "Name", with: ""
      click_on "Update Organization"

      expect(page).to have_selector("input[value='Circles and Cyphers']")
      expect(page).to have_content("Cannot update Organization - please check your entries")
    end
  end
end
