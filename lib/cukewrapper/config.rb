# frozen_string_literal: true

# Wraps your gherkin!
module Cukewrapper
  # Configures the executor
  class Config
    TAG_PATTERN = /^@(?<path>ten(?:\.[a-zA-Z]+)+)(?:=(?<value>.*))?$/.freeze

    attr_reader :scenario_id, :metadata, :inline_remaps

    def initialize(scenario)
      @scenario_id = scenario.id
      @metadata = scenario_metadata(scenario)
      @inline_remaps = []
    end

    def step_data_handler(*args)
      return if args.empty?

      @inline_remaps += args[0].raw[1..]
        .map { |arr| { path: arr[0], value: arr[1] } }
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

    def scenario_metadata(scenario)
      metadata = {}
      scenario
        .tags
        .map(&to_captures)
        .each(&modify_metadata!(metadata))
      metadata
    end

    def to_captures
      lambda do |tag|
        if (matches = TAG_PATTERN.match(tag.name))
          matches.named_captures
        end
      end
    end

    def modify_metadata!(hash)
      lambda do |data|
        return if data.nil?

        cur_hash = hash
        idents = data['path'].split('.')[1..]
        idents.each_with_index do |ident, i|
          if i == idents.size - 1
            cur_hash[ident] = data['value'] || true
          else
            cur_hash[ident] = {} unless cur_hash.key?(ident)
            cur_hash = cur_hash[ident]
          end
        end
      end
    end
  end
end
