class AdminController < ApplicationController
  
  def admin
    unless admin_logged_in then return end
  end
  
  def update_accounts_users
    unless admin_logged_in then return end
    
    @account = Account.find(params[:account][:account_id])
    @person  = Person.find(params[:person][:person_id])
    
    if !@account.people.include?(@person)
      @account.people << @person
      
      flash[:notice] = "'#{@person.name}' has been added to '#{@account.name}'"
    else
      flash[:notice] = "'#{@person.name}' is already on '#{@account.name}'"
    end

    
    redirect_to "/admin"
    
  end
  
  def edit_account
    unless admin_logged_in then return end
    
    @account = Account.find(params[:account_id])
    
    redirect_to edit_account_path(@account)
  end
  
  def admin_account_list
    unless admin_logged_in then return end
  end
  
  
end
