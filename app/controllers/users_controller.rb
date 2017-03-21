class UsersController < ApplicationController

  before_action :new, only: [:create]
  before_action :sanitize_params, only: [:update]

  def show
    @user = current_user
    # use this to populate organizations dropdown
    # @organizations = Organization.where("name NOT IN (?)", current_user.organizations)
  end

  def new
    @user = User.new
    @neighborhoods = Neighborhood.order(:name).pluck(:name)
    @organizations = Organization.order(:name).pluck(:name)
  end

  def create
    @user = User.create(user_params)
    neighborhood = Neighborhood.find_by(name: params[:user][:neighborhood])
    if neighborhood.nil?
      flash.now[:error] = "Please select your home neighborhood."
      render :new
    else
      neighborhood.users << @user
      if @user.save
        ConfirmationMailer.send_confirmation(@user).deliver_now
        flash[:success] = "Account created! Email confirmation sent to #{@user.email}"
        redirect_to root_path
      else
        flash.now[:error] = @user.errors.full_messages.to_sentence.downcase.capitalize
        render :new
      end
    end
  end


  def edit
    @user = User.find(params[:id])
    @neighborhoods = Neighborhood.order(:name).pluck(:name)
    @organizations = Organization.where.not(id: current_user.organizations.pluck(:id)).pluck(:name)
  end

  def update
    current_user.update_attributes(user_params)
    if params[:user][:organizations]
      org = Organization.find_by(name: params[:user][:organizations])
      org.users << current_user
    end
    flash[:success] = "Your profile has been updated!"
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
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :gender, :race, :why, :where, :how)
  end

  def sanitize_params
    params[:user].delete_if {|k,v| v.blank?} if params[:user]
  end
end
