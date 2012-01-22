class Withdraw < Transaction
  
  validate :negative_amount
  
end