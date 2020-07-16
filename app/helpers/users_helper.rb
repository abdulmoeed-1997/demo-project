module UsersHelper
  def user_logged_in?
    if session[:user_id] != nil
      return true
    else
      return false
    end
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

end
