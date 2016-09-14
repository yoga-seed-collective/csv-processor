require 'csv'
require_relative 'file'

class Sheet

	def self.read(filename)
		Ramaze::Log.info("#{File.save_path}#{filename}")
				csv_rows = []
		CSV.foreach("#{File.save_path}#{filename}", headers: true) do |row|
				csv_rows << row.to_h
		end
		csv_rows
	end

end
