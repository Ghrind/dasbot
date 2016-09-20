require 'active_support'
require 'active_support/core_ext/string/inflections'
require 'yaml'
require 'logger'
require 'service'

# Database
require 'active_record'
require 'pg' # postgresql

require 'dasbot/version'
require 'dasbot/input'
require 'dasbot/periodic_job'
require 'dasbot/worker'
require 'dasbot/server'
require 'dasbot/create_input'
require 'dasbot/process_input'

module Dasbot
  def self.init!
    return false if @_initialized
    init_database
    load_application
    @_initialized = true
  end

  def self.table_name_prefix
    'dasbot_'
  end

  def self.root
    File.expand_path('.')
  end

  def self.environment
    ENV['DASBOT_ENV'] || 'development'
  end

  def self.logger
    Logger.new(File.join(root, 'log', "#{environment}.log"))
  end

  private

  def self.init_database
    configuration = YAML::load(IO.read(File.join(root, 'config', 'database.yml')))
    ActiveRecord::Base.establish_connection(configuration[environment])
    ActiveRecord::Base.logger = logger
  end

  def self.load_application
    deep_load_directory File.join(root, 'app', 'models')
    deep_load_directory File.join(root, 'app', 'workflows'), /_workflow\.rb\Z/
  end

  def self.deep_load_directory(dir, pattern = /\.rb\Z/)
    Dir.glob(File.join(dir, '*')).sort.each do |entry|
      if File.directory?(entry)
        deep_load_directory entry, pattern
      elsif entry =~ pattern
        load entry
      end
    end
  end
end
