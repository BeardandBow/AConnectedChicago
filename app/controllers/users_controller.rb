class UsersController < ApplicationController

  def show
    @user = current_user
    # use this to populate organizations dropdown
    # @organizations = Organization.where("name NOT IN (?)", current_user.organizations)
  end

  def new
    @user = User.new
  end

  def create
    neighborhood = Neighborhood.find_by(name: params[:user][:neighborhood])
    @user = neighborhood.users.create(user_params)
    if @user.save
      ConfirmationMailer.send_confirmation(@user).deliver_now
      flash[:success] = "Account created! Email confirmation sent to #{@user.email}"
      redirect_to root_path
    else
      flash.now[:error] = @user.errors.full_messages.to_sentence.downcase.capitalize
      render :new
    end
  end

  def update
    if params[:user] || params[:why] || params[:where]
      current_user.update_attributes(user_params)
      flash[:success] = "Your profile has been updated"
    elsif params[:organization]
      organization = Organization.find_by(name: params[:organization])
      current_user.organizations << organization if organization
      flash[:success] = "You have joined #{organization.name}"
    end
    redirect_to user_path(current_user)
  end

  def confirm_email
    user = User.find_by(email_token: params[:email_token])
    if user
      user.activate
      flash[:success] = "Welcome to A Connected Chicago! Your email has been confirmed.
      Please sign in to continue."
      redirect_to login_path
    else
      flash[:error] = "Invalid token. The user with that token has already been confirmed, or a user with that token does not exist."
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :why, :where, :how)
  end
end
