class EventsController < ApplicationController

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
    @organizations = Organization.pluck(:name)
    @types = Type.where(category: "event").pluck(:name)
  end

  def create
    organization = Organization.find_by(name: params[:event][:organization])
    type = Type.find_by(name: params[:event][:type])
    @event = current_user.events.create(event_params)

    if organization
      organization.events << @event
    end

    if type
      type.events << @event
    end

    if @event.save
      if community_leader? || admin?
        @event.approve
        flash[:success] = "Your Event has been created."
      else
        flash[:success] = "Your Event has been sent to a Community Leader for approval."
      end
      redirect_to user_path(current_user)
    else
      @organizations = Organization.pluck(:name)
      @types = Type.where(category: "event").pluck(:name)
      flash[:error] = "There is a problem with your submission. Please correct and resubmit."
      render :new
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.delete
    flash[:success] = "Event Deleted"
    redirect_to user_path(current_user)
  end

  private

  def event_params
    params.require(:event).permit(:title,
                                  :host_contact,
                                  :image,
                                  :description,
                                  :address,
                                  :date,
                                  :time)
  end
end
