require 'shellwords'
require 'fileutils'

module ApplicationExampleGroup

  attr_writer :env_vars

  def setup_application(options = {})
    options = {
      path: application_path,
      gemfile: {
        dasbot_path: '../..'
      }
    }
    Dasbot.setup(application_name, { }.merge(options))
  end

  def setup_application!(options = {})
    teardown_application!
    setup_application(options)
  end

  def teardown_application!
    FileUtils.rm_rf application_path
  end

  def application_file_content(path)
    File.read(File.join(application_path, path))
  end

  def add_application_file(path, content)
    full_path = File.join(application_path, path)
    FileUtils.mkdir_p(File.dirname(full_path))
    File.open(full_path, 'w') { |f| f << content }
  end

  def remove_application_file(path)
    FileUtils.rm_rf(File.join(application_path, path))
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
    cmd << "#{env_vars.join(' ')} bundle exec ./bin/runner #{Shellwords.escape(command)}"
    Bundler.with_clean_env do
      `#{cmd.join(' && ')}`.chomp
    end
  end
end

RSpec.configure do |config|
  config.include ApplicationExampleGroup, type: :application
end
