module Adapters
  class GithubAdapter
    DEFAULT_ENDPOINT = {
      path: '/github',
      verb: :post
    }

    def initialize(request, params)
      @request = request
      @params = params
    end

    def process!
      { request: @request, params: @params }
    end
  end
end
