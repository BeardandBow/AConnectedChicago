class Api::V1::OrganizationsController < Api::V1::ApiBaseController
  respond_to :json

  def index
    @orgs = Organization.all
  end
end
