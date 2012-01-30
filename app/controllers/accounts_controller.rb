class AccountsController < ApplicationController
  include SessionsHelper
  
  # GET /accounts
  # GET /accounts.json
  def index
    unless user_logged_in then return end
    
    @accounts = Account.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @accounts }
    end
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    unless user_logged_in then return end
    
    @account = Account.find(params[:id])
    
    @start_date = Date.today - 60.days
    @end_date   = Date.today + 7.days
    
    
    @transactions = @account.transactions.order(
                      "date asc, created_at asc"
                    ).where(
                      "date >= ? AND date <= ?",
                      @start_date,
                      @end_date)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @account }
    end
  end
  
  def withdraw
    unless user_logged_in then return end
    
    @account = Account.find(params[:id])
    @transaction = Withdraw.new(:description => "ATM Withdraw")
  end
  
  def make_withdraw
    unless user_logged_in then return end
    
    @account = Account.find(params[:id])
    
    if @account.category.internal_name == "cash"
      flash[:error] = "Can not withdraw from a cash account please select another account"
      redirect_to :controller => :accounts, :action => :index
    end
    
    to_account = Account.find_by_category_id(Category.find_by_internal_name("cash").id)
    
    params[:withdraw][:person_id] = current_user.id
    
    if Transaction.transfer(@account.id, to_account.id, params[:withdraw])
      flash[:notice] = "Withdraw Recorded"
      redirect_to account_path(@account)
    else
      flash[:error] = "Error Recording Deposit"
      render :controller => :accounts, :action => :withdraw
    end
    
  end
  
  def deposit
    unless user_logged_in then return end
    
    @account = Account.find(params[:id])
    @transaction = Deposit.new
  end
  
  def make_deposit
    unless user_logged_in then return end
    
    @account = Account.find(params[:id])
    @transaction = Deposit.new
    
    params[:deposit][:account_id] = @account.id
    params[:deposit][:person_id] = current_user.id
    
    if Transaction.insert_transaction(@transaction, params[:deposit])
      flash[:notice] = "Deposit Recorded"
      redirect_to account_path(@account)
    else
      flash[:error] = "Error Recording Deposit"
      render :controller => :accounts, :action => :make_deposit
    end
    
  end

  # GET /accounts/new
  # GET /accounts/new.json
  def new
    unless admin_logged_in then return end
    
    @account = Account.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    unless admin_logged_in then return end
    
    @account = Account.find(params[:id])
    
    @people_to_add = Person.all.select do |person|
      !@account.people.include?(person) && !person.is_admin?
    end
    
  end

  # POST /accounts
  # POST /accounts.json
  def create
    unless admin_logged_in then return end
    
    people_ids = params[:account].delete(:people)
    @account = Account.new(params[:account])
    
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
  
  def add_people(account, people_ids)
    people_ids.map {|id| Person.find(id)}.each do |person|
      unless person.is_admin?
        account.people << person
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.json
  def update
    unless admin_logged_in then return end
    
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to "/admin", :notice => 'Account was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @account.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def add_remove_users
    unless admin_logged_in then return end
    
    add_people    = params[:account][:add_people] || []
    remove_people = params[:account][:remove_people] || []
    
    @account = Account.find(params[:id])
    
    remove_people.map {|id| Person.find(id)}.each do |person|
      @account.people.delete(person)
    end
    
    add_people.map {|id| Person.find(id)}.each do |person|
      @account.people << person
    end
    
    if @account.save
      flash[:notice] = "Users added / removed successfully"
      redirect_to edit_account_path
    end
    
  end
  
  def get_transactions
    @account = Account.find(params[:id])
    
    @start_date = if params[:transactions_list][:start_date].nil? || 
        params[:transactions_list][:start_date].strip! == ""
      
      @account.created_at.to_date
      
    else
      Time.parse(params[:transactions_list][:start_date]).utc.to_date
    end
    
    @end_date = if params[:transactions_list][:end_date].nil? || 
        params[:transactions_list][:end_date].strip! == ""
      
      Date.today.utc
      
    else
      Time.parse(params[:transactions_list][:end_date]).utc.to_date
    end
    
    @transactions = @account.transactions.order(
                      "date desc, created_at desc"
                    ).where(
                      "date >= ? AND date <= ?",
                      @start_date,
                      @end_date)
    
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    unless admin_logged_in then return end
    
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to "/admin" }
      format.json { head :ok }
    end
  end
end
