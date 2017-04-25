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
      if (where[i] == "tc") || (where[i] == "atc") || (where[i] == "btc") || (where[i] == "ctc")
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
        elsif !tables.include?(0) && !tables.include?(1) && tables.include?(2)
          if row[schema["ctc"]].to_i.send(where[i+1],where[i+2].to_i) && row[schema["ckc"]].to_i.send("<=",where[i+2].to_i)
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
          if row[schema[where[i]]].to_i.send( where[i+1] , row[schema[where[i+2]]].to_i )
            new_table.push(row)
          end
        end
      end
    end
  end
  new_table
end

def cartesian_product_logic(tables,t1,t2,t3,schema)
  i = 1
  j = 1
  k = 1
  new_table = []
  new_row = []
  if tables.size == 1
    if tables.include?(0)
      new_table = t1
    end
    if tables.include?(1)
      new_table = t2
    end
    if tables.include?(2)
      new_table = t3
    end
  elsif tables.size == 2
    if tables[0] == 0 && tables[1] == 1
      new_table.push(new_row.push(t1[0]).push(t2[0]).flatten!)
      while i < t1.size
        while j < t2.size
          new_row = []
          if t1[i][1] == t2[j][1]
            new_row.push(t1[i]).push(t2[j]).flatten!
            new_table.push(new_row)
          end
          j += 1
        end
        j = 1
        i += 1
      end
    elsif tables[0] == 1 && tables[1] == 2
      new_table.push(new_row.push(t2[0]).push(t3[0]).flatten!)
      while i < t2.size
        while j < t3.size
          new_row = []
          if t2[i][1] == t3[j][1]
            new_row.push(t2[j]).push(t3[k]).flatten!
            new_table.push(new_row)
          end
          j += 1
        end
        j = 1
        i += 1
      end
    elsif tables[0] == 0 && tables[1] == 2
      new_table.push(new_row.push(t1[0]).push(t3[0]).flatten!)
      while i < t1.size
        while j < t3.size
          if t1[i][1] == t3[j][1]
            new_row.push(t1[i]).push(t3[k]).flatten!
            new_table.push(new_row)
          end
          j += 1
        end
        j = 1
        i += 1
      end
    end
  elsif tables.size == 3
    t2_t3 = []
    new_table.push(new_row.push(t1[0]).push(t2[0]).push(t3[0]).flatten!)
    while i < t2.size
      while j < t3.size
        new_row = []
        if t2[i][1] == t3[j][1]
          new_row.push(t2[i]).push(t3[j]).flatten!
          t2_t3.push(new_row)
        end
        j += 1
      end
      j = 1
      i += 1
    end
    i = 1
    j = 0
    while i < t1.size
      while j < t2_t3.size
        new_row = []
        if t1[i][1] == t2_t3[j][1]
          new_row.push(t1[i]).push(t2_t3[j]).flatten!
          new_table.push(new_row)
        end
        j += 1
      end
      j = 1
      i += 1
    end

  end
  #print_matrix(new_table)
  new_table
end

def clean_where_clauses(where)
  loop do
    where.slice! "and"
    break if !where.include?("and")
  end
  where = where.split(' ')
  if where.include?("=")
    loop do
      where[where.index("=")].replace("==")
      break if !where.include?("=")
    end
  end
  where
end

def merge_tc_logic(schema, cols, table)
  ans = []
  tc_combo = []
  tc = []
  tcs = []
  i = 1
  count = 0
  table.each do |row|
    if row.include?('ATC') || row.include?('BTC') || row.include?('CTC')
      if row.include?('ATC')
        tcs.push('ATC')
      elsif row.include?('BTC')
        tcs.push('ATC')
      elsif row.include?('CTC')
        tcs.push('ATC')
      end
      count += 1
      tc_combo.push(row)
    else
      ans.push(row)
    end
  end
  tc.push('TC')
  while i < tc_combo[0].size
    if count == 1
      tc.push(tc_combo[0][i])
    elsif count == 2
      if tc_combo[0][i] >= tc_combo[1][i]
        tc.push(tc_combo[0][i])
      else
        tc.push(tc_combo[1][i])
      end
    elsif count == 3
      if tc_combo[0][i] >= tc_combo[1][i]  && tc_combo[0][i] >= tc_combo[2][i]
        tc.push(tc_combo[0][i])
      elsif tc_combo[1][i] >= tc_combo[0][i] && tc_combo[1][i] >= tc_combo[2][i]
        tc.push(tc_combo[1][i])
      elsif tc_combo[2][i] >= tc_combo[1][i] && tc_combo[2][i] >= tc_combo[0][i]
        tc.push(tc_combo[2][i])
      end
    end
    i += 1
  end
  ans.push(tc)
  ans
