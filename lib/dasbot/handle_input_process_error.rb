module Dasbot
  class HandleInputProcessError < Service::Base
    def initialize(input, error)
      @input = input
      @error = error
    end

    private

    def execute
      Dasbot::Input.set(@input.id, @input.to_h.merge(state: 'process_error'))
    end
  end
end
