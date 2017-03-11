class Admin::UsersController < ApplicationController

  def new

  end

  def update
    user = User.find_by(email: params[:email])
    if user
      user.promote
      flash[:success] = "#{user.email} has been promoted to Community Leader."
    else
      flash[:error] = "Could not find a User with that email."
    end
    redirect_to new_admin_user_path
  end
end
