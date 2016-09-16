module Dasbot
  module Console
    def self.start!
      Dasbot.init!
      require 'pry'
      pry
    end
  end
end
