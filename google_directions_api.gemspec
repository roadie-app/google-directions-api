# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'google_directions_api/version'

Gem::Specification.new do |spec|
  spec.name          = "google_directions_api"
  spec.version       = GoogleDirectionsAPI::VERSION
  spec.authors       = ["Aubrey Rhodes"]
  spec.email         = ["aubrey.c.rhodes@gmail.com"]

  spec.summary       = %q{Ruby wrapper for the Google Directions API}
  spec.homepage      = "https://github.com/aubreyrhodes/google-directions-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2.0"
  spec.add_development_dependency "vcr", "~> 2.9.3"
  spec.add_development_dependency "webmock", "~> 1.20.4"
  spec.add_development_dependency "dotenv", "~> 2.0.1"
  spec.add_development_dependency "pry", "~> 0.10.1"

  spec.add_runtime_dependency "faraday"
end
