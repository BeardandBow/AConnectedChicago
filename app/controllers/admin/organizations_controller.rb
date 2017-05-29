class Admin::OrganizationsController < ApplicationController

  def index
    @organization = Organization.new
    @organization.locations.build
    @types = Type.where(category: "organization")
    @organizations = Organization.all.order(:name)

  end

  def create
    @organization = Organization.create(organization_params)
    if @organization.save
      flash[:success] = "'#{@organization.name}' has been created"
    else
      flash[:error] = "Cannot create duplicate or blank Organization"
    end
    redirect_to admin_organizations_path
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def update
    @organization = Organization.find(params[:id])
    if @organization.update_attributes(organization_params)
      flash[:success] = "'#{@organization.name}' has been updated"
    else
      flash[:error] = "Cannot update Organization - please check your entries"
    end
    redirect_to edit_admin_organization_path
  end
  end

  def destroy
    organization = Organization.find(params[:id])
    organization.delete
    flash[:success] = "'#{organization.name}' Organization deleted"
    redirect_to admin_organizations_path
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :website, :description, :type, locations_attributes: [ :address ])
  end
end
