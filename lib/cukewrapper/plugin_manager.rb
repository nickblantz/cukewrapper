# frozen_string_literal: true

require 'cukewrapper/plugin'
require 'cukewrapper/remapper'
require 'cukewrapper/executor'
require 'cukewrapper/validator'

module Cukewrapper
  # Managed plugins
  class PluginManager
    # rubocop:disable Style/ClassVars
    @@plugins_loaded = false
    @@plugins = []
    # rubocop:enable Style/ClassVars

    def initialize(config = nil)
      @config = config

      load
    end

    def loaded?
      @@plugins_loaded
    end

    def plugins
      raise 'Plugins not loaded' unless loaded?

      @@plugins
    end

    def instantiate_plugins
      {
        remappers: instantiate_plugin(Cukewrapper::Remapper),
        executors: instantiate_plugin(Cukewrapper::Executor),
        validators: instantiate_plugin(Cukewrapper::Validator)
      }
    end

    private

    def instantiate_plugin(klass)
      klass.descendants.sort.map do |plugin|
        Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { "Instantiate Plugin: #{plugin}" }
        plugin.new(@config)
      end
    end

    def load
      if @@plugins_loaded
        Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { 'Plugins have already been loaded' }
        return
      end

      load_from_gemfile

      # rubocop:disable Style/ClassVars
      @@plugins_loaded = true
      @@plugins_loaded.freeze
      @@plugins.freeze
      # rubocop:enable Style/ClassVars

      Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { "Loaded plugins: #{@@plugins.join(', ')}" }
    end

    def load_from_gemfile
      return unless gemfile_exists?

      require 'bundler'

      Bundler.ui.level = :silent
      Bundler.setup

      # rubocop:disable Style/ClassVars
      @@plugins += Bundler.require(:cukewrapper_plugins).map(&to_plugin_name).compact
      # rubocop:enable Style/ClassVars
    end

    def gemfile_exists?
      File.file?('Gemfile') || (ENV['BUNDLE_GEMFILE'] && File.file?(ENV['BUNDLE_GEMFILE']))
    end

    def to_plugin_name
      lambda do |gem|
        gem.name.sub(/cukewrapper[-_]/, '').freeze if gem.groups.include? :cukewrapper_plugins
      end
    end
  end
end
