require 'statement'

class TowerfcuStatement < Statement
	
	def initialize(filename)
		super(filename)

		self.map_fields("Date" => "date", "Description" => "description", 
			"Amount Debit" => "amount", "Amount Credit" => "amount")

		self.map_filters(
			"date" => lambda {|entry, string|
				entry["date"] = Time.parse(string)},
			"amount" => lambda {|entry, string|
				entry["amount"] = string.to_f

				if entry["type"].nil?
					if entry["amount"] < 0
						entry["type"] = "Expense"
					elsif entry["amount"] >= 0
						entry["type"] = "Income"
					end
				end},
			"description" => lambda {|entry, string|
				entry["description"] = string
				entry["category"] = self.description_to_category(
					string.upcase)} )

	end

	def descriptions_categories
		super
	end



end
