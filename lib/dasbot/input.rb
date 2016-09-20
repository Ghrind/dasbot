module Dasbot
  class Input < ActiveRecord::Base
    scope :pending, -> { where(state: 'pending') }
  end
end
