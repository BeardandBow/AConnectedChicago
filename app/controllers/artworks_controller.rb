class ArtworksController < ApplicationController

  def index
    @artworks = Artwork.where(status: "approved").reverse
  end

  def show
    @artwork = Artwork.find(params[:id])
  end

  def new
    @artwork = Artwork.new
  end

  def create
    @artwork = current_user.artworks.create(artwork_params)
    if @artwork.save
      if community_leader? || admin?
        @artwork.approve
        flash[:success] = "Your Artwork has been created."
      else
        flash[:success] = "Your Artwork has been sent to a Community Leader for approval."
      end
      redirect_to user_path(current_user)
    else
      flash[:error] = "There is a problem with your submission. Please correct and resubmit."
      render :new
    end
  end

  def destroy
    @artwork = Artwork.find(params[:id])
    @artwork.delete
    flash[:success] = "Artwork Deleted"
    redirect_to user_path(current_user)
  end

  private

  def artwork_params
    params.require(:artwork).permit(:title,
                                    :artist,
                                    :image,
                                    :description,
                                    :address)
  end
end
