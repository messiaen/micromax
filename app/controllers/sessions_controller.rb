class SessionsController < ApplicationController
  
  skip_before_filter :authenticate, :only => [:new, :create, :destroy]
  
  def new
    #reset_session
  end
  
  def create
    
    return_to = session[:return_to]
    
    if Person.authenticate(params[:person][:username], params[:person][:password])
      session[:user_id] = Person.find_by_username(params[:person][:username]).id
      
      redirect_to return_to || accounts_path
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
