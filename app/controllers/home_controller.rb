class HomeController < ApplicationController

  def index
    @neighborhoods = Neighborhood.order(:name).pluck(:name)
  end
end
