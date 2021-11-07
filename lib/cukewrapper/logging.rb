# frozen_string_literal: true

# Wraps your gherkin!
module Cukewrapper
  require 'logger'

  class << self
    def log
      @log ||= Logger.new($stdout)
      @log.level = Logger::DEBUG
      @log
    end
  end
end
