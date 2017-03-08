class ArtworksController < ApplicationController

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
      flash[:error] = "Invalid info"
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
