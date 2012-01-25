class SessionsController < ApplicationController
  
  skip_before_filter :authenticate, :only => [:new, :create, :destroy]
  
  def new
    #reset_session
  end
  
  def create
    
    return_to = session[:return_to]
    
    if Person.authenticate(params[:person][:username], params[:person][:password])
	  person = Person.find_by_username(params[:person][:username])
      session[:user_id] = person.id
      
	  if person.is_admin? 
        redirect_to return_to || "/admin"
	  else
	    redirect_to return_to || accounts_path
	  end
    else
      flash[:error] = "Invalid Username / Password"
      redirect_to :root
    end
  end
  
  def destroy
    reset_session
    
    flash[:notice] = "Logout Successful"
    redirect_to :root
  end
  
end
