# frozen_string_literal: true

require 'cukewrapper/util/hash_builder'

# Wraps your gherkin!
module Cukewrapper
  # Super meta bro
  class Metatags
    TAG_PATTERN = /^@(?<path>ten(?:\.[a-zA-Z]+)+)(?:=(?<value>.*))?$/.freeze unless const_defined?(:TAG_PATTERN)

    attr_reader :internal, :inline_remaps

    def initialize(tags)
      @internal = scenario_internal(tags)
      @inline_remaps = []
      Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { 'Metatags parsed' }
    end

    def [](key)
      return nil unless @internal.key?(key)

      @internal[key]
    end

    def step_data_handler(*args)
      return if args.empty?

      Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { 'Setting inline remappers' }
      @inline_remaps += args[0].raw[1..]
        .map { |arr| { path: arr[0], value: arr[1] } }
    end

    def fail?
      @internal.key?('fail') && @internal['fail']
    end

    def negate?
      @internal.key?('negate') && @internal['negate']
    end

    def succeed?
      @internal.key?('succeed') && @internal['succeed']
    end

    def to_hash
      {
        internal: @internal,
        inline_remaps: @inline_remaps
      }
    end

    def to_json(*options)
      to_hash.to_json(*options)
    end

    private

    def scenario_internal(tags)
      builder = Cukewrapper::Util::HashBuilder.new({})
      Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { 'Setting scenario metatags' }
      tags.map(&to_captures).each(&builder.build!)
      builder.result
    end

    def to_captures
      lambda do |tag|
        if (matches = TAG_PATTERN.match(tag.name))
          Cukewrapper.log.debug("#{self.class.name}\##{__method__}") { "Matched tag '#{tag.name}'" }
          matches.named_captures
        end
      end
    end
  end
end
