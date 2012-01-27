
# any account that is considered debt
# any account to which you make payments
# the balance of these account is always less than or equal to 0
class CreditAccount < Account
  
  validate :negative_min_balance
  
  def negative_min_balance
    unless self.min_balance <= 0
      self.min_balance = self.min_balance * -1
    end
  end
  
  
  def pay (from, params)
    params[:account_id] = from.id
    @transaction = Expense.new
    
    params[:category_id] = Category.where(:kind => "Expense", :internal_name => "payment").first.id
    
    unless Transaction.insert_transaction(@transaction, params)
      raise Exception
      return false
    end
    
    params[:account_id] = self.id
    @transaction = Deposit.new
    
    params[:category_id] = Category.where(:kind => "Deposit", :internal_name => "payment").first.id
    
    unless Transaction.insert_transaction(@transaction, params)
      raise Exception
      return false
    end
    
    return true
  end
  
end