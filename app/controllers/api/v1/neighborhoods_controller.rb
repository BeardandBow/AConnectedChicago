class Api::V1::NeighborhoodsController < Api::V1::ApiBaseController

  def show
    hood = Neighborhood.find_by(name: params[:name])
    events = Event.where(status: "approved").where("date >= ?", Date.today).order(:date, :time).where(neighborhood: hood)
    stories = Story.where(status: "approved").where(neighborhood: hood)
    artworks = Artwork.where(status: "approved").where(neighborhood: hood)
    response = {name: hood.name, bounds: hood.bounds, events: events, stories: stories, artworks: artworks}
    respond_with response
  end
end
