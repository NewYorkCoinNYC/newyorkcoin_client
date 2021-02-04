# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'newyorkcoin_client/version'

Gem::Specification.new do |spec|
  spec.name          = "newyorkcoin_client"
  spec.version       = NewYorkcoinClient::VERSION
  spec.authors       = ["CryptoLover705"]
  spec.email         = ["support@cryptoloverbots.com"]
  spec.description   = %q{A NewYorkcoin client for ruby. This gem is a ruby wrapper for making remote procedure calls (rpc) to a newyorkcoin daemon (newyorkcoind.)}
  spec.summary       = %q{NewYorkcoinClient is a gem that makes it easy to work with newyorkcoin in ruby.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.6"
end
