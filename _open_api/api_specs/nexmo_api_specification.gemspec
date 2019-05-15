# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nexmo_api_specification/version'

Gem::Specification.new do |spec|
  spec.name          = 'nexmo_api_specification'
  spec.version       = NexmoApiSpecification::VERSION
  spec.authors       = ['Adam Butler']
  spec.email         = ['adam.butler@nexmo.com']

  spec.summary       = 'Provides Open API Spec 3 definitions for Nexmo APIs'
  spec.homepage      = 'https://github.com/nexmo/api-specification'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
