# frozen_string_literal: true

# Wraps your gherkin!
module Cukewrapper
  require 'cukewrapper/config'
  require 'cukewrapper/plugin'
  require 'cukewrapper/plugin_manager'
  require 'cukewrapper/metatags'

  # Runs things around here
  module Runtime
    def self.setup
      @config = Cukewrapper::Config.new
      @plugin_manager = Cukewrapper::PluginManager.new @config
    end

    def self.reset
      @context = {}
      @datatables = []
      @plugins = @plugin_manager.instantiate_plugins
    end

    def self.before_scenario(scenario)
      Cukewrapper::Hooks.trigger(:before_scenario, @context, scenario)
      @metatags = Cukewrapper::Metatags.new scenario.tags
      Cukewrapper::Hooks.trigger(:after_metatags, @context, @metatags)
    end

    def self.step_data_handler(*args)
      return if args.empty?

      Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { 'Adding datatable' }
      @datatables << args[0].raw
    end

    def self.after_scenario(scenario)
      Cukewrapper::Hooks.trigger(:after_datatables, @context, @datatables)
      @plugins[:remappers].each(&run_plugin)
      run
      Cukewrapper::Hooks.trigger(:after_scenario, @context, scenario)
    end

    def self.run
      Cukewrapper::Hooks.trigger(:before_execution, @metatags)
      @plugins[:executors].each(&run_plugin)
      Cukewrapper::Hooks.trigger(:after_execution, @metatags)
      @plugins[:validators].each(&run_plugin)
    end

    def self.run_plugin
      lambda do |plugin|
        Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { "Executing plugin: #{plugin}" }
        plugin.run(@context)
      end
    end
  end
end
