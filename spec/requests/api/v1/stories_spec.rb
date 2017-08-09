require 'rails_helper'

RSpec.describe Api::V1::StoriesController, type: :request do
  it("#delete api/v1/stories deletes story") do
    @user = create(:user, :registered_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    story = create(:story, user: @user)

    encoded_url = URI.encode("/api/v1/stories/#{story.id}")
    url = URI.parse(encoded_url)
    delete url

    expect(response.status).to eq(204)

    expect(Story.all).to be_empty
  end
end
