module Dasbot
  module Event

    def self.trigger(event_name, payload)
      listeners[event_name].each do |block|
        block.call(payload)
      end
    end

    def self.listeners
      @_listeners ||= Hash.new { |h, k| h[k] = [] }
    end

    def self.on(event_name, &block)
      listeners[event_name].push(Proc.new(&block))
    end

  end
end
