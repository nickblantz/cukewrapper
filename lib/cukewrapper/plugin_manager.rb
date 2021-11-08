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
      Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { "Loaded with: #{@plugins.join(', ')}" }
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
        Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { "Instantiate Plugin: #{plugin}" }
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
      File.file?('Gemfile') || (ENV['BUNDLE_GEMFILE'] && File.file?(ENV['BUNDLE_GEMFILE']))
    end

    def to_plugin_name
      lambda do |gem|
        gem.name.sub(/cukewrapper[-_]/, '').freeze if gem.groups.include? :cukewrapper_plugins
      end
    end
  end
end
