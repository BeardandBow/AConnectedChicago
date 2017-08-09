require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :request do
  it("#delete api/v1/events deletes event") do
    @user = create(:user, :registered_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    event = create(:event, user: @user)

    encoded_url = URI.encode("/api/v1/events/#{event.id}")
    url = URI.parse(encoded_url)
    delete url

    expect(response.status).to eq(204)

    expect(Event.all).to be_empty
  end
end
