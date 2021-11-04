# frozen_string_literal: true

require 'cukewrapper/util/remapper'

# Wraps your gherkin!
module Cukewrapper
  require 'faker'
  require 'json'
  require 'jsonpath'

  # Executes the test and sets the result
  class Executor
    def initialize(config, logger)
      @logger = logger
      @config = config
      @data = remap(load_data)
      @logger.debug("#{self.class.name}\##{__method__}") { 'Executor initialized' }
    end

    def exec
      test_failed = false
      begin
        @logger.debug("#{self.class.name}\##{__method__}") { 'Executing...' }
      rescue StandardError => e
        test_failed = true
      ensure
        set_result(test_failed, e)
      end
    end

    def to_hash
      {
        config: @config.to_hash,
        data: @data
      }
    end

    def to_json(*options)
      to_hash.to_json(*options)
    end

    private

    def set_result(test_failed, exception)
      fail?
      negate_success?(test_failed)
      negate_failure?(test_failed, exception)
    end

    def fail?
      return unless @config.fail?

      @logger.debug("#{self.class.name}\##{__method__}") { 'Scenario tagged to fail' }
      raise 'Scenario tagged to fail'
    end

    def negate_success?(test_failed)
      return unless !test_failed && @config.negate?

      @logger.debug("#{self.class.name}\##{__method__}") { 'Scenario tagged to negate' }
      raise 'Scenario tagged to negate'
    end

    def negate_failure?(test_failed, exception)
      return unless test_failed

      raise exception unless @config.negate? || @config.succeed?

      @logger.debug("#{self.class.name}\##{__method__}") { 'Negating failure' }
    end

    def load_data
      metadata = @config.metadata
      if metadata.key?('data') && metadata['data'].key?('source')
        @logger.debug("#{self.class.name}\##{__method__}") { "Loading data from #{metadata['data']['source']}" }
        return JSON.parse(File.read(metadata['data']['source']))
      end
      {}
    end

    def remap(data)
      metadata = @config.metadata
      external_remap = metadata['data']['remap'] if metadata.key?('data') && metadata['data'].key?('remap')
      Cukewrapper::Util::Remapper.new(data, external_remap, @config.inline_remaps, @logger).remap
    end
  end
end
