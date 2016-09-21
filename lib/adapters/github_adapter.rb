require_relative 'github_adapter/input'

module Adapters
  module GithubAdapter
    DEFAULT_ENDPOINT = {
      path: '/github',
      verb: :post
    }

    def self.endpoint(options = {})
      DEFAULT_ENDPOINT.merge(options || {})
    end

    def self.input_class
      Adapters::GithubAdapter::Input
    end

   #def initialize(request, params)
   #  @request = request
   #  @params = params
   #end

   #def process!
   #  { request: @request, params: @params }
   #end
  end
end
