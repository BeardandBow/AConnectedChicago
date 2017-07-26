require "rails_helper"

RSpec.describe Api::V1::OrganizationsController, type: :request do
  it '/api/v1/organizations returns all organizations' do
    org1 = create(:organization, :with_locations, name: "Org 1")
    org2 = create(:organization, :with_locations, name: "Org 2")

    encoded_url = URI.encode("/api/v1/organizations/")
    url = URI.parse(encoded_url)
    get url

    expect(response.status).to eq 200

    organizations = JSON.parse(response.body)

    expect(organizations.first["name"]).to eq(org1.name)
    expect(organizations.second["name"]).to eq(org2.name)
    expect(organizations.first["description"]).to eq(org1.description)
    expect(organizations.second["description"]).to eq(org2.description)
    expect(organizations.first["locations"].first["address"]).to eq("1100 E 55th St, Chicago, IL 60615")
  end
end
