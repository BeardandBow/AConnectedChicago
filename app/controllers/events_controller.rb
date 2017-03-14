class EventsController < ApplicationController

  def index
    @events = Event.where(status: "approved").where("date >= ?", Date.today).order(:date, :time)
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    organization = Organization.find_by(name: params[:event][:organization])
    @event = current_user.events.create(event_params)
    if organization
      current_user.neighborhood.events << @event
      organization.events << @event
    end

    if @event.save
      flash[:success] = "Your Event has been sent to a Community Leader for approval."
      redirect_to user_path(current_user)
    else
      flash[:error] = "There is a problem with your submission. Please correct and resubmit."
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
