require "rails_helper"

RSpec.describe Api::V1::NeighborhoodsController, type: :request do
  it '/api/v1/neighborhoods/:name returns a neighborhood in #show and has associations' do
    type1 = create(:type)
    type2 = create(:type, name: "RJ Hub")

    create(:neighborhood, name: "Rogers Park", bounds: [{lat:42.0230385, lng:-87.65455589999999}, {lat:41.9979594, lng:-87.684653}])
    create(:neighborhood, name: "Hyde Park")
    create(:organization, :with_locations, type: type2)
    event = create(:event, status: "approved", type: type1)
    story = create(:story, status: "approved")
    artwork = create(:artwork, address: "1543 W Morse Ave, Chicago, IL 60626", status: "approved")

    name = Neighborhood.second.name

    encoded_url = URI.encode("/api/v1/neighborhoods/#{name}")
    url = URI.parse(encoded_url)
    get url

    expect(response.status).to eq 200

    neighborhood = JSON.parse(response.body)

    expect(neighborhood["name"]).to eq(name)

    expect(neighborhood["events"].first["title"]).to eq(event.title)
    expect(neighborhood["stories"].first["title"]).to eq(story.title)
    expect(neighborhood["artworks"]).to be_empty

    expect(neighborhood["events"].first["type"]).to eq(type1.name)

    expect(neighborhood["locations"].first["address"]).to eq("1100 E 55th St, Chicago, IL 60615")
    expect(neighborhood["locations"].first["organization"]["name"]).to eq(Organization.first.name)
    expect(neighborhood["locations"].first["organization"]["description"]).to eq("A Description")
    expect(neighborhood["locations"].first["organization"]["type"]).to eq(type2.name)
  end

  it '/api/v1/neighborhoods/find-neighborhood/ returns a neighborhood in #find_neighborhood and has associations' do
    type1 = create(:type)
    type2 = create(:type, name: "RJ Hub")

    create(:neighborhood, name: "Rogers Park", bounds: [{lat:42.0230385, lng:-87.65455589999999}, {lat:41.9979594, lng:-87.684653}])
    create(:neighborhood, name: "Hyde Park")
    create(:organization, :with_locations, type: type2)
    event = create(:event, status: "approved", type: type1)
    story = create(:story, status: "approved")
    artwork = create(:artwork, address: "1543 W Morse Ave, Chicago, IL 60626", status: "approved")

    name = Neighborhood.first.name

    encoded_url = URI.encode("/api/v1/neighborhoods/find-neighborhood/")
    url = URI.parse(encoded_url)
    get url, {lat:42.0030385, lng:-87.66455589999999}

    expect(response.status).to eq 200

    neighborhood = JSON.parse(response.body)

    expect(neighborhood["name"]).to eq(name)

    expect(neighborhood["events"]).to be_empty
    expect(neighborhood["stories"]).to be_empty
    expect(neighborhood["artworks"].first["title"]).to eq(artwork.title)

    expect(neighborhood["locations"]).to be_empty
  end

  it "/api/v1/neighborhoods/find-neighborhood/ returns a bad request if no neighborhoodis found" do
    encoded_url = URI.encode("/api/v1/neighborhoods/find-neighborhood/")
    url = URI.parse(encoded_url)
    get url, {lat:42.0030385, lng:-87.66455589999999}

    expect(response.status).to eq 400
  end
end
