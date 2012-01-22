module SessionsHelper
  
  def current_user
    @current_user ||= Person.find_by_id(session[:user_id])
  end
  
  def admin_only
    unless current_user.is_admin?
      flash[:error] = "Please login as an Admin to continue."
      session[:return_to] = request.fullpath
      redirect_to :root
      return false
    end
    
    return true
  end
  
  def user_only
    unless !current_user.is_admin?
      flash[:error] = "Please login as a regular user to continue."
      session[:return_to] = request.fullpath
      redirect_to :root
      return false
    end
    
    return true
  end
  
end
