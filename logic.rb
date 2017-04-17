def filter_security_logic(table, tables, clearance, schema, itr)
	new_table = []
		if tables.include?(0) && !tables.include?(1) && !tables.include?(2)
			table.each do |row|
				if itr == 0
					new_table.push(row)
					itr = 1
				else
					if row[schema["akc"]] <= clearance && row[schema["atc"]] <= clearance
						new_table.push(row)
					end
				end
			end
		elsif !tables.include?(0) && tables.include?(1) && !tables.include?(2)
			table.each do |row|
				if itr == 0
					new_table.push(row)
					itr = 1
				else
					if row[schema["bkc"]] <= clearance && row[schema["btc"]] <= clearance
						new_table.push(row)
					end
				end
			end
		elsif !tables.include?(0) && !tables.include?(1) && tables.include?(2)
			table.each do |row|
				if itr == 0
					new_table.push(row)
					itr = 1
				else
					if row[schema["ckc"]] <= clearance && row[schema["ctc"]] <= clearance
						new_table.push(row)
					end
				end
			end
		elsif tables.include?(0) && tables.include?(1) && !tables.include?(2)
			table.each do |row|
				if itr == 0
					new_table.push(row)
					itr = 1
				else
					if row[schema["akc"]] <= clearance && row[schema["atc"]] <= clearance && row[schema["bkc"]] <= clearance && row[schema["btc"]] <= clearance
						new_table.push(row)
					end
				end
			end
		elsif !tables.include?(0) && tables.include?(1) && tables.include?(2)
			table.each do |row|
				if itr == 0
					new_table.push(row)
					itr = 1
				else
					if row[schema["bkc"]] <= clearance && row[schema["btc"]] <= clearance && row[schema["ckc"]] <= clearance && row[schema["ctc"]] <= clearance
						new_table.push(row)
					end
				end
			end
		elsif tables.include?(0) && !tables.include?(1) && tables.include?(2)
			table.each do |row|
				if itr == 0
					new_table.push(row)
					itr = 1
				else
					if row[schema["akc"]] <= clearance && row[schema["atc"]] <= clearance && row[schema["ckc"]] <= clearance && row[schema["ctc"]] <= clearance
						new_table.push(row)
					end
				end
			end
		elsif tables.include?(0) && tables.include?(1) && tables.include?(2)
			table.each do |row|
				if itr == 0
					new_table.push(row)
					itr = 1
				else
					if row[schema["akc"]] <= clearance && row[schema["atc"]] <= clearance && row[schema["bkc"]] <= clearance && row[schema["btc"]] <= clearance && row[schema["ckc"]] <= clearance && row[schema["ctc"]] <= clearance
						new_table.push(row)
					end
				end
			end
		end
		tables = new_table
		tables
end

def where_logic(table, tables, where, schema, clearance, i, itr)
	new_table = []
	table.each do |row|
		if itr == 0
			new_table.push(row)
			itr = 1
		else
			if (where[i] == "atc") || (where[i] == "btc") || (where[i] == "ctc")
				if where[i+2] > clearance
					abort("You don't have the clearance for that")
				end
				if tables.include?(0) && !tables.include?(1) && !tables.include?(2)
					if row[schema["atc"]].to_i.send("<=",where[i+2].to_i) && row[schema["akc"]].to_i.send("<=",where[i+2].to_i)
						new_table.push(row)
					end
				elsif !tables.include?(0) && tables.include?(1) && !tables.include?(2)
					if row[schema["btc"]].to_i.send("<=",where[i+2].to_i) && row[schema["bkc"]].to_i.send("<=",where[i+2].to_i)
						new_table.push(row)
					end
				elsif !tables.include?(0) && tables.include?(1) && !tables.include?(2)
					if row[schema["ctc"]].to_i.send("<=",where[i+2]).to_i && row[schema["ckc"]].to_i.send("<=",where[i+2].to_i)
						new_table.push(row)
					end
				elsif tables.include?(0) && tables.include?(1) && !tables.include?(2)
					if row[schema["atc"]].to_i.send("<=",where[i+2].to_i) && row[schema["btc"]].to_i.send("<=",where[i+2].to_i) && row[schema["akc"]].to_i.send("<=",where[i+2].to_i) && row[schema["bkc"]].to_i.send("<=",where[i+2].to_i)
						new_table.push(row)
					end
				elsif !tables.include?(0) && tables.include?(1) && tables.include?(2)
					if row[schema["btc"]].to_i.send("<=",where[i+2].to_i) && row[schema["ctc"]].to_i.send("<=",where[i+2].to_i) && row[schema["bkc"]].to_i.send("<=",where[i+2].to_i) && row[schema["ckc"]].to_i.send("<=",where[i+2].to_i)
						new_table.push(row)
					end
				elsif tables.include?(0) && !tables.include?(1) && tables.include?(2)
					if row[schema["atc"]].to_i.send("<=",where[i+2].to_i) && row[schema["ctc"]].to_i.send("<=",where[i+2].to_i) && row[schema["akc"]].to_i.send("<=",where[i+2].to_i) && row[schema["ckc"]].to_i.send("<=",where[i+2].to_i)
						new_table.push(row)
					end
				elsif tables.include?(0) && tables.include?(1) && tables.include?(2)
					if row[schema["atc"]].to_i.send("<=",where[i+2].to_i) && row[schema["btc"]].to_i.send("<=",where[i+2].to_i) && row[schema["ctc"]].to_i.send("<=",where[i+2].to_i) && row[schema["akc"]].to_i.send("<=",where[i+2].to_i) && row[schema["bkc"]].to_i.send("<=",where[i+2].to_i) && row[schema["ckc"]].to_i.send("<=",where[i+2].to_i)
						new_table.push(row)
					end
				end
			else
				if (!where[i].is_i?) && (!where[i+2].is_i?)
					if row[schema[where[i]]].to_i.send( where[i+1] , row[schema[where[i+2]]].to_i )
						new_table.push(row)
					end
				elsif (!where[i].is_i?) && (where[i+2].is_i?)
					if row[schema[where[i]]].to_i.send( where[i+1] , where[i+2].to_i )
						new_table.push(row)
					end
				elsif (where[i].is_i?) && (!where[i+2].is_i?)
					if where[i].to_i.send( where[i+1] , row[schema[where[i+2]]].to_i)
						new_table.push(row)
					end
				end
			end
		end
	end
	new_table	
end
