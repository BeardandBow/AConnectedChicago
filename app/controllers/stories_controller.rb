class StoriesController < ApplicationController

  def index
    @stories = Story.where(status: "approved").reverse
  end

  def show
    @story = Story.find(params[:id])
  end

  def new
    @story = Story.new
  end

  def create
    @story = current_user.stories.create(story_params)
    if community_leader? || admin?
      @story.approve
    end
    if @story.save
      flash[:success] = "Your Story has been sent to a Community Leader for approval."
      redirect_to user_path(current_user)
    else
      flash[:error] = "There is a problem with your submission. Please correct and resubmit."
      render :new
    end
  end

  private

  def story_params
    params.require(:story).permit(:title,
                                  :author,
                                  :description,
                                  :address,
                                  :youtube_link,
                                  :body)
  end
end
