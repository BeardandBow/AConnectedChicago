require "rails_helper"

RSpec.describe Api::V1::NeighborhoodsController, type: :request do
  it '/api/v1/neighborhoods/:name returns a neighborhood in #show and has associations' do
    create(:neighborhood, name: "Rogers Park")
    create(:neighborhood, name: "Hyde Park")
    event = create(:event)
    story = create(:story)
    artwork = create(:artwork, address: "1543 W Morse Ave, Chicago, IL 60626")
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
  end
end
