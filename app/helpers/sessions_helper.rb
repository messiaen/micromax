module SessionsHelper
  
  def current_user
    @current_user ||= Person.find_by_id(session[:user_id])
  end
  
  def logged_in
    !current_user.nil?
  end
  
  def check_login
    unless logged_in
      flash[:error] = "Please login to continue"
      session[:return_to] = request.fullpath
      redirect_to :root
      
      return false
    end
    
    return true
  end
  
  def admin_logged_in
    unless logged_in && current_user.is_admin?
      flash[:error] = "Please login as an Admin to continue."
      session[:return_to] = request.fullpath
      redirect_to :root
      
      return false
    end
    
    return true
  end
  
  def user_logged_in
    unless logged_in && !current_user.is_admin?
      flash[:error] = "Please login as a regular user to continue."
      session[:return_to] = request.fullpath
      redirect_to :root
      return false
    end
    
    return true
  end
  
end
