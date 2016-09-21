module Adapters
  def self.get(adapter_name)
    fail ArgumentError unless Dasbot.has_adapter?(adapter_name)
    "Adapters::#{adapter_name.to_s.camelize}Adapter".constantize
  end
end
