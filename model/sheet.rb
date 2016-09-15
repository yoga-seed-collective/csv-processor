require 'builder'
require 'csv'
require_relative 'file'

class Sheet
	attr_accessor :hasharray
	attr_accessor :orig_filename
	attr_accessor :filename

	def sort_by(key)
		self.hasharray.sort_by{ |row| row[key] }
	end

	def daily_totals
		
	end

	def sort_by!(key)
		self.hasharray = self.sort_by(key)
		self.filename = "#{self.orig_filename.chomp(".csv")}_by_#{key}.csv"
	end

	def sort_by_date_and(key)
		self.hasharray.sort{ |a, b| [DateTime.strptime(a["Sale Date"], '%m/%d/%Y'), b[key]] <=> [DateTime.strptime(b["Sale Date"], '%m/%d/%Y'), a[key]] }
#		self.hasharray = self.sort_by(key)
#		array = self.hasharray.sort_by{ |row| row["Sale Date"] }
	end

	def sort_by_date_and!(key)
		self.hasharray = self.sort_by_date_and(key)
		self.filename = "#{self.orig_filename.chomp(".csv")}_bydateand_#{key}.csv"
	end

	def keys
		self.hasharray.first.keys
	end

	def html
		Sheet.hasharrayarray_to_html(self.hasharray)
	end

	def csv
		csv = String.new
		csv << self.keys.to_csv
		self.hasharray.each do |hasharray|
			csv << hasharray.values.to_csv
		end
		csv
	end

	def self.read(filename)
		csv_rows = []
		CSV.foreach("#{File.upload_path}#{filename}", headers: true) do |row|
				csv_rows << row.to_h
		end
		sheet = Sheet.new
		sheet.hasharray = csv_rows
		sheet.orig_filename = filename;
		sheet.filename = filename;
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

	def save
		File.open("#{File.save_path}#{self.filename}", 'w') { |file| file.write(self.csv) }
	end

end

