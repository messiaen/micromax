require 'password.rb'

class PeopleController < ApplicationController
  # GET /people
  # GET /people.json
  def index
    unless admin_logged_in then return end
    
    @people = Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @people }
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    unless admin_logged_in then return end
    
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @person }
    end
  end

  # GET /people/new
  # GET /people/new.json
  def new
    unless admin_logged_in then return end
    
    @person = Person.new()

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
    
    unless current_user.id == @person.id
      flash[:error] = "Users can only edit their own profile"
      redirect_to :back
      return
    end
    
  end

  # POST /people
  # POST /people.json
  def create
    unless admin_logged_in then return end
    
    confirm = params[:person][:confirm]
    params[:person].delete(:confirm)
    
    if confirm == params[:person][:password]
    
      salt  = Password.generate_salt
      store = Password.generate_store(confirm, salt)
    else
      flash[:error] = "password don't match"
      render :controller => :people, :action => :new
      return
    end
    
    categories = []
    ["Income", "Expense", "Withdraw", "Deposit"].each do |kind|
      categories << Category.where(:kind => kind).first
    end
    
    params[:person][:password] = store
    
    @person  = Person.new(params[:person])
    
    if @person.save
      profile = Profile.create(:person_id => @person.id)
      profile.categories = categories
      
      @person.accounts << Account.find_by_name("Cash")
      
      profile.account = @person.accounts.first
      profile.save
      
      flash[:notice] = "User account created"
      redirect_to person_path(@person)
    else
      flash[:error] = "Error creating user. Please check you input."
      render :controller => :people, :action => :new
    end
  end

  # PUT /people/1
  # PUT /people/1.json
  def update
    @person  = Person.find(params[:id])
    @profile = @person.profile
    
    
    unless current_user.id == @person.id
      flash[:error] = "Users can only edit their own profile"
      redirect_to :back
      return
    end
    
    categories = params[:profile].delete(:categories)
    
    @profile.categories = Category.where(:id => categories)
    @profile.account_id = params[:profile][:account_id]
    @profile.save
    
    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to :back, :notice => 'Person was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @person.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit_password
    @person = Person.find(params[:id])
    
    unless current_user.id == @person.id
      flash[:error] = "Users can only edit their own password"
      redirect_to :back
      return
    end
  end
  
  def update_password
    @person = Person.find(params[:id])
    
    unless current_user.id == @person.id
      flash[:error] = "Users can only edit their own profile"
      redirect_to :back
      return
    end
    
    if Person.authenticate(@person.username, params[:person][:old_password]) &&
        params[:person][:password] == params[:person][:confirm]
      
      salt = Password.generate_salt
      @person.password = Password.generate_store(params[:person][:password], salt)
      @person.save
      
      flash[:notice] = "Password changed"
      redirect_to "/people/#{@person.id}/edit"
    else
      flash[:error] = "Error. Password not updated"
      render :action => :edit_password
    end
    
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    unless admin_logged_in then return end
    
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to people_url }
      format.json { head :ok }
    end
  end
end
