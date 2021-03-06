# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/t3q/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-t3q"
  spec.version       = Ruboty::T3q::VERSION
  spec.authors       = ["tily"]
  spec.email         = ["tidnlyam@gmail.com"]
  spec.summary       = %q{ruboty handler for "twitter to tumblr quote"}
  spec.description   = %q{ruboty handler for "twitter to tumblr quote"}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "tumblr_client"
end
