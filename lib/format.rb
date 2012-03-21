module Format
  
  def self.date(date)
    date.to_date.strftime("%d %b %Y")
  end
  
  def self.to_2f(number)
    number ? sprintf("%0.2f", number) : ""
  end
  
  def self.money(num)
    num < 0 ? sprintf("-$%0.2f", num * -1) : sprintf("$%0.2f", num)
  end
  
end