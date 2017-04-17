require_relative 'utility.rb'
require 'rubygems'
require 'awesome_print'
require 'sql-parser'
require 'sql_tree'
require 'json'

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
	"t3"  : 2,

	"a1"  : 0,
	"a2"  : 1,
	"akc" : 2,
	"atc" : 3,

	"b1"  : 4,
	"b2"  : 5,
	"b3"  : 6,
	"bkc" : 7,
	"btc" : 8,

	"c1"  : 9,
	"c2"  : 10,
	"c3"  : 11,
	"c4"  : 12,
	"ckc" : 13,
	"ctc" : 14
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
