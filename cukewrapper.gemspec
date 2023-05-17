# frozen_string_literal: true

require_relative 'lib/cukewrapper/version'

Gem::Specification.new do |spec|
  spec.name = 'cukewrapper'
  spec.version = Cukewrapper::VERSION
  spec.authors = ['Nick Blantz']
  spec.email = ['nicholasblantz@gmail.com']
  spec.summary = 'Provides a wrapper for online testing tools with Cucumber'
  spec.metadata = { 'rubygems_mfa_required' => 'true' }
  spec.description = File.read('README.md')
  spec.homepage = 'https://github.com/nickblantz'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')
  spec.files = Dir[
    'lib/**/*',
    'README.md',
    'LICENSE'
  ]
  spec.add_runtime_dependency 'cucumber', '~> 7.0'
end
