require 'ostruct'

module Dasbot
  class Model < OpenStruct
    def self.set(id, attributes)
      index = records.find_index { |r| r.id == id }
      record = new(attributes.merge(id: id))
      if index
        records[index] = record
      else
        records << record
      end
      record
    end

    def self.create(attributes)
      id = (records.map(&:id).max || 0).next
      set id, attributes
    end

    def self.truncate!
      @_records = nil
    end
    
    def self.records
      @_records ||= []
    end
  end
end
