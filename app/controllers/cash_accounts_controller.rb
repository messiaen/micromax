class CashAccountsController < AccountsController
  
  def new
    unless admin_logged_in then return end
    
    @account = CashAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @account }
    end
  end
  
  def create
    unless admin_logged_in then return end
    
    people_ids = params[:account] ? params[:account].delete(:people) : []
    @account = CashAccount.new(params[:cash_account])
    
    respond_to do |format|
      if @account.save
        
        add_people(@account, people_ids)
        
        
        format.html { redirect_to "/admin", :notice => 'Account was successfully created.' }
        format.json { render :json => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.json { render :json => @account.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
