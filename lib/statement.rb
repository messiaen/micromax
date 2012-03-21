class Statement

	def initialize(filename)
		@file = File.new(filename)

		@entries = []

		@filters = {}
		@raw_fields = {}
		@fields = {}

		line = @file.readline.strip.split(',')

		line.each_index do |i|
			@raw_fields[line[i].to_s] = i
		end
	end


	def get_raw_fields
		@raw_fields.keys
	end

	def get_fields
		@fields.values
	end

	def parse
		while (!@file.eof?)
			line = @file.readline.strip.tr_s("\"", "").split(',')

			entry = {}

			line.each_index do |i|
				if !(field = @fields[i]).nil?
					if !(func = @filters[field]).nil?
						func.call(entry, line[i].to_s)
					else
						entry[field] = line[i].to_s
					end
				end
			end

			if !entry.empty?
				@entries.push(entry)
			end
		end
	end

	def entries
		@entries
	end

	protected

	def description_to_category(string)
		descriptions_categories.each do |key, category|
			if string =~ key
				return category
			end
		end

		return nil
	end
		

	def descriptions_categories
		{
			/^UNOCHICAGOGRILL(.*)/		=> "dining",
			/^BP\s?(.*)/					=> "gas",
			/^SUNOCO(.*)/				=> "gas",
			/^GIANT(.*)/					=> "grocery",
			/^ADVANCED AUTO PARTS(.*)/	=> "car",
			/^STAPLES(.*)/				=> "technology",
			/^SHELL(.*)/					=> "gas",
			/^STARBUCKS(.*)/				=> "dining",
			/^CHICK FIL A(.*)/			=> "dining",
			/^HOBBY-LOBBY(.*)/			=> nil,
			/^MICHAELS(.*)/				=> nil,
			/^TARGET(.*)/				=> nil,
			/^AMAZON(.*)/				=> nil,
			/^BARNES & NOBLE(.*)/		=> "media",
			/^WAL-MART(.*)/				=> nil,
			/^UMBC BOOKSTORE(.*)/		=> "school",
			/^ROMANOS(.*)/				=> "dining",
			/^CLARKS(.*)/				=> "clothes",
			/^WWW.NEWEGG.COM(.*)/		=> "technology",
			/^BAJA FRESH(.*)/			=> "dining",
			/^EXXONMOBIL(.*)/			=> "gas",
			/^LOS PORTALES(.*)/			=> "dining",
			/^FT MEADE(.*)/				=> nil,
			/^JCPENNEY(.*)/				=> nil,
			/^HONEYBAKED HAM(.*)/		=> "grocery",
			/^RED ROBIN(.*)/				=> "dining"
		}
	end

	def map_filters(hash)
		hash.each do |field, function|
			if !@fields.has_value?(field)
				raise "#{field} is not a valid field name"
			end

			@filters[field.to_s] = function
		end
	end

	def map_fields(hash)
		hash.each do |raw, real|
			if !(raw_field_num = @raw_fields[raw.to_s]).nil?
				@fields[raw_field_num] = real.to_s
			else
				raise "#{raw} is not a raw field name"
			end
		end
	end



end

