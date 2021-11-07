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

Before do |scenario|
  Cukewrapper.log.debug('Cukewrapper::Hooks#before_scenario') { "Before '#{scenario.name}' initiated" }
  @runtime = Cukewrapper::Runtime.new
  @runtime.before_scenario(scenario)
  Cukewrapper.log.debug('Cukewrapper::Hooks#before_scenario') { "Before '#{scenario.name}' completed" }
end

Given(/^.*$/) do |*args|
  @runtime.step_data_handler(*args)
end

After do |scenario|
  Cukewrapper.log.debug('Cukewrapper::Hooks#after_scenario') { "After '#{scenario.name}' initiated" }
  @runtime.after_scenario(scenario)
  Cukewrapper.log.debug('Cukewrapper::Hooks#after_scenario') { "After '#{scenario.name}' completed" }

  # File.open("reports/#{scenario.id}.json", 'w') do |file|
  #   file.write(JSON.pretty_generate(nil))
  # end
end

# Wraps your gherkin!
module Cukewrapper
  class Error < StandardError; end

  class << self
    def log
      @log ||= Logger.new($stdout)
      @log.level = Logger::ERROR
      @log
    end
  end
end
