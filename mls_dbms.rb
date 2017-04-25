require_relative 'utility.rb'
require 'rubygems'
require 'awesome_print'
require 'sql-parser'
require 'sql_tree'
require 'json'

#TODO make cartesian product and make it to one tc column

#tables
t1 = t2 = t3 = []

table = []
t1 = readTable("T1.txt",4,201)
t2 = readTable("T2.txt",5,201)
t3 = readTable("T3.txt",6,201)
table.push(t1).push(t2).push(t3)

db_scheme = '{
	"t1"  : 0,
	"t2"  : 1,
	"t3"  : 2
}'

json = JSON.parse(db_scheme)

#enter queries until exit is typed
while (input = gets.chomp) != "exit" || (!input.include? "exit")
  query = ""
  while (input) != ";" || (!query.include? ?;)
    query += input
    if query.include? ?;
      query.tr_s!(';','')
      break
    end
  end
  #get clearance and remoive it from front of the query
  clearance = check_clearance(query)
  query = remove_clearance_at_front(query)

  tree = SQLTree[query.chomp]
  #process the query
  process_query(json,tree,table,clearance)
end
