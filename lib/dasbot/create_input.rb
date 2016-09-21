module Dasbot
  class CreateInput < Service::Base
    def initialize(adapter, body, params)
      @adapter = adapter
      @body = body
      @params = params
    end

    private

    def execute
      Dasbot::Input.create! params: @params, body: @body, type: @adapter.input_class, state: 'pending'
    end
  end
end
