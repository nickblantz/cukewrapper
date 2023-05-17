# frozen_string_literal: true

require 'cukewrapper/plugin'
require 'cukewrapper/remapper'
require 'cukewrapper/executor'
require 'cukewrapper/validator'

module Cukewrapper
  # Managed plugins
  class PluginManager
    def initialize
      @plugins = load_plugins
      LOGGER.debug("#{self.class.name}##{__method__}") { @plugins.inspect }
    end

    def loaded?
      @plugins_loaded
    end

    def plugins
      raise 'Plugins not loaded' unless loaded?

      @plugins
    end

    def instantiate_plugins
      {
        remappers: instantiate_plugin(Remapper),
        executors: instantiate_plugin(Executor),
        validators: instantiate_plugin(Validator)
      }
    end

    private

    def instantiate_plugin(klass)
      klass.descendants.sort.map do |plugin|
        LOGGER.debug("#{self.class.name}##{__method__}") { plugin }
        plugin.new
      end
    end

    def load_plugins
      plugins = load_from_gemfile
      @plugins_loaded = true
      plugins
    end

    def load_from_gemfile
      return unless gemfile_exists?

      require 'bundler'

      Bundler.ui.level = :silent
      Bundler.setup

      Bundler.require(:cukewrapper_plugins).map(&to_plugin_name).compact
    end

    def gemfile_exists?
      bundle_gemfile = ENV.fetch('BUNDLE_GEMFILE', nil)
      File.file?('Gemfile') || (bundle_gemfile && File.file?(bundle_gemfile))
    end

    def to_plugin_name
      lambda do |gem|
        gem.name.sub(/cukewrapper[-_]/, '').freeze if gem.groups.include? :cukewrapper_plugins
      end
    end
  end
end
