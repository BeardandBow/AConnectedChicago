class Api::V1::ArtworksController < ApplicationController
  respond_to :json

  def destroy
    @artwork = Artwork.find(params[:id])
    @artwork.delete
    flash[:success] = "Artwork Deleted"
  end
end
