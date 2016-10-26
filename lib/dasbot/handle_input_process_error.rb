module Dasbot
  class HandleInputProcessError < Service::Base
    def initialize(input, error)
      @input = input
      @error = error
    end

    private

    def execute
      Input.set(@input.id, @input.to_h.merge(state: 'process_error'))
      @input.update_attribute :state, 'process_error'
    end
  end
end
