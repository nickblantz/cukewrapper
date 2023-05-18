# frozen_string_literal: true

module Cukewrapper
  # Runs things around here
  module Runtime
    require 'cukewrapper/hooks'
    require 'cukewrapper/plugin_manager'
    require 'cukewrapper/metatags'

    STEP_PATTERN = /^\W*>\W*.*$/.freeze
    CONFIG = Config.load_config
    LOGGER = LagerRegistry.set_logger
    PLUGIN_MANAGER = PluginManager.new

    def self.reset
      @context = {}
      @datatables = []
      @plugins = PLUGIN_MANAGER.instantiate_plugins
    end

    def self.before_scenario
      lambda do |scenario|
        Runtime.before_scenario_internal(scenario)
      end
    end

    def self.before_scenario_internal(scenario)
      Runtime.reset
      Hooks.trigger(:before_scenario, @context, scenario)
      @metatags = Metatags.build scenario.tags
      Hooks.trigger(:after_metatags, @context, @metatags)
    end

    def self.step_handler
      lambda do |*args|
        Runtime.step_handler_internal(*args)
      end
    end

    def self.step_handler_internal(*args)
      return if args.empty?

      LOGGER.debug("Cukewrapper::Runtime##{__method__}") { 'Adding datatable' }
      @datatables << args[0].raw
    end

    def self.after_scenario
      lambda do |scenario|
        Runtime.after_scenario_internal(scenario)
      end
    end

    def self.after_scenario_internal(scenario)
      Hooks.trigger(:after_datatables, @context, @datatables)
      @plugins[:remappers].each(&run_plugin)
      Hooks.trigger(:before_execution, @context)
      @plugins[:executors].each(&run_plugin)
      Hooks.trigger(:after_execution, @context)
      @plugins[:validators].each(&run_plugin)
      Hooks.trigger(:after_scenario, @context, scenario)
    end

    def self.run_plugin
      lambda do |plugin|
        LOGGER.debug("Cukewrapper::Runtime##{__method__}") { plugin.class.name }
        plugin.run(@context)
      end
    end
  end
end
