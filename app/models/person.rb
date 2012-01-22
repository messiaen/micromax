require 'password.rb'

class Person < ActiveRecord::Base
  has_and_belongs_to_many :accounts, :join_table => :people_accounts
  has_many :transactions
  has_one :profile
  
  has_many :categories, :through => :profile
  has_one  :default_account, :through => :profile, :source => :account
  
  
  validates_presence_of :username
  validates_presence_of :password
  validates_uniqueness_of :username
  
  
  def self.authenticate(username, plain_pass)
    if !(@user = Person.find_by_username(username))
      return false
    end
    
    Password.check_password(plain_pass, @user.password)
    
  end
  
  def is_admin?
    return self.profile.is_admin
  end
  
end
