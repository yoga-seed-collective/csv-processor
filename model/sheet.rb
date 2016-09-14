require 'builder'
require 'csv'
require_relative 'file'

class Sheet
	attr_accessor :hash

	def sort_by(key)
		
	end

	def keys
		self.hash.first.keys
	end

	def html
		Sheet.hasharray_to_html(self.hash)
	end

	def self.read(filename)
		Ramaze::Log.info("#{File.save_path}#{filename}")
				csv_rows = []
		CSV.foreach("#{File.save_path}#{filename}", headers: true) do |row|
				csv_rows << row.to_h
		end
		sheet = Sheet.new
		sheet.hash = csv_rows
		sheet
	end

	def self.hasharray_to_html( hashArray )
 	 # collect all hash keys, even if they don't appear in each hash:
 	 headers = hashArray.inject([]){|a,x| a |= x.keys ; a}  # use array union to find all unique headers/keys                              

 	 html = Builder::XmlMarkup.new(:indent => 2)
 	 html.table {
 	   html.tr { headers.each{|h| html.th(h)} }
 	   hashArray.each do |row|
 	     html.tr { row.values.each { |value| html.td(value) }}
 	   end
 	 }
 	 return html
	end

	def self.hasharray_to_csv(hashArray)
		column_names = hashArray.first.keys
			output=CSV.generate do |csv|
			csv << column_names
			hashes.each do |x|
				csv << x.values
			end
		end
	 output	
	end

end

