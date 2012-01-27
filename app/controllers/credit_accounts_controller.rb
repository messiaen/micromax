class CreditAccountsController < AccountsController
  
  def pay_account
    unless user_logged_in then return end
    @account = Account.find(params[:id])
  end
  
  def make_payment
    unless user_logged_in then return end
    
    @account = Account.find(params[:id])
    from = Account.find(params[:payment].delete(:from))
    
    params[:payment][:person_id] = current_user.id
    
    if @account.pay(from, params[:payment])
      flash[:notice] = "Payment Recorded"
      redirect_to accounts_path
    else
      flash[:error] =" Error recording payment"
      render "/credit_accounts/pay_account"
    end
  end
  
  def new
    unless admin_logged_in then return end
    
    @account = CreditAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @account }
    end
  end
  
  def create
    unless admin_logged_in then return end
    
    people_ids = params[:account] ? params[:account].delete(:people) : []
    @account = CreditAccount.new(params[:credit_card_account])
    
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
