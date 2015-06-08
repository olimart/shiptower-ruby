# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shiptower/version'

Gem::Specification.new do |spec|
  spec.name          = "shiptower"
  spec.version       = Shiptower::VERSION
  spec.authors       = ["Olivier"]
  spec.email         = ["olivier@yafoy.com"]
  spec.summary       = %q{Gem to communicate with Shiptower master application}
  spec.description   = "API wrapper for Shiptower service"
  spec.homepage      = "https://github.com/olimart/shiptower-ruby"
  spec.license       = "MIT"

  spec.files         = Dir['LICENSE.md', 'README.md', 'lib/**/*']
  spec.test_files    = Dir['test/**/*.rb']

  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", '~> 0'

  spec.add_dependency("json", '~> 1.8', '>= 1.8.1')

  spec.add_development_dependency "shoulda", "~> 3.4.0", '>= 3.4.0'
  spec.add_development_dependency "test-unit", "~> 3.0.0", '>= 3.0.0'
  spec.add_development_dependency "minitest", "~> 5.4.0", '>= 5.4.0'
end
