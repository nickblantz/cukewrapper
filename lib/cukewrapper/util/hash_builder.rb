# frozen_string_literal: true

module Cukewrapper
  # Utils for Cukewrapper
  module Util
    # Helps build hashes
    class HashBuilder
      def initialize(hash, logger)
        @logger = logger
        @internal = hash
        @cur_hash = @internal
      end

      def build!
        lambda do |data|
          return if data.nil?

          @cur_hash = @internal
          new_value = data['value'] || true
          idents = data['path'].split('.')[1..]

          @logger.debug("#{self.class.name}\##{__method__}") { "Setting path '#{data['path']}' to #{new_value}" }
          idents.each_with_index(&set_value!(idents.size, new_value))
        end
      end

      def result
        @internal
      end

      private

      def set_value!(idents_size, new_value)
        lambda do |ident, index|
          if index == idents_size - 1
            @cur_hash[ident] = new_value
          else
            @cur_hash[ident] = {} unless @cur_hash.key?(ident)
            @cur_hash = @cur_hash[ident]
          end
        end
      end
    end
  end
end
