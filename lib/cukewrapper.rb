# frozen_string_literal: true

require 'cucumber'
require 'cukewrapper/config'
require 'cukewrapper/executor'
require 'cukewrapper/hooks'
require 'cukewrapper/runtime'
require 'cukewrapper/plugin'
require 'cukewrapper/plugin_manager'
require 'cukewrapper/remapper'
require 'cukewrapper/validator'

require 'logger'

# Wraps your gherkin!
module Cukewrapper
  class Error < StandardError; end

  class << self
    def log
      @log ||= Logger.new($stdout)
      @log.level = Logger::DEBUG
      @log
    end
  end
end

Cukewrapper::Runtime.setup

Before do |scenario|
  Cukewrapper.log.debug('Cukewrapper::Hooks#before_scenario') { "Before '#{scenario.name}' initiated" }
  Cukewrapper::Runtime.reset
  Cukewrapper::Runtime.before_scenario(scenario)
  Cukewrapper.log.debug('Cukewrapper::Hooks#before_scenario') { "Before '#{scenario.name}' completed" }
end

Given(/^.*$/) do |*args|
  Cukewrapper::Runtime.step_data_handler(*args)
end

After do |scenario|
  Cukewrapper.log.debug('Cukewrapper::Hooks#after_scenario') { "After '#{scenario.name}' initiated" }
  Cukewrapper::Runtime.after_scenario(scenario)
  Cukewrapper.log.debug('Cukewrapper::Hooks#after_scenario') { "After '#{scenario.name}' completed" }
end
