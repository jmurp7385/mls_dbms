require 'matrix'
require 'sql_tree'
require_relative 'logic.rb'

def readTable(file, rows, cols)
	table = []
	File.open(file).each do |line|
		tuple = []
		tuple = line.split(' ')
    		table.push(tuple)
  	end
	table
end

def printTable(table)
	width = table.flatten.max.to_s.size+4
	puts table.map { |a| a.map { |i| i.to_s.rjust(width) }.join }
end

def check_clearance(x)
	clearance_level = x.split(' ')[0]
	if clearance_level[/\A\d+\z/] ? true : false
		clearance_level
	else
		0
	end
end

def remove_clearance_at_front(str)
	arr = str.split(' ')
	if arr[0][/\d+/]
		arr[0] = ''
		if arr[1][/\s+/]
			arr[1] = ''
		end
	end
	str = arr.join(' ')
	str
end

def get_cols(q)
	cols = []
	add = 0
	q.each do |part|
		if part == "select"
			add = 1
		end
		if part == "from"
			add = 0
		end
		if add == 1
			cols.push(part)
		end
	end
	cols.shift
	cols
end

def get_tables(q)
	tables = []
	add = 0
	q.each do |part|
		if part == "from"
			add = 1
		end
		if part == "where"
			add = 0
		end
		if add == 1
			tables.push(part)
		end
	end
	tables.shift
	tables
end

def join(used,t1,t2,t3)
	join_cols = []
	new_table = []
	i = 0
	while i < 200  do
		new_row = join_cols.push(t1[i]).push(t2[i]).push(t3[i])
		new_table.push(new_row.flatten)
		i = i + 1
		join_cols = []
	end
	new_table
end

def to_m(t)
	m = Matrix[]
	t.each do |row|
		m = Matrix.rows(m.to_a << row)
	end
	m
end

def print_matrix(m)
	#m.to_a.each {|r| puts r.inspect}
	width = m.flatten.max.to_s.size+4
        puts m.map { |a| a.map { |i| i.to_s.rjust(width) }.join }
end

def print_query(m,cols,tables)
	ans = []
	cols.each do |c|
		#puts c
		if c >= 0 && c < 4
			if tables.include?(0)
				ans.push(m.column(c).to_a)
			end
		end
		if c >= 4 && c < 9
			if tables.include?(1)
				ans.push(m.column(c).to_a)
			end
		end
		if c >= 9 && c < 15
			if tables.include?(2)
				ans.push(m.column(c).to_a)
			end
		end
	end
	print_matrix(ans.transpose)
end

def convert_cols(cols,tables,schema)
	cols_new = []
	if cols.include?('*')
		if tables.include?(0)
			cols_new.push(0,1,2,3)
		end
		if tables.include?(1)
			cols_new.push(4,5,6,7,8)
		end
		if tables.include?(2)
			cols_new.push(9,10,11,12,13,14)
		end
	else
		cols.each do |col|
			cols_new.push(schema[col])
		end
		if cols.include?("a1")
			cols_new.push(schema["akc"])	#really adds akc col
		elsif cols.include?("b1")
			cols_new.push(schema["bkc"])	#really adds bkc col
		elsif cols.include?("c1")
			cols_new.push(schema["ckc"])	#really adds ckc col
		end
	end
	if !cols_new.include?(schema["atc"])
		cols_new.push(schema["atc"])
	end
	if !cols_new.include?(schema["btc"])
		cols_new.push(schema["btc"])
	end
	if !cols_new.include?(schema["ctc"])
		cols_new.push(schema["ctc"])
	end
	cols_new
end

def convert_tables(tables,schema)
	tables_new = []
	tables.each do |table|
		tables_new.push(schema[table])
	end
	tables_new
end

def filter_security(table,tables,clearance,schema)
	new_table = []
	itr = 0
	count = 0
	while count < tables.size
		table = filter_security_logic(table, tables, clearance, schema, itr)
		itr = 0
		count += 1
	end
	new_table = table
	new_table
end

class String
	def is_i?
        	/\A[-+]?\d+\z/ === self
	end
end

def where(table, tables, where, schema, clearance)
	new_table = []
	where.slice! "and"
	where = where.split(' ')
	if where.include?("=")
		where[where.index("=")].replace("==")
	end
	clauses = where.size / 3
	i = 0
	itr = 0
	while i < clauses		
		new_table = where_logic(table, tables, where, scheme, clearance, itr)
=begin
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
						puts "====================="
						print row[schema[where[i]]] + " " + where[i+1]
						print row[schema[where[i+2]]]
						puts row[schema[where[i]]].to_i.send( where[i+1] , row[schema[where[i+2]]].to_i )
						if row[schema[where[i]]].to_i.send( where[i+1] , row[schema[where[i+2]]].to_i )
							new_table.push(row)
						end
					elsif (!where[i].is_i?) && (where[i+2].is_i?)
						puts "====================="
						print row[schema[where[i]]] + where[i+1]
						print where[i+2]
						puts row[schema[where[i]]].to_i.send( where[i+1] , where[i+2].to_i )
						if row[schema[where[i]]].to_i.send( where[i+1] , where[i+2].to_i )
							new_table.push(row)
						end
					elsif (where[i].is_i?) && (!where[i+2].is_i?)
						puts "====================="
						print where[i] + where[i+1]
						print row[schema[where[i+2]]]
						puts where[i].to_i.send( where[i+1] , row[schema[where[i+2]]].to_i)
						if where[i].to_i.send( where[i+1] , row[schema[where[i+2]]].to_i)
							new_table.push(row)
						end
					end
				end
			end
		end
=end
	i += 1
	end
	new_table
end

def process_query(schema,tree,table,clearance)
	q_cleaned_str = tree.to_sql.downcase.gsub(/[^a-z0-9\s\*<>=]/i, '')
	q_arr =  q_cleaned_str.split(" ")
	# get the tables to be queried
	tables = convert_tables(get_tables(q_arr),schema)
	# get the columns to be selected
	cols = convert_cols(get_cols(q_arr),tables,schema)
	#get the where clause
	if tree.where != nil
		where_clause = tree.where.to_sql.downcase.gsub(/[^a-z0-9\s\*<>=]/i, '')
	end
	t = join(tables,table[0],table[1],table[2])
	t = filter_security(t,tables,clearance,schema)
	if where_clause != nil
		t = where(t,tables,where_clause,schema,clearance)
	end
	m = to_m(t)
	print_query(m,cols,tables)
	#printTable(t.transpose[0..-1])
end
