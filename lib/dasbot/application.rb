require 'sinatra'
require 'json'

module Dasbot
  class Application < Sinatra::Application
    get '/_version' do
      json({ application: self.class.name, dasbot: { version: Dasbot::VERSION } }, pretty: params.key?('pretty') && params['pretty'] != '0')
    end

    private

    def self.adapter(adapter_name, options = {})
      adapter = Adapters.get(adapter_name)
      endpoint = adapter.endpoint(options[:endpoint])
      send(endpoint[:verb], endpoint[:path]) do
        request.body.rewind
        CreateInput.run!(adapter, request.body.read, params)
        status 200
      end
    end

    def json(object, pretty: false)
      content_type 'application/json'
      if pretty
        JSON.pretty_generate(object)
      else
        object.to_json
      end
    end
  end
end