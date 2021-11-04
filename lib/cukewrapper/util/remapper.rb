# frozen_string_literal: true

module Cukewrapper
  # Utils for Cukewrapper
  module Util
    # Helps modify hash values
    class Remapper
      def initialize(data, external_remap, internal_remaps, logger)
        @logger = logger
        @data = data
        @external_remap = external_remap
        @internal_remaps = internal_remaps
        @logger.debug("#{self.class.name}\##{__method__}") { 'Remapper initialized' }
      end

      def remap
        external_remap!
        inline_remap!
        @data
      end

      private

      def external_remap!
        return if @external_remap.nil?

        @logger.debug("#{self.class.name}\##{__method__}") { "Running external remap at #{@external_remap}" }
        load @external_remap
        @data = data_remap(@data)
      end

      def inline_remap!
        @internal_remaps.each do |remap|
          @logger.debug("#{self.class.name}\##{__method__}") { "Remapping '#{remap[:path]}' to '#{remap[:value]}'" }
          JsonPath
            .for(@data)
            .gsub!(remap[:path], &value_remapper(remap[:value]))
        end
      end

      def value_remapper(raw)
        lambda do |current_value|
          prefix = raw[0]
          if prefix == '~'
            merge(current_value, raw[1..])
          else
            evaluate_or_parse(raw)
          end
        end
      end

      def merge(value, raw)
        @logger.debug("#{self.class.name}\##{__method__}") { "Merging value '#{raw}'" }
        parsed = evaluate_or_parse(raw)
        merge_result(value, parsed)
      end

      def merge_result(value, parsed)
        case parsed
        when Array
          value + parsed
        when Hash
          parsed.each { |k, v| value[k] = v }
          value
        when NilClass
          value
        else
          parsed
        end
      end

      def evaluate_or_parse(raw)
        prefix = raw[0]
        if prefix == '#'
          evaluate(raw[1..])
        else
          parse(raw)
        end
      end

      def evaluate(raw)
        @logger.debug("#{self.class.name}\##{__method__}") { "Evaluating '#{raw}'" }
        # rubocop:disable Security/Eval
        eval raw
        # rubocop:enable Security/Eval
      end

      def parse(raw)
        @logger.debug("#{self.class.name}\##{__method__}") { "Parsing '#{raw}'" }
        return nil if raw == ''

        JSON.parse(raw)
      end
    end
  end
end
