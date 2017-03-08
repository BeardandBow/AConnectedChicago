class EventsController < ApplicationController

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.create(event_params)
    current_user.neighborhood.events << @event
    if @event.save
      flash[:success] = "Your Event has been sent to a Community Leader for approval."
      redirect_to user_path(current_user)
    else
      flash[:error] = "Invalid info"
      render :new
    end
  end

  private

  def event_params
    params.require(:event).permit(:title,
                                  :host_contact,
                                  :description,
                                  :address,
                                  :date,
                                  :time)
  end
end
