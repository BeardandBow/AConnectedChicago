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
    neighborhood = Neighborhood.find_by(name: params[:user][:neighborhood])
    organization = Organization.find_by(name: params[:user][:organizations][:name])
    @user = neighborhood.users.create(user_params)
    @user.organizations << organization if organization
    if @user.save
      ConfirmationMailer.send_confirmation(@user).deliver
      flash[:success] = "Account created! Email confirmation sent to #{@user.email}"
      redirect_to root_path
    else
      flash.now[:error] = @user.errors.full_messages.to_sentence.downcase.capitalize
      render :new
    end
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
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end
end
