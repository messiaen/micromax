require 'statement'

class ChaseStatement < Statement

	def initialize(filename)
		super(filename)

		self.map_fields("Amount" => "amount", "Trans Date" => "date", 
			"Description" => "description", "Type" => "type")

		self.map_filters(
			"date" => lambda {|entry, string| entry["date"] = Time.parse(string)},
			"amount" => lambda {|entry, string| entry["amount"] = string.to_f},
			"type" => lambda {|entry, string| 
				entry["type"] = if string == "Sale"
					"Expense"
				else
					"Payment"
				end},
			"description" => lambda {|entry, string|
				entry["description"] = string.to_s
				entry["category"] = self.description_to_category(
					string.upcase)} )
	end

	def descriptions_categories
		super
	end

end
