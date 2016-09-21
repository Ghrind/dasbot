module Dasbot
  class ProcessInput < Service::Base
    def initialize(input)
      @input = input
    end

    private

    def execute
      @adapter = Adapters.get(@input.adapter_name)
      @adapter.processor.run!(@input)
      # @input.update_attribute :state, 'processed'
    end
  end
end
