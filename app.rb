# This file contains your application, it requires dependencies and necessary
# parts of the application.
require 'rubygems'
require 'ramaze'
require 'pry'

# Make sure that Ramaze knows where you are
Ramaze.options.roots = [__DIR__]
Ramaze.options.publics.push(__DIR__('public/csvs'))

require __DIR__('controller/init')
