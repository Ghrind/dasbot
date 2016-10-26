module Dasbot
  class ProcessInput < Service::Base
    def initialize(input)
      @input = input
    end

    private

    def execute
      @adapter = Dasbot::Adapters.get(@input.adapter_name)
      @adapter.processor.run!(@input)
    end
  end
end
