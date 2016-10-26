require 'dotenv'
require 'active_support'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/array/wrap.rb' 
require 'yaml'
require 'logger'
require 'service'

require 'dasbot/setup'
require 'dasbot/event'
require 'dasbot/version'
require 'dasbot/model'
require 'dasbot/input'
require 'dasbot/adapters'
require 'dasbot/periodic_job'
require 'dasbot/worker'
require 'dasbot/server'
require 'dasbot/create_input'
require 'dasbot/process_input'
require 'dasbot/handle_input_process_error'

module Dasbot
  def self.init!
    return false if @_initialized
    Dotenv.load('.env', ".env.#{environment}", '.env.local')
    # init_database
    boot_application
    load_adapters
    load_application
    @_initialized = true
  end

  def self.adapter?(adapter_name)
    adapters.include?(adapter_name.to_sym)
  end

  def self.table_name_prefix
    'dasbot_'
  end

  def self.root
    Dir.pwd
  end

  def self.setup(name, options = {})
    Dasbot::Setup.run!(name, options)
  end

  def self.environment
    ENV['DASBOT_ENV'] || 'development'
  end

  def self.logger
    return @_logger if @_logger
    log_dir_path = File.join(root, 'log')
    @_logger = if File.exist?(log_dir_path) && File.directory?(log_dir_path)
                 Logger.new(File.join(log_dir_path, "#{environment}.log"))
               else
                 Logger.new('/dev/null')
               end
  end

  def self.adapters
    @_adapters ||= []
  end

  def self.adapters=(*args)
    @_adapters = Array.wrap(*args).map(&:to_sym)
  end

  class << self
    private

    def boot_application
      boot_file_path = File.join(Dasbot.root, 'config', 'boot.rb')
      require boot_file_path if File.exist?(boot_file_path)
    end

    def load_adapters
      adapters.each do |adapter_name|
        require_relative("adapters/#{adapter_name}_adapter.rb")
        Dasbot::Adapters.get(adapter_name) # Ensure the adapter is loaded
      end
    end

    def load_application
      deep_load_directory File.join(root, 'app', 'models')
      deep_load_directory File.join(root, 'app', 'workflows'), /_workflow\.rb\Z/
    end

    def deep_load_directory(dir, pattern = /\.rb\Z/)
      Dir.glob(File.join(dir, '*')).sort.each do |entry|
        if File.directory?(entry)
          deep_load_directory entry, pattern
        elsif entry =~ pattern
          load entry
        end
      end
    end
  end
end
