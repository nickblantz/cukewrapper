# frozen_string_literal: true

# Wraps your gherkin!
module Cukewrapper
  require 'yaml'

  module Config
    CONFIG_FILE = 'cukewrapper.yml'
    LOG_FILE = 'cukewrapper.log'
    ENV_PREFIX = 'CW_'
    ENV_DELIM = '_'

    def self.load_config(config_file = CONFIG_FILE)
      config =
        if File.file?(config_file)
          YAML.load_file(config_file)
        else
          {}
        end

      ENV.filter { |k, _| k.start_with?(ENV_PREFIX) }
        .transform_keys(&:downcase)
        .transform_keys { |k| k.split(ENV_DELIM)[1..] }
        .each { |k, v| deep_update(config, *k, v) }

      config
    end

    def self.deep_update(hash, k_head, *k_tail, val)
      hash[k_head] =
        if k_tail.empty?
          val
        else
          deep_update(hash[k_head] ||= {}, *k_tail, val)
        end
      hash
    end
  end
end
