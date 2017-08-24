require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  it("#delete api/v1/stories deletes story") do
    @user = create(:user, :registered_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    encoded_url = URI.encode("/api/v1/users/")
    url = URI.parse(encoded_url)
    get url

    expect(response.status).to eq(200)
    user = JSON.parse(response.body)

    expect(user["id"]).to eq(@user.id) 
  end
end

