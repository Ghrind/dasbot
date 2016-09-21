module Adapters
  module GithubAdapter
    class ProcessInput < Service::Base
      def initialize(input)
        @input = input
      end

      private

      def event_name
        case github_event
        when 'status'
          'github.repository_status_update'
        when 'pull_request'
          "github.pull_request.#{pull_request_action}"
        else
          'github.unknown_event'
        end
      end

      def payload
        JSON.parse(@input.body)
      end

      def github_event
        @input.headers[GITHUB_EVENT_HEADER]
      end

      def execute
        Dasbot::Event.trigger event_name, payload
        @input.update_attribute :state, 'processed'
      end

      def pull_request_action
        payload['action']
      end
    end
  end
end
