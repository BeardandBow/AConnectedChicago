class Api::V1::EventsController < ApplicationController
  respond_to :json

  def destroy
    event = Event.find(params[:id])
    event.delete
    flash[:success] = "Event Deleted"
  end
end
