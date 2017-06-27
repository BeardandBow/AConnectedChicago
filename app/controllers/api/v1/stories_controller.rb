class Api::V1::StoriesController < ApplicationController
  respond_to :json

  def destroy
    story = Story.find(params[:id])
    story.delete
    flash[:success] = "Story Deleted"
  end
end
