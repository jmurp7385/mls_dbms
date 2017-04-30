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
	"t3"  : 2
}'

json = JSON.parse(db_scheme)

#enter queries until exit is typed
input = ''
stop = false
while (1)
  query = ""
  while (input = gets.chomp) != ";" || (!query.include? ?;)
    if input == "exit"
      abort("Exited")
    end
    query += input + " "
    if query.include? ?;
      query.tr_s!(';','')
      break
    end
  end
  query = query.gsub(/[ \n\t\r]/i, ' ')  
  #get clearance and remoive it from front of the query
  clearance = check_clearance(query)
  query = remove_clearance_at_front(query)

  tree = SQLTree[query.chomp]
  #process the query
  process_query(json,tree,table,clearance)
  input = ""
  clearance = 0
end
