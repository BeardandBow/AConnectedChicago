class Api::V1::UsersController < ApplicationController
  respond_to :json

  def index
    if current_user
      @user = current_user
      @orgs = current_user.organizations
    end
  end
end
