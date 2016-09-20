module Dasbot
  class PeriodicJob
    DEFAULT_OPTIONS = {
      wait_after_success: 1,
      wait_after_failure: 10 # seconds
    }

    attr_accessor :running

    def initialize(options = {})
      @options = DEFAULT_OPTIONS.merge(options)
      @running = false
    end

    # pj = PeriodicJob.new
    #
    # Signal.trap('SIGINT') do
    #   puts 'signal captured...'
    #   pj.running = false
    # end
    #
    # pj.run
    def run
      @running = true
      while @running
        result = perform_once
        idle_time = result ? @options[:wait_after_success] : @options[:wait_after_failure]
        idle_time.times do
          break unless @running
          sleep 1
        end
      end
    end

    def perform_once
      fail NotImplementedError
    end
  end
end
