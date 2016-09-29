require 'shellwords'
require 'fileutils'

module ApplicationExampleGroup

  attr_writer :env_vars

  def setup_application(options = {})
    Dasbot.setup(application_name, { path: application_path }.merge(options))
  end

  def setup_application!(options = {})
    teardown_application!
    setup_application(options)
  end

  def teardown_application!
    FileUtils.rm_rf application_path
  end

  def application_name
    metadata = self.class.metadata
    while metadata[:parent_example_group]
      metadata = metadata[:parent_example_group]
    end
    metadata[:description]
  end

  def application_path
    File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'tmp', application_name))
  end

  def env_vars
    @env_vars ||= []
  end

  def run(command)
    cmd = ["cd #{application_path}"]
    cmd << "#{env_vars.join(' ')} ./bin/runner #{Shellwords.escape('puts ' + command)}"
    `#{cmd.join(' && ')}`.chomp
  end
end

RSpec.configure do |config|
  config.include ApplicationExampleGroup, type: :application
end
