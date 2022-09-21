# frozen_string_literal: true

# Wraps your gherkin!
module Cukewrapper
  # Storing cold and refreshing beverages
  module LagerRegistry
    require 'logger'

    @loggers = {}

    def self.set_logger(key = nil, *args)
      key ||= :global
      @loggers[key] = Logger.new(Cukewrapper::LOG_FILE, *args)
      @loggers[key].level = Cukewrapper::CONFIG.dig('logger', key.to_s, 'level') || :info
      @loggers[key]
    end

    def self.get_logger(key = nil)
      key ||= :global
      @loggers[key]
    end
  end

  LOGGER = LagerRegistry.set_logger
end
