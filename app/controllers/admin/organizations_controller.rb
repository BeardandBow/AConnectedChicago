class Admin::OrganizationsController < ApplicationController

  def index
    @organization = Organization.new
    @organization.locations.build
    @types = Type.where(category: "organization")
    @organizations = Organization.all.order("LOWER(name)")

  end

  def create
    if params[:organization][:type_id].empty?
      flash[:error] = "Cannot create Organization without a type"
    else
      @organization = Organization.new(organization_params)
      if @organization.save
        unless params[:organization][:locations_attributes]['0'][:address].blank?
          @organization.locations.create(address: params[:organization][:locations_attributes]['0'][:address])
        end
        flash[:success] = "'#{@organization.name}' has been created"
      else
        flash[:error] = "Cannot create duplicate or blank Organization"
      end
    end
    redirect_to admin_organizations_path
  end

  def edit
    @organization = Organization.find(params[:id])
    @location = @organization.locations.build
    @types = Type.where(category: "organization")
  end

  def update
    @organization = Organization.find(params[:id])
    unless params[:organization][:locations_attributes]['0'][:address].blank?
      @organization.locations.create(address: params[:organization][:locations_attributes]['0'][:address])
    end
    if @organization.update_attributes(organization_params)
      flash[:success] = "'#{@organization.name}' has been updated"
    else
      flash[:error] = "Cannot update Organization - please check your entries"
    end
    redirect_to edit_admin_organization_path
  end

  def destroy
    organization = Organization.find(params[:id])
    organization.destroy
    flash[:success] = "'#{organization.name}' Organization deleted"
    redirect_to admin_organizations_path
  end

  private

  def organization_params
    params.require(:organization).permit(:id, :name, :website, :description, :type_id, locations_attributes: [ :id, :organization_id, :address, :_destroy ])
  end
end
