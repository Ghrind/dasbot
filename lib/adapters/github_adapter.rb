require_relative 'github_adapter/input'
require_relative 'github_adapter/process_input'

module GithubAdapter
  DEFAULT_ENDPOINT = {
    path: '/github',
    verb: :post
  }

  GITHUB_EVENT_HEADER = 'HTTP_X_GITHUB_EVENT'

  def self.adapter_name
    :github
  end

  def self.accepted_headers
    [GITHUB_EVENT_HEADER]
  end

  def self.processor
    GithubAdapter::ProcessInput
  end

  def self.endpoint(options = {})
    DEFAULT_ENDPOINT.merge(options || {})
  end

  def self.input_class
    GithubAdapter::Input
  end
end
