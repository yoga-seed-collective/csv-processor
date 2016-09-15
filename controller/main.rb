require 'shellwords'
require_relative '../model/file'
require_relative '../model/sheet'

# Default url mappings are:
# 
# * a controller called Main is mapped on the root of the site: /
# * a controller called Something is mapped on: /something
# 
# If you want to override this, add a line like this inside the class:
#
#  map '/otherurl'
#
# this will force the controller to be mounted on: /otherurl.
class MainController < Controller

	helper :upload
	upload_options :allow_overwrite => true,
								 :autosave => true,
								 :default_upload_dir => File.upload_path,
								 :unlink_tempfile => true 

  # the index action is called automatically when no other action is specified
  def index
    @title = 'Welcome to CSV Processor!'
  end

	def show
    @title = 'Welcome to CSV Processor'
		get_uploaded_files.each_pair do |k, v|
			@filenames = Array.new
			@sheet = Sheet.read(v.filename)
			# "Item name" is "pricing option"
			@sheet.sort_by_date_and!('Item name')
			@filenames << @sheet.filename
			@sheet.save
			@sheet.sort_by!('Sale Date')
			@filenames << @sheet.filename
			@sheet.save
		end
	end

	def process
 	  @title = 'Welcome to CSV Processor'
		get_uploaded_files.each_pair do |k, v|
			@sheet = Sheet.read(v.filename)
		end
	end

  # the string returned at the end of the function is used as the html body
  # if there is no template for the action. if there is a template, the string
  # is silently ignored
  def notemplate
    @title = 'Welcome to Ramaze!'
    
    return 'There is no \'notemplate.xhtml\' associated with this action.'
  end
end
