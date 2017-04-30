=begin
MIT License

Copyright (c) 2017 Joseph Gregory Murphy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
=end

require 'matrix'
require 'sql_tree'
require 'json'
require_relative 'logic.rb'

def readTable(file, rows, cols)
  table = []
  count = 0
  File.open(file).each do |line|
    tuple = []
    tuple = line.split(' ')
    table.push(tuple)
    count += 1
  end
  table
end

def print_table(table)
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

  def cartesian_product(tables_used,t1,t2,t3,schema)
    cartesian_product_logic(tables_used, t1, t2, t3, schema)
  end

  def to_m_fast(t)
    m = Matrix[]
    rows = Array[]
    t.each do |row|
      rows << row
    end
    m = Matrix.rows(rows)
    m
  end

  def print_matrix(m)    
    width = m.flatten.max.to_s.size+4
    puts m.map { |a| a.map { |i| i.to_s.rjust(width) }.join }
  end

  def print_query(schema, m, cols, tables)
    ans = []
    cols.each do |c|
      ans.push(m.column(c).to_a)
    end
    ans = check_kc(schema, tables, cols, ans)
    ans = merge_tc(schema, cols, ans)
    print_matrix(ans.transpose)
  end

  # checks if there is only a single table and replaces the *KC col with KC
  def check_kc(schema, tables, cols, m)
    if tables.size == 1
      if tables.include?(0) && cols.include?(schema['akc'])
        m[schema['akc']][0] = 'KC'     
      elsif tables.include?(1) && cols.include?(schema['bkc'])
        m[schema['bkc']][0] = 'KC'
      elsif tables.include?(2) && cols.include?(schema['ckc'])
        m[schema['ckc']][0] = 'KC'
      end
    end
    m
  end

  def convert_cols(cols,tables,schema)
    cols_new = []
    akc = 0
    bkc = 0
    ckc = 0
    if cols.include?('*')
      if tables.include?(0)
        cols_new.push(schema["a1"],schema["akc"],schema["a2"],schema["atc"])
      end
      if tables.include?(1)
        cols_new.push(schema["b1"],schema["bkc"],schema["b2"],schema["b3"],schema["btc"])
      end
      if tables.include?(2)
        cols_new.push(schema["c1"],schema["ckc"],schema["c2"],schema["c3"],schema["c4"],schema["ctc"])
      end
    else
      cols.each do |col|
        cols_new.push(schema[col])
        if cols_new.include?(schema["a1"]) && cols.include?("a1") && akc == 0
          cols_new.push(schema["akc"])
          akc = 1
        end
        if cols_new.include?(schema["b1"]) && cols.include?("b1") && bkc == 0
          cols_new.push(schema["bkc"])
          bkc = 1
        end
        if cols_new.include?(schema["c1"]) && cols.include?("c1") && ckc == 0 
          cols_new.push(schema["ckc"])
          ckc = 1
        end
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
    columns = []
    cols_new.each do |col|
      if col != nil
        columns.push(col)
      end
    end
    columns
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
    while count < 1#tables.size
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

  def where(table, tables, cols, where, schema, clearance)
    where = clean_where_clauses(where)
    clauses = where.size / 3
    i = count = 0
    while count < clauses
      table = where_logic(table, tables, where, schema, clearance, i, 0)
      count += 1
      i += 3
    end
    table
  end

  def security_single_table(table,tables,clearance,schema,itr)
    new_table = []
    if tables.include?(0) && !tables.include?(1) && !tables.include?(2)
      table.each do |row|
        if itr == 0
          new_table.push(row)
          itr = 1
        else
          if row[1] <= clearance && row[3] <= clearance
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
          if row[1] <= clearance && row[4] <= clearance
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
          if row[1] <= clearance && row[5] <= clearance
            new_table.push(row)
          end
        end
      end
    end
    new_table
  end

  def merge_tc(schema, cols, matrix)
    matrix = merge_tc_logic(schema, cols, matrix)
    matrix
  end

  def process_query(schema,tree,table,clearance)
    q_cleaned_str = tree.to_sql.downcase.gsub(/[^a-z0-9\s\*<>=]/i, '')
    q_arr =  q_cleaned_str.split(" ")
    # get the tables to be queried
    tables = convert_tables(get_tables(q_arr),schema)
    i = 0
    schema = find_schema(tables)
    while i < table.size do
        table[i] = security_single_table(table[i],[i],clearance,schema,0)
        #table[i] = filter_security(table[i],[i],clearance,schema)
        i += 1
      end
      # get the columns to be selected
      cols = convert_cols(get_cols(q_arr),tables,schema)
      # get the where clause
      if tree.where != nil
        where_clause = tree.where.to_sql.downcase.gsub(/[^a-z0-9\s\*<>=]/i, '')
      end
      # puts "prep to cartesian_product"
      t = cartesian_product(tables,table[0],table[1],table[2],schema)      
      # puts "cartesian -> security"
      #t = join(tables,table[0],table[1],table[2])
      t = filter_security(t,tables,clearance,schema)      
      # puts "security -> where"
      if where_clause != nil
        t = where(t,tables,cols,where_clause,schema,clearance)
      end      
      # puts "where -> m"      
      m = to_m_fast(t)  
          
      # puts "matrix -> ans"
      puts " "
      print_query(schema, m, cols, tables)
      puts " "
      print "Results: "
      puts m.row_count-1
    end
