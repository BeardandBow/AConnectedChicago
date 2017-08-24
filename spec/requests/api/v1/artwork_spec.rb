require 'rails_helper'

RSpec.describe Api::V1::ArtworksController, type: :request do
  it("#delete api/v1/artworks deletes artwork") do
    @user = create(:user, :registered_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    artwork = create(:artwork, user: @user)

    encoded_url = URI.encode("/api/v1/artworks/#{artwork.id}")
    url = URI.parse(encoded_url)
    delete url

    expect(response.status).to eq(204)

    expect(Artwork.all).to be_empty
  end
end
