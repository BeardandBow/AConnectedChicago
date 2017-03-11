class ArtworksController < ApplicationController

  def index
    @artworks = Artwork.all
  end

  def show
    @artwork = Artwork.find(params[:id])
  end

  def new
    @artwork = Artwork.new
  end

  def create
    @artwork = current_user.artworks.create(artwork_params)
    current_user.neighborhood.artworks << @artwork
    if @artwork.save
      flash[:success] = "Your Artwork has been sent to a Community Leader for approval."
      redirect_to user_path(current_user)
    else
      flash[:error] = "There is a problem with your submission. Please correct and resubmit."
      render :new
    end
  end

  private

  def artwork_params
    params.require(:artwork).permit(:title,
                                    :artist,
                                    :description,
                                    :address)
  end
end
