require 'matrix'
require 'sql-parser'
require 'sql_tree'

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
	while i < 10  do
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

class String
	def is_i?
        	/\A[-+]?\d+\z/ === self
	end
end

def where(table, where, schema)
	where = where.split(' ')
	clauses = where.size / 3
	puts clauses
	i = 0
	puts where[0]
	puts where[2]
	puts where[0].is_i?
	puts where[2].is_i?
	puts where[0].send(where[1],where[2])
	while i =< clauses		
	table.each do |row|
		if (where[i].is_i?) && (where[i+2].is_i?)
			if row[schema[where[i]]].send( where[i+1] , row[schema[where[i+2]]] )
				new_table.push(row)
			end
		end
		if (!where[i].is_i?) && (where[i+2].is_i?)
			if row[schema[where[i]]].send( where[i+1] , row[where[i+2]] )
				new_table.push(row)
			end
		end
		if (where[i].is_i?) && (!where[i+2].is_i?)
			if row[where[i]].send( where[i+1] , row[schema[where[i+2]]] )
				new_table.push(row)
			end
		end
	end
	end
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
	if where_clause != nil
		puts where_clause
		where(t,where_clause,schema)
	end
	m = to_m(t)
	print_query(m,cols,tables)
	#printTable(t.transpose[0..-1])
end
