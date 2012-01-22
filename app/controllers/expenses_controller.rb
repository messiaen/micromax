class ExpensesController < TransactionsController
  
  def new
    @transaction = Expense.new
    
    render :contoller => :transactions, :action => :new
  end
  
  def create
    
    params[:expense][:person_id] = current_user.id
    
    @transaction = Expense.new()
    
    @account = Account.find(params[:expense][:account_id])
    
    
    respond_to do |format|
      if Transaction.insert_transaction(@transaction, params[:expense])
        
        flash[:notice] = "Expense Entered.  New Balance for '#{@account.name}': #{@account.balance}"
        format.html {redirect_to :back }
      else
        flash[:error] = "Error entering expense"
        format.html {render new_transaction_path }
      end
    end
    
  end
  
end
