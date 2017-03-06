class UsersController < ApplicationController

  def show
    if current_user
      @user = current_user
    else
      render :file => 'public/403.html', :status => :forbidden, :layout => false 
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      flash[:success] = "Account created!"
      session[:user_id] = @user.id
      redirect_to user_path(current_user)
    else
      flash.now[:error] = "Account was not created"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
