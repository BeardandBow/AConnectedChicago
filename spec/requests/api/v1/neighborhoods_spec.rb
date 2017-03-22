require "rails_helper"

RSpec.describe Api::V1::NeighborhoodsController, type: :request do
  it '/api/v1/neighborhoods/:name returns a neighborhood in #show and has associations' do
    neighborhoods = create_list(:neighborhood, 2)
    event = create(:event, neighborhood_id: neighborhoods.last.id)
    story = create(:story, neighborhood_id: neighborhoods.last.id)
    artwork = create(:artwork, neighborhood_id: neighborhoods.last.id)
    name = neighborhoods.last.name
    encoded_url = URI.encode("/api/v1/neighborhoods/#{name}")
    url = URI.parse(encoded_url)
    get url

    expect(response.status).to eq 200

    neighborhood = JSON.parse(response.body)

    expect(neighborhood["name"]).to eq(name)
    expect(neighborhood["events"].first["title"]).to eq(event.title)
    expect(neighborhood["stories"].first["title"]).to eq(story.title)
    expect(neighborhood["artworks"].first["title"]).to eq(artwork.title)
  end
end
