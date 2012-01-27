class Account < ActiveRecord::Base
  has_and_belongs_to_many :people, :join_table => :people_accounts
  has_many :transactions
  belongs_to :category
  
  def last_transaction
    self.transactions.where(:child_id => nil).first
  end
  
  def balance_string
    balance < 0 ? sprintf("-$%0.2f", balance * -1) : sprintf("$%0.2f", balance)
  end
  
  def balance
    self.last_transaction ? self.last_transaction.account_balance : 0
  end
  
  def pay
    return
  end

end
