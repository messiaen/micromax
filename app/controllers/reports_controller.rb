class ReportsController < ApplicationController
  
  def index
  end
  
  def monthly_expenses
    month = params[:date][:month]
    year = params[:date][:year]
    
    @min_date = Date.parse("#{year}-#{month}-1")
    @max_date = @min_date + 1.month
    
    @transactions = Expense.where("date >= ? AND date < ?", @min_date, @max_date).order("date asc, created_at asc")
    
    @category_sums = {}
    
    @transactions.group("category_id").
        select("category_id, sum(amount) as total").
        each {|t| @category_sums[t.category.name.to_s] = t.total}
    
    @categories = Category.where(:kind => "Expense").order("name asc")
    
    grand_total = @transactions.select(
            "sum(amount) as total").map {|t| t.total.abs}.first
    
    @chart_data = @category_sums.to_a.map {|a| [a[0], (a[1] / grand_total) * 100]}
    
    @total_income = Income.where("date >= ? AND date < ?", @min_date, @max_date).
      select("sum(amount) as total").map {|t| t.total}.first
    
    @bar_data = @category_sums.to_a.map {|a| a[1].abs}
    @category_names = @category_sums.to_a.map {|a| a[0]}
    
    @bar_data.unshift(grand_total)
    @category_names.unshift("Total")
    
    @income_line = []
    @category_names.size.times do |i|
      @income_line.push @total_income
    end
    
    render :file => "/reports/category_table_report.html"
  end
  
  def monthly_categories_pie_chart
    month = params[:date][:month]
    year = params[:date][:year]
    
    @min_date = Date.parse("#{year}-#{month}-1")
    @max_date = @min_date + 1.month
    
    grand_total = Expense.where(
        "date >= ? AND date < ?", @min_date, @max_date).select(
            "sum(amount) as total").map {|t| t.total.abs}.first
    
    @chart_data = Expense.where(
        "date >= ? AND date < ?", @min_date, @max_date).group("category_id").
            select("category_id, sum(amount) as total").
            map {|t| [t.category.name, (t.total.abs / grand_total.abs) * 100] }
    
  end
  
end
