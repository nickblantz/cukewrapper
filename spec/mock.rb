# frozen_string_literal: true

module Cukewrapper
  require 'logger'

  CONFIG = { 'foo' => 'bar' }.freeze

  class << self
    def log
      @log ||= Logger.new($stdout)
      @log.level = Logger::ERROR
      @log
    end
  end
end
