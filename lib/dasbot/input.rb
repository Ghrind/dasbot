module Dasbot
  class Input < Dasbot::Model
    def self.first_pending
      record = records.detect(&:pending)
      record ? record.dup : nil
    end
  end
end
