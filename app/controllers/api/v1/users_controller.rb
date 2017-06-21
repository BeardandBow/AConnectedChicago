class Api::V1::UsersController < ApplicationController
  respond_to :json

  def index
    @user = current_user
    @orgs = current_user.organizations
  end
end
