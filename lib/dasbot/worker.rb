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

    def perform_once
      input = Input.pending.first
      return false unless input
      ProcessInput.run!(input)
      true
    end
  end
end
