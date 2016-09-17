require 'sinatra'
require 'json'

module Dasbot
  class Application < Sinatra::Application
    get '/_version' do
      json({ application: self.class.name, dasbot: { version: Dasbot::VERSION } }, pretty: params.key?('pretty') && params['pretty'] != '0')
    end

    private

    def self.adapter(adapter_name, options = {})
      require_relative("../adapters/#{adapter_name}_adapter.rb")
      klass = "Adapters::#{adapter_name.to_s.camelize}Adapter".constantize
      endpoint_options = klass::DEFAULT_ENDPOINT.merge(options[:endpoint] || {})
      send(endpoint_options[:verb], endpoint_options[:path]) do
        #result = klass.new(request, params).process!
        request.body.rewind
        Dasbot::Input.create! params: params, body: request.body.read, adapter: adapter_name
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
