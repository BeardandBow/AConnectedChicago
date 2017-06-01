class PermissionsService

  def initialize(user, controller, action)
    @_user        = user || User.new
    @_controller  = controller
    @_action      = action
  end

  def allow?
    return admin_permissions if user.admin?
    return community_leader_permissions if user.community_leader?
    return registered_user_permissions if user.registered_user?
    return visitor_permissions
  end

  private

  def user
    @_user
  end

  def controller
    @_controller
  end

  def action
    @_action
  end

  def admin_permissions
    return true if controller == 'artworks'
    return true if controller == 'events'
    return true if controller == 'home'
    return true if controller == 'sessions'
    return true if controller == 'stories'
    return true if controller == 'submissions'
    return true if controller == 'users' && action.in?(%w(show edit update))
    return true if controller == 'admin/submissions'
    return true if controller == 'admin/users'
    return true if controller == 'admin/types'
    return true if controller == 'admin/organizations'
    return true if controller == 'charges'
  end

  def community_leader_permissions
    return true if controller == 'artworks'
    return true if controller == 'events'
    return true if controller == 'home'
    return true if controller == 'sessions'
    return true if controller == 'stories'
    return true if controller == 'submissions'
    return true if controller == 'users' && action.in?(%w(show edit update))
    return true if controller == 'charges'
  end

  def registered_user_permissions
    return true if controller == 'artworks'
    return true if controller == 'events'
    return true if controller == 'home'
    return true if controller == 'sessions'
    return true if controller == 'stories'
    return true if controller == 'users' && action.in?(%w(show edit update))
    return true if controller == 'charges'
  end

  def visitor_permissions
    return true if controller == 'artworks' && action.in?(%w(show))
    return true if controller == 'events' && action.in?(%w(show))
    return true if controller == 'home'
    return true if controller == 'sessions' && action.in?(%w(new create))
    return true if controller == 'stories' && action.in?(%w(show))
    return true if controller == 'users' && action.in?(%w(new create confirm_email))
    return true if controller == 'charges'
  end
end
