class TransactionsController < ApplicationController
  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = {
      :all => Transaction.order(
        "date asc, created_at asc").where(
          "date >= ? AND date <= ?", 
          Date.today - 60.days, Date.today + 7.days),
      
      :expenses => Expense.order(
        "date asc, created_at asc").where(
          "date >= ? AND date <= ?", 
          Date.today - 60.days, Date.today + 7.days),
      
      :incomes => Income.order(
        "date asc, created_at asc").where(
          "date >= ? AND date <= ?", 
          Date.today - 60.days, Date.today + 7.days),
      
      :withdraws => Withdraw.order(
        "date asc, created_at asc").where(
          "date >= ? AND date <= ?", 
          Date.today - 60.days, Date.today + 7.days),
      
      :deposits => Deposit.order(
        "date asc, created_at asc").where(
          "date >= ? AND date <= ?", 
          Date.today - 60.days, Date.today + 7.days)
    }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @transactions }
    end
  end
  
  def sort_transactions
    @kind = params[:transaction_type]
    
    if @kind == "All"
      @transactions = Transaction.order(
        "date asc, created_at asc").where(
          "date >= ? AND date <= ?",
          Date.today - 60.days, Date.today + 7.days)
    else
      @transactions = Transaction.order(
        "date asc, created_at asc").where(
          :type => @kind).where(
            "date >= ? AND date <= ?",
            Date.today - 60.days, Date.today + 7.days)
    end
      
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @transaction }
    end
  end

  # GET /transactions/new
  # GET /transactions/new.json
  def new
    unless user_logged_in then return end
    @transaction = Transaction.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @transaction }
    end
  end

  # GET /transactions/1/edit
  def edit
    unless user_logged_in then return end
    @transaction = Transaction.find(params[:id])
  end

  # POST /transactions
  # POST /transactions.json
  def create
    unless user_logged_in then return end
    
    @transaction = Account.find(params[:transaction][:account_id]).last_transaction
    
    respond_to do |format|
      if @transaction.create_child(params[:transaction])
        format.html { redirect_to new_transaction_path(@transaction.child), :notice => "Transaction Entered" }
      else
        format.html { redirect_to new_transaction_path(@transaction.child), :error => "Error Entering Transaction" }
      end
    end
  end

  # PUT /transactions/1
  # PUT /transactions/1.json
  def update
    unless user_logged_in then return end
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      if Transaction.propagate_balances(@transaction)
        format.html { redirect_to :back, :notice => 'Transaction was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    unless admin_logged_in then return end
    
    @transaction = Transaction.find(params[:id])
    
    parent = @transaction.parent
    child  = @transaction.child
    
    if child
      child.parent_id = parent.id
      child.save
    end
    
    if parent
      parent.child_id = child.id
      parent.save
      
      Transaction.propagate_balances(parent)
    elsif child
      Transaction.propagate_balances(child)
    end
    
    @transaction.delete

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :ok }
    end
  end
end