end

def find_schema(tables)
  t1_scheme = '{
	"t1"  : 0,
	"t2"  : 1,
	"t3"  : 2,

	"a1"  : 0,
	"akc" : 1,
	"a2"  : 2,
	"atc" : 3
}'

  t2_scheme = '{
	"t1"  : 0,
	"t2"  : 1,
	"t3"  : 2,

	"b1"  : 0,
	"bkc" : 1,
	"b2"  : 2,
	"b3"  : 3,
	"btc" : 4
}'

  t3_scheme = '{
	"t1"  : 0,
	"t2"  : 1,
	"t3"  : 2,
	
	"c1"  : 0,
	"ckc" : 1,
	"c2"  : 2,
	"c3"  : 3,
	"c4"  : 4,
	"ctc" : 5
}'

  t1_t2_scheme = '{
	"t1"  : 0,
	"t2"  : 1,
	"t3"  : 2,

	"a1"  : 0,
	"akc" : 1,
	"a2"  : 2,
	"atc" : 3,

	"b1"  : 4,
	"bkc" : 5,
	"b2"  : 6,
	"b3"  : 7,
	"btc" : 8
}'

  t2_t3_scheme = '{
	"t1"  : 0,
	"t2"  : 1,
	"t3"  : 2,

	"b1"  : 0,
	"bkc" : 1,
	"b2"  : 2,
	"b3"  : 3,
	"btc" : 4,

	"c1"  : 5,
	"ckc" : 6,
	"c2"  : 7,
	"c3"  : 8,
	"c4"  : 9,
	"ctc" : 10
}'

  t1_t3_scheme = '{
	"t1"  : 0,
	"t2"  : 1,
	"t3"  : 2,

	"a1"  : 0,
	"akc" : 1,
	"a2"  : 2,
	"atc" : 3,

	"c1"  : 4,
	"ckc" : 5,
	"c2"  : 6,
	"c3"  : 7,
	"c4"  : 8,
	"ctc" : 9
}'

  t1_t2_t3_scheme = '{
	"t1"  : 0,
	"t2"  : 1,
	"t3"  : 2,

	"a1"  : 0,
	"akc" : 1,
	"a2"  : 2,
	"atc" : 3,

	"b1"  : 4,
	"bkc" : 5,
	"b2"  : 6,
	"b3"  : 7,
	"btc" : 8,

	"c1"  : 9,
	"ckc" : 10,
	"c2"  : 11,
	"c3"  : 12,
	"c4"  : 13,
	"ctc" : 14
}'

  t1_schema = JSON.parse(t1_scheme)
  t2_schema = JSON.parse(t2_scheme)
  t3_schema = JSON.parse(t3_scheme)
  t1_t2_schema = JSON.parse(t1_t2_scheme)
  t2_t3_schema = JSON.parse(t2_t3_scheme)
  t1_t3_schema = JSON.parse(t1_t3_scheme)
  t1_t2_t3_schema = JSON.parse(t1_t2_t3_scheme)
  schemas = []
  schemas.push(t1_schema).push(t2_schema).push(t3_schema).push(t1_t2_schema).push(t2_t3_schema).push(t1_t3_schema).push(t1_t2_t3_schema)

  if tables.size == 1
    if tables[0] == 0
      db_schema = schemas[0]
    end
    if tables[0] == 1
      db_schema = schemas[1]
    end
    if tables[0] == 2
      db_schema = schemas[2]
    end
  elsif tables.size == 2
    if tables.include?(0) && tables.include?(1)
      db_schema = JSON.parse(t1_t2_scheme)
    end
    if tables.include?(1) && tables.include?(2)
      db_schema = JSON.parse(t2_t3_scheme)
    end
    if tables.include?(0) && tables.include?(2)
      db_schema = schemas[5]
    end
  elsif tables.size == 3
    db_schema = JSON.parse(t1_t2_t3_scheme)
  end
  db_schema
end
