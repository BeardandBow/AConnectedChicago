class HomeController < ApplicationController

  def index
    @neighborhoods = Neighborhood.order(:name).pluck(:name)
    @role = User.roles[current_user.role] if current_user
  end
end
