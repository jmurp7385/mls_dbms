class A1 < ApplicationRecord
	self.table_name = 'a_ones'
	def parse(data)
		self.A1	= data['A1']
		self.A2 = data['A2']
		self.KC = data['KC']
		self.TC = data['TC']
	end

end

