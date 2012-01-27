class CreditCardAccount < CreditAccount
  
  def pay (from, params)
    params[:account_id] = from.id
    @transaction = Withdraw.new
    
    params[:category_id] = Category.where(:kind => "Withdraw", :internal_name => "payment").first.id
    
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