class SessionsController < ApplicationController

  def new

  end

  def create
    @user = User.find_by(email: params[:session][:email]) || nil
    if @user && @user.authenticate(params[:session][:password])
      if @user.role == "pending_user"
        flash.now[:error] = "Please activate your account by following the
        instructions in the account confirmation email you received to proceed"
        render :new
      else
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      end
    elsif @user
      flash.now[:error] = "Password is incorrect"
      render :new
    else
      flash.now[:error] = "There is no user with that email"
      render :new
    end
  end

  def destroy
    session.clear
    flash[:notice] = "Successfully logged out"
    redirect_to root_path
  end
end
