class Expense < Transaction
  
  validate :negative_amount
  
end