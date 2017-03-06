class SessionsController < ApplicationController

  def new

  end

  def create
    @user = User.find_by(email: params[:session][:email]) || nil
    redirect_to user_path(@user)
  end
end
