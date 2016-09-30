module Dasbot
  class CreateInput < Service::Base
    def initialize(adapter, request, params)
      @adapter = adapter
      @request = request
      @params = params
    end

    private

    def execute
      Dasbot::Input.create! attributes
    end

    def body
      @request.body.rewind
      @request.body.read
    end

    def headers
      @request.env.slice(*Dasbot::Adapters.accepted_headers)
    end

    def attributes
      {
        adapter_name: @adapter.adapter_name.to_s,
        body: body,
        headers: headers,
        params: @params,
        state: 'pending',
        type: @adapter.input_class
      }
    end
  end
end
