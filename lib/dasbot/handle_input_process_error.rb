module Dasbot
  class HandleInputProcessError < Service::Base
    def initialize(input, error)
      @input = input
      @error = error
    end

    private

    def execute
      @input.update_attribute :state, 'process_error'
    end
  end
end
