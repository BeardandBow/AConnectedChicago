class Admin::TypesController < ApplicationController

  def index
    @type = Type.new
    @types = Type.where(category: "event")

  end

  def create
    @type = Type.create(type_params)
    if @type.save
      flash[:success] = "'#{@type.name}' has been created"
    else
      flash[:error] = "Cannot create duplicate or blank Event Type"
    end
    redirect_to admin_types_path
  end

  def destroy
    type = Type.find(params[:id])
    type.delete
    flash[:success] = "'#{type.name}' Event Type Deleted"
    redirect_to admin_types_path
  end

  private

  def type_params
    params.require(:type).permit(:name, :category)
  end
end
