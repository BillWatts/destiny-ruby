# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'destiny-ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "destiny-ruby"
  spec.version       = Destiny::VERSION
  spec.authors       = ["Bill Watts"]
  spec.email         = ["william.lane.watts@gmail.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = %q{TODO: A simple interface to Bungie.net's platform giving the ability to retrieve data related to the Destiny video game.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "multi_json", "~> 1.10"
  spec.add_runtime_dependency 'activesupport', '~> 4.2.0'
end
