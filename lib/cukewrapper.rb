# frozen_string_literal: true

require 'cucumber'
require 'cukewrapper/config'
require 'cukewrapper/executor'
require 'cukewrapper/util/hash_builder'
require 'logger'

logger = Logger.new($stdout)
logger.level = Logger::DEBUG

Before do |scenario|
  logger.debug('Cukewrapper::Hooks#before_scenario') { "Before '#{scenario.name}' initiated" }
  @config = Cukewrapper::Config.new scenario, logger
  logger.debug('Cukewrapper::Hooks#before_scenario') { "Before '#{scenario.name}' completed" }
end

Given(/^.*$/) do |*args|
  @config.step_data_handler(*args)
end

After do |scenario|
  logger.debug('Cukewrapper::Hooks#after_scenario') { "After '#{scenario.name}' initiated" }
  @executor = Cukewrapper::Executor.new @config, logger
  @executor.exec
  logger.debug('Cukewrapper::Hooks#after_scenario') { "After '#{scenario.name}' completed" }

  File.open("reports/#{@config.scenario_id}.json", 'w') do |file|
    file.write(JSON.pretty_generate(@executor))
  end
end

# Wraps your gherkin!
module Cukewrapper
  class Error < StandardError; end
end
