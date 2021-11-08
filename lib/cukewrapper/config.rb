# frozen_string_literal: true

module Cukewrapper
  # Plugging in
  class Config
    require 'yaml'

    CONFIG_FILE = 'cukewrapper.yml'

    def initialize
      @internal = YAML.load_file(CONFIG_FILE) if File.file?(CONFIG_FILE)
      Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { 'Config has been loaded' }
    end

    def [](key)
      return nil unless @internal.key?(key)

      @internal[key]
    end

    def []=(_key, _value)
      raise 'Cukewapper::Config is immutible'
    end
  end

  CONFIG = Config.new
end
