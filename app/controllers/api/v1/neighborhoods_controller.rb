class Api::V1::NeighborhoodsController < Api::V1::ApiBaseController

  def show
    neighborhood = Neighborhood.find_by(name: params[:name])
    respond_with  neighborhood, include: [:events, :stories, :artworks]
  end
end
