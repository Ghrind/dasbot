require 'ostruct'

module Dasbot
  class Model < OpenStruct
    attr_reader :_redis_key

    def initialize(*args)
      if args.first.is_a? String
        super JSON.parse(args.first)
        @_redis_key = args.first
      else
        super
      end
    end

    def self.set(id, attributes)
      record = records.detect { |r| r.id == id }
      Redis.current.srem(name, record._redis_key) if record

      attributes.merge!(id: id)
      Redis.current.sadd(name, attributes.to_json)

      new attributes
    end

    def self.create(attributes)
      id = (records.map(&:id).max || 0).next
      set id, attributes
    end

    def self.truncate!
      Redis.current.del(name)
    end

    def self.records
      (Redis.current.smembers(name) || []).map { |r| new r }
    end
  end
end
