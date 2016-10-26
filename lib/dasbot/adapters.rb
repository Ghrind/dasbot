module Dasbot
  module Adapters
    def self.get(adapter_name)
      fail ArgumentError unless Dasbot.adapter?(adapter_name)
      "#{adapter_name.to_s.camelize}Adapter".constantize
    end
  end
end
