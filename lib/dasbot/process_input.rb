module Dasbot
  class ProcessInput < Service::Base
    def initialize(input)
      @input = input
    end

    private

    def execute
      @input.update_attribute :state, 'processed'
    end
  end
end
