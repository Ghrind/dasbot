require 'rspec'
require 'pry'

spec_root = File.expand_path(File.dirname(__FILE__))

# Load all the content of the support folder and subfolders
Dir.glob(File.join(spec_root, 'support', '**', '*.rb')).sort.each do |p|
  require p
end

# Test coverage
require 'simplecov'
SimpleCov.start

# This must be required after SimpleCov.start
require 'dasbot'
