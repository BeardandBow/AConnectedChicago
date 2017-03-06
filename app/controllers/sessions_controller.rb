class SessionsController < ApplicationController

  def new

  end

  def create
    @user = User.find_by(email: params[:session][:email]) || nil
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    elsif @user
      flash.now[:error] = "Password is incorrect"
      render :new
    else
      flash.now[:error] = "There is no user with that email"
      render :new
    end
  end
end
