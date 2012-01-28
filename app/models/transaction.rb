require 'search.rb'
require 'format.rb'

class Transaction < ActiveRecord::Base
  belongs_to :category
  
  belongs_to :child, :class_name => "Transaction", :foreign_key => "child_id"
  belongs_to :parent, :class_name => "Transaction", :foreign_key => "parent_id"
  
  belongs_to :person
  belongs_to :account
  
  
  validates_presence_of :category_id
  validates_presence_of :amount
  validates_presence_of :date
  validates_presence_of :account_id
  
  def self.insert_transaction(transaction, params)
    account = Account.find(params[:account_id])
    transactions = account.transactions.order("date asc")
    
    transaction.date        = params[:date]
    transaction.amount      = params[:amount]
    transaction.description = params[:description]
    transaction.category_id = params[:category_id]
    transaction.person_id   = params[:person_id]
    
    parent, child = Search.find_around(transactions, transaction, "date")
    
    transaction.parent_id  = parent ? parent.id : nil
    transaction.account_id = account.id
    transaction.child_id   = child ? child.id : nil
    
    
    unless transaction.save
      raise Exception, "#{transaction.errors.full_messages}"
      return false
    end
    
    if parent
      parent.child_id = transaction.id
      
      unless parent.save
        raise Exception, "!!!"
        return false
      end
    end
    
    if child
      child.parent_id = transaction.id
      
      unless child.save
        raise Exception, "!!!"
        return false
      end
    end
    
    return Transaction.propagate_balances(transaction)
  end
  
  def self.propagate_balances (transaction)
    parent = transaction.parent
    
    transaction.account_balance = if parent
      parent.account_balance + transaction.amount
    else
      transaction.amount
    end
    
    unless transaction.save
      return false
    end
    
    if transaction.child
      return Transaction.propagate_balances(transaction.child)
    end
    
    return true
  end
  
  def self.transfer (from_id, to_id, params)
    params[:account_id] = from_id
    @transaction = Withdraw.new
    
    Transaction.insert_transaction(@transaction, params)
    
    params[:account_id] = to_id
    @transaction = Deposit.new
    
    Transaction.insert_transaction(@transaction, params)
    
  end
  
  def self.sum(transactions)
    sum = 0
    transactions.each do |transaction|
      sum += transaction.amount || 0
    end
    
    return sum
  end
  
  def date_string
    Fromat.date(self.date)
  end
  
  def negative_amount
    if self.amount && self.amount > 0
      self.amount = self.amount * -1
    end
  end
  
end
