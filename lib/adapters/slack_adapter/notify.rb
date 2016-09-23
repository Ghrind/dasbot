require 'httparty'

module SlackAdapter
  class Notify < Service::Base
    def initialize(text, options = {})
      @text = text
      @options = options
    end

    private

    HEADERS = {
      'Content-Type' => 'application/json'
    }.freeze

    def execute
      HTTParty.send(
        :post,
        ENV["SLACK_WEBHOOK_URL"],
        headers: HEADERS,
        body: payload.to_json
      )
    end

    def payload
      @options.merge(text: @text.to_s)
    end
  end
end
