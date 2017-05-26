class Admin::OrganizationsController < ApplicationController

  def index
    @organization = Organization.new
    @types = Type.where(category: "organization")
    @organizations = Organization.all

  end

  def create
    @organization = Organization.create(organization_params)
    if @organization.save
      flash[:success] = "'#{@organization.name}' has been created"
    else
      flash[:error] = "Cannot create duplicate or blank Organization"
    end
    redirect_to admin_organizations_path



    # organization = Organization.find_by(name: params[:event][:organization])
    # type = Type.find_by(name: params[:event][:type])
    # @event = current_user.events.create(event_params)
    #
    # if organization
    #   organization.events << @event
    # end
    #
    # if type
    #   type.events << @event
    # end
    #
    # if @event.save
    #   if community_leader? || admin?
    #     @event.approve
    #     flash[:success] = "Your Event has been created."
    #   else
    #     flash[:success] = "Your Event has been sent to a Community Leader for approval."
    #   end
    #   redirect_to user_path(current_user)
    # else
    #   @organizations = Organization.pluck(:name)
    #   @types = Type.where(category: "event").pluck(:name)
    #   flash[:error] = "There is a problem with your submission. Please correct and resubmit."
    #   render :new
    # end
  end

  def destroy
    organization = Organization.find(params[:id])
    organization.delete
    flash[:success] = "'#{organization.name}' Organization deleted"
    redirect_to admin_organizations_path
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :website, :description, :type)
  end
end
