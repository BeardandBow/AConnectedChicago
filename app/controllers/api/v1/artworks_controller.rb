class Api::V1::ArtworksController < ApplicationController
  respond_to :json

  def destroy
    artwork = Artwork.find(params[:id])
    artwork.delete
    flash[:success] = "Artwork Deleted"
    respond_with status: :no_content
  end
end
