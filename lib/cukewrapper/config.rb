# frozen_string_literal: true

require 'cukewrapper/util/hash_builder'

# Wraps your gherkin!
module Cukewrapper
  # Configures the executor
  class Config
    TAG_PATTERN = /^@(?<path>ten(?:\.[a-zA-Z]+)+)(?:=(?<value>.*))?$/.freeze

    attr_reader :scenario_id, :metadata, :inline_remaps

    def initialize(scenario, logger)
      @logger = logger
      @scenario_id = scenario.id
      @metadata = scenario_metadata(scenario.tags)
      @inline_remaps = []
      @logger.debug("#{self.class.name}\##{__method__}") { 'Config initialized' }
    end

    def step_data_handler(*args)
      return if args.empty?

      @logger.debug("#{self.class.name}\##{__method__}") { 'Setting inline remappers' }
      @inline_remaps += args[0].raw[1..]
        .map { |arr| { path: arr[0], value: arr[1] } }
    end

    def fail?
      @metadata.key?('fail') && @metadata['fail']
    end

    def negate?
      @metadata.key?('negate') && @metadata['negate']
    end

    def succeed?
      @metadata.key?('succeed') && @metadata['succeed']
    end

    def to_hash
      {
        scenario_id: @scenario_id,
        metadata: @metadata,
        inline_remaps: @inline_remaps
      }
    end

    def to_json(*options)
      to_hash.to_json(*options)
    end

    private

    def scenario_metadata(tags)
      builder = Cukewrapper::Util::HashBuilder.new({}, @logger)
      @logger.debug("#{self.class.name}\##{__method__}") { 'Setting scenario metadata' }
      tags.map(&to_captures).each(&builder.build!)
      builder.result
    end

    def to_captures
      lambda do |tag|
        if (matches = TAG_PATTERN.match(tag.name))
          @logger.debug("#{self.class.name}\##{__method__}") { "Matched tag '#{tag.name}'" }
          matches.named_captures
        end
      end
    end
  end
end
