class ApplicationController < ActionController::Base
  include SessionsHelper
  
  protect_from_forgery
  
  #before_filter :authenticate
  
  def authenticate
    if !Person.find_by_id(session[:user_id])
      reset_session
      
      flash[:error] = "Please Login"
      redirect_to :root
    end
  end
  
end
