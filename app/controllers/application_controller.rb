class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :community_leader?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def community_leader?
    current_user && current_user.role == "community_leader"
  end
end
