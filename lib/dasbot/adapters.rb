module Dasbot
  module Adapters
    def self.get(adapter_name)
      fail ArgumentError unless Dasbot.adapter?(adapter_name)
      "#{adapter_name.to_s.camelize}Adapter".constantize
    end

    def self.accepted_headers
      @_accepted_headers ||= []
    end

    def self.accepted_headers=(*args)
      @_accepted_headers = Array.wrap(*args).map(&:to_s)
    end
  end
end
