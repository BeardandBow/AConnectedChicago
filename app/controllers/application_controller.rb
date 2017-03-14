class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user,
                :community_leader?,
                :admin?
  before_action :authorize!

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def community_leader?
    current_user && current_user.role == "community_leader"
  end

  def admin?
    current_user && current_user.role == "admin"
  end

  private

  def authorize!
    unless authorize?
      render :file => 'public/403.html', :status => :forbidden, :layout => false
    end
  end

  def authorize?
    current_permission.allow?
  end

  def current_permission
    @current_permission ||= PermissionsService.new(current_user, params[:controller], params[:action])
  end
end
