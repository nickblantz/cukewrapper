# frozen_string_literal: true

require 'cukewrapper/config'
require 'cukewrapper/hooks'
require 'cukewrapper/plugin_manager'
require 'cukewrapper/metatags'

# Wraps your gherkin!
module Cukewrapper
  # Runs things around here
  module Runtime
    STEP_PATTERN = /^.*$/.freeze
    CONFIG = Cukewrapper::Config.new
    PLUGIN_MANAGER = Cukewrapper::PluginManager.new CONFIG

    def self.reset
      @context = {}
      @datatables = []
      @plugins = PLUGIN_MANAGER.instantiate_plugins
    end

    def self.before_scenario
      lambda do |scenario|
        Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { "Before '#{scenario.name}' initiated" }
        Cukewrapper::Runtime.before_scenario_internal(scenario)
        Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { "Before '#{scenario.name}' completed" }
      end
    end

    def self.before_scenario_internal(scenario)
      Cukewrapper::Runtime.reset
      Cukewrapper::Hooks.trigger(:before_scenario, @context, scenario)
      @metatags = Cukewrapper::Metatags.new scenario.tags
      Cukewrapper::Hooks.trigger(:after_metatags, @context, @metatags)
    end

    def self.step_handler
      lambda do |*args|
        Cukewrapper::Runtime.step_handler_internal(*args)
      end
    end

    def self.step_handler_internal(*args)
      return if args.empty?

      Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { 'Adding datatable' }
      @datatables << args[0].raw
    end

    def self.after_scenario
      lambda do |scenario|
        Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { "After '#{scenario.name}' initiated" }
        Cukewrapper::Runtime.after_scenario_internal(scenario)
        Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { "After '#{scenario.name}' completed" }
      end
    end

    def self.after_scenario_internal(scenario)
      Cukewrapper::Hooks.trigger(:after_datatables, @context, @datatables)
      @plugins[:remappers].each(&run_plugin)
      Cukewrapper::Hooks.trigger(:before_execution, @context)
      @plugins[:executors].each(&run_plugin)
      Cukewrapper::Hooks.trigger(:after_execution, @context)
      @plugins[:validators].each(&run_plugin)
      Cukewrapper::Hooks.trigger(:after_scenario, @context, scenario)
    end

    def self.run_plugin
      lambda do |plugin|
        Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { "Executing plugin: #{plugin}" }
        plugin.run(@context)
      end
    end
  end
end
