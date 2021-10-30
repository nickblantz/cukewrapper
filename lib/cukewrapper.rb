require 'cucumber'
require 'cukewrapper/config'
require 'cukewrapper/executor'

Before do |scenario|
  @config = Cukewrapper::Config.new scenario
end

Given(/^.*$/) do |*args|
  @config.step_data_handler *args
end

After do |scenario|
  @executor = Cukewrapper::Executor.new @config
  @executor.exec 
end

module Cukewrapper
  class Error < StandardError; end
end
