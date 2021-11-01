# frozen_string_literal: true

require_relative 'lib/cukewrapper/version'

Gem::Specification.new do |spec|
  spec.name = 'cukewrapper'
  spec.version = Cukewrapper::VERSION
  spec.authors = ['Nick Blantz']
  spec.email = ['nicholasblantz@gmail.com']
  spec.summary = 'Provides a wrapper for online testing tools with Cucumber'
  spec.description = File.read('README.md')
  spec.homepage = 'https://github.com/nickblantz'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')
  spec.files = [
    'lib/cukewrapper.rb',
    'lib/cukewrapper/config.rb',
    'lib/cukewrapper/executor.rb'
  ]
  spec.add_development_dependency 'rubocop', '~> 1.0'
  spec.add_runtime_dependency 'cucumber', '~> 7.0'
  spec.add_runtime_dependency 'faker', '~> 2.0'
  spec.add_runtime_dependency 'json', '~> 2.0'
  spec.add_runtime_dependency 'jsonpath', '~> 1.0'
end
