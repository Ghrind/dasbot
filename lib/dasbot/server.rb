require_relative 'application'

module Dasbot
  module Server
    def self.start!
      Dasbot.init!
      application_path = File.join(Dasbot.root, 'application.rb')
      if File.exist?(application_path)
        require application_path
        ::Application.run!
      else
        Dasbot::Application.run!
      end
    end
  end
end
