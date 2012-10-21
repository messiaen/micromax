#TODO deposits and withdraws can be handled by the accounts_controller

class WithdrawsController < TransactionsController
  
  def new
    @transaction = Withdraw.new
  end
end
