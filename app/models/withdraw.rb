class Withdraw < Transaction
  
  validate :negative_amount
  
  validate :bank_accounts_only
  
  def bank_accounts_only
    Account.find_by_id(self.account_id).type != "BankAccount"
  end
  
end