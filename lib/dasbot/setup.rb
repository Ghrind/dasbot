require 'fileutils'

module Dasbot
  class Setup < Service::Base
    GEMFILE_OPTIONS = {
      dasbot_path: nil
    }.freeze

    def initialize(name, options = {})
      @name = name
      @root = File.expand_path(options[:path] || File.join(Dir.pwd, @name))
      @gemfile_options = GEMFILE_OPTIONS.merge(options[:gemfile] || {})
    end

    private

    def execute
      make_root_dir if root_missing?
      add_gemfile if gemfile_missing?
      bundle!
      add_runner
    end

    def root_missing?
      !File.exist?(@root)
    end

    def make_root_dir
      FileUtils.mkdir_p(@root)
    end

    def add_gemfile
      dasbot_path = if @gemfile_options[:dasbot_path]
                      ", path: '#{@gemfile_options[:dasbot_path]}'"
                    else
                      ''
                    end
      File.open(gemfile_path, 'w') do |file|
        file.puts "source 'https://rubygems.org'\n"
        file.puts "gem 'dasbot'#{dasbot_path}"
      end
    end

    def gemfile_missing?
      !File.exist?(gemfile_path)
    end

    def gemfile_path
      File.join(@root, 'Gemfile')
    end

    def bundle!
      Bundler.with_clean_env do
        `cd #{@root} && bundle`
      end
    end

    def add_runner
      runner_path = File.join(@root, 'bin', 'runner')
      FileUtils.mkdir(File.dirname(runner_path))
      File.open(runner_path, 'w') do |file|
        file << <<-EOF.gsub(/^\s+/, '')
          #!/usr/bin/env ruby

          require 'dasbot'

          Dasbot.init!
          eval(ARGV.first || '')
        EOF
      end
      `chmod +x #{runner_path}`
    end
  end
end
