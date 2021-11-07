# frozen_string_literal: true

module Cukewrapper
  # Plugging in
  class Config
    require 'yaml'

    CONFIG_FILE = 'cukewrapper.yml' unless const_defined?(:CONFIG_FILE)

    # rubocop:disable Style/ClassVars
    @@config_loaded = false
    @@config = {}
    # rubocop:enable Style/ClassVars

    def initialize
      load
    end

    def [](key)
      return nil unless @@config.key?(key)

      @@config[key]
    end

    private

    def load
      if @@config_loaded
        Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { 'Config has already been loaded' }
        return
      end

      load_from_file

      # rubocop:disable Style/ClassVars
      @@config_loaded = true
      @@config_loaded.freeze
      @@config.freeze
      # rubocop:enable Style/ClassVars

      Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { 'Config has been loaded' }
    end

    def load_from_file
      # rubocop:disable Style/ClassVars
      @@config = YAML.load_file(CONFIG_FILE) if File.file?(CONFIG_FILE)
      # rubocop:enable Style/ClassVars
    end
  end
end
