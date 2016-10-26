# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dasbot/version'

Gem::Specification.new do |spec|
  spec.name          = "dasbot"
  spec.version       = Dasbot::VERSION
  spec.authors       = ["Benoit Dinocourt"]
  spec.email         = ["ghrind@gmail.com"]

  spec.summary       = %q{The core engine for the DasBot application}
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"

  spec.add_dependency "rake", "~> 10.0"
  spec.add_dependency 'activesupport'
  # NOTE: This is used by the validations of Service::Base object, which aren't used as of now.
  spec.add_dependency 'activemodel'
  spec.add_dependency 'redis'
  spec.add_dependency 'pry'
  spec.add_dependency 'sinatra'
  spec.add_dependency 'dotenv'
  spec.add_dependency 'httparty'
end
