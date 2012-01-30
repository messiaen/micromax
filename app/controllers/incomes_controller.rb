class IncomesController < TransactionsController
  
  def new
    unless user_logged_in then return end
    
    @transaction = Income.new
    
    render :contoller => :transactions, :action => :new
  end
  
  def create
    
    params[:income][:person_id] = current_user.id
    
    @transaction = Income.new
    
    @account = Account.find(params[:income][:account_id])
    
    respond_to do |format|
      if Transaction.insert_transaction(@transaction, params[:income])
        flash[:notice] = "Income Created.  New Balance for '#{@account.name}': #{@account.balance_string}"
        format.html {redirect_to :back}
      else
        flash[:error] = "Error creating Income"
        format.html {render new_transaction_path}
      end
    end
  end
  
end
