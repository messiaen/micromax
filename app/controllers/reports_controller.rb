class ReportsController < ApplicationController
  
  def index
  end
  
  def monthly_expenses
    month = params[:date][:month]
    year = params[:date][:year]
    
    @min_date = Date.parse("#{year}-#{month}-1")
    @max_date = @min_date + 1.month
    
    @transactions = Expense.where("date >= ? AND date < ?", @min_date, @max_date).order("date asc")
    
    @categories = Category.where(:kind => "Expense").order("name asc")
    
    render :file => "/reports/category_table_report.html"
  end
  
end
