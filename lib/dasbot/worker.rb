module Dasbot
  # Only one instance should be running at the same time
  class Worker < Dasbot::PeriodicJob
    def self.start!
      @instance = new
      @instance.run
    end

    def self.stop!
      return true unless @instance
      @instance.running = false
    end

    def logger
      @_logger ||= Logger.new(STDOUT)
    end

    def perform_once
      begin
        input = Input.first_pending
        return false unless input
        ProcessInput.run!(input)
        return true
      rescue => error
        logger.error "#{error.class}: #{error.message} --- #{error.backtrace.join('\n')}"
        HandleInputProcessError.run!(input, error)
      end
    end
  end
end
