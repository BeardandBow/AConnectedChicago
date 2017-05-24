class HomeController < ApplicationController

  def index
    @neighborhoods = Neighborhood.order(:name).pluck(:name)
    @organization_types = Type.where(category: "organization").pluck(:name)
    @role = User.roles[current_user.role] if current_user
  end

  def resources
  end

  def about
  end
end
