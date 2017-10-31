class EventsController < ApplicationController

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
    @organizations = Organization.all
    @types = Type.where(category: "event").order(:name)
  end

  def create
    @event = current_user.events.create(event_params)
    @event.image = params[:image]
    
    if @event.save
      if community_leader? || admin?
        @event.approve
        flash[:success] = "Your Event has been created."
      else
        flash[:success] = "Your Event has been sent to a Community Leader for approval."
      end
      redirect_to user_path(current_user)
    else
      @organizations = Organization.all
      @types = Type.where(category: "event").order(:name)
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
                                  :organization_id,
                                  :type_id,
                                  :link,
                                  :time)
  end
end
