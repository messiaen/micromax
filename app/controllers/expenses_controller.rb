class ExpensesController < TransactionsController
  
  def new
    unless user_logged_in then return end
    
    @transaction = Expense.new
    
    render :contoller => :transactions, :action => :new
  end
  
  def create
    
    params[:expense][:person_id] = current_user.id
    
    @transaction = Expense.new()
    
    @account = Account.find(params[:expense][:account_id])
    
    
    respond_to do |format|
      if Transaction.insert_transaction(@transaction, params[:expense])
        
        flash[:notice] = "Expense Entered.  New Balance for '#{@account.name}': #{@account.balance_string}"
        format.html {redirect_to :back }
      else
        flash[:error] = "Error entering expense"
        format.html {render new_transaction_path }
      end
    end
    
  end
  
  def update
    params[:expense][:person_id] = current_user.id
    
    @old_t = Transaction.find(params[:id])
    
    params.delete(:id)
    
    @new_t = Expense.new(params[:expense])
    
    @t = Expense.where(:description => @new_t.description, :date => @new_t.date).first
    
    respond_to do |format|
      if Transaction.update_transaction(@old_t, @new_t)
        @t = Expense.where(:description => @new_t.description, :date => @new_t.date, :account_id => @new_t.account_id).first
        flash[:notice] = "Expense updated successfully"
        format.html {redirect_to "/transactions/#{@t.id}/edit" }
      else
        flash[:error] = "Error updating expense"
        format.html {render edit_transaction_path(@old_t) }
      end
    end
    
  end
  
end
